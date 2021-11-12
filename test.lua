local currentDirectory = global:getCurrentScriptDirectory()

Utils = require("lanes").configure()
Utils = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Utils.lua")
Movement = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Movement.lua")
JSON = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\JSON.lua")
Zone = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Zone.lua")

RC_CHANGE_TYPE_ENUM = {
	UNKNOWN = 0,
	NORMAL = 1,
	WALK = 2,
	INTERACTIVE = 3,
	ZAAP = 4,
	ZAAPI = 5,
	HAVENBAG = 6
}

RC_LAST_CHANGE_TYPE = RC_CHANGE_TYPE_ENUM.UNKNOWN
RC_LAST_CELL_ID = map:currentCell()
RC_LAST_INTERACTIVE_CELLID = 0
RC_LAST_MAP_ID = map:currentMapId()
RC_LAST_MAP_X = map:getX(map:currentMapId())
RC_LAST_MAP_Y = map:getY(map:currentMapId())
RC_FILENAME = "Road_"..os.time(os.date("!*t"))..".lua"
RC_DIRECTION = ""

Mapper = {}
Mapper.initialized = false
Mapper.zoneToMap = {}
Mapper.mapToSave = map:currentMapId()

Mapper.finishMapped = true

Mapper.inCurrentMapToMap = false

RC_INCLUDE_CELLID = false

BannedMapId = {}

function move()
    if not Mapper.initialized then
        developer:registerMessage("ChangeMapMessage", CB_ChangeMapMessage)
        developer:registerMessage("MapComplementaryInformationsDataInHavenBagMessage", newMapAction)
        developer:registerMessage("MapComplementaryInformationsDataInHouseMessage", newMapAction)
        developer:registerMessage("MapComplementaryInformationsDataMessage", newMapAction)
        developer:registerMessage("MapComplementaryInformationsAnomalyMessage", newMapAction)
        developer:registerMessage("MapComplementaryInformationsBreachMessage", newMapAction)
        developer:registerMessage("MapComplementaryInformationsWithCoordsMessage", newMapAction)
        Mapper.initialized = true
    end

    Mapper:ZoneMapper()
end

function Mapper:ZoneMapper()
    local mapsDirection = JSON.decode(Utils:ReadFile(currentDirectory .. "\\mapsDirection.json"))

    if #self.zoneToMap < 1 then
        self.zoneToMap = Zone:GetAreaMapId(18)
    end

    if self.finishMapped then
        self:GetNextMap(mapsDirection)
    end

    if map:currentMapId() == self.mapToSave then
        self.inCurrentMapToMap = true
    else
        self.inCurrentMapToMap = false
    end

    if not self.inCurrentMapToMap then
        Utils:Print("Move to "..self.mapToSave)
        map:moveToward(self.mapToSave)
        table.insert(BannedMapId, self.mapToSave)
        self.finishMapped = true
    else
        local nextNeighbourId = self:GetNextNeighbourId(mapsDirection)

        if nextNeighbourId ~= -1 then
            Utils:Print("Move to "..nextNeighbourId)
            map:moveToward(nextNeighbourId)
            table.insert(BannedMapId, self.mapToSave)
            self.finishMapped = true    
        else
            Utils:Print("FinishedMap")
            if mapsDirection[map:currentMapId()..""] == nil then
                mapsDirection[map:currentMapId()..""] = {}
            end
            mapsDirection[map:currentMapId()..""].fullMaped = true
            self.finishMapped = true
            local mapsDirectionEncode = JSON.encode(mapsDirection)
            local mapsDirectionFile = io.open(currentDirectory .. "\\mapsDirection.json", "w")
            mapsDirectionFile:write(mapsDirectionEncode)
            mapsDirectionFile:close()
        end
    end
    self:ZoneMapper()
end

function isBannedMap(mapId)
    for _, v in pairs(BannedMapId) do
        if Utils:Equal(v, mapId) then
            return true
        end
    end
    return false
end

function printXY(mapId)
    Utils:Print("Pos de " .. mapId .. " = [" .. map:getX(mapId) .. "," .. map:getY(mapId) .. "]")
end

function Mapper:GetNextNeighbourId(mapsDirection)
    local neighbourId = { map:neighbourId("top"), map:neighbourId("bottom"), map:neighbourId("right"), map:neighbourId("left") }

    for _, vNeighbourId in pairs(neighbourId) do
        if vNeighbourId ~= 0 and neighbourMapExist(vNeighbourId) then
            local toNext = true
            if mapsDirection[map:currentMapId()..""] ~= nil then
                for _, v in pairs(mapsDirection[map:currentMapId()..""]) do
                    if v.toMapId == vNeighbourId  then
                        toNext = false
                    end
                end
            end

            if toNext then
                return vNeighbourId
            end
        end
    end
    return -1
end

function Mapper:GetNextMap(mapsDirection)
    for _, vZoneMap in pairs(self.zoneToMap) do
        Utils:Print(mapExist(vZoneMap))
        if mapExist(vZoneMap) and not isBannedMap(vZoneMap) then
            local fundMap = true
            for kMap, vMap in pairs(mapsDirection) do
                if Utils:Equal(kMap, vZoneMap) then
                    if vMap.fullMaped then
                        fundMap = false
                        break
                    end
                end
            end

            if fundMap then
                Utils:Print("Map to save "..vZoneMap)
                self.mapToSave = vZoneMap
                self.finishMapped = false
                break
            end
        end
    end
end

function newMapAction(message)
    local mapsDirection = JSON.decode(Utils:ReadFile(currentDirectory .. "\\mapsDirection.json"))

	-- Extraire les coordonnées de la carte actuelle
	local CurrentMapX = map:getX(message.mapId)
	local CurrentMapY = map:getY(message.mapId)
	local CurrentMapID = message.mapId

    if mapsDirection[CurrentMapID..""] == nil then
        mapsDirection[CurrentMapID..""] = {}
    end

    if mapsDirection[RC_LAST_MAP_ID..""] == nil then
        Utils:Print("New map entry !")
        mapsDirection[RC_LAST_MAP_ID..""] = {}
    end

	-- Havre sac ?
	if tostring(message) == "SwiftBot.MapComplementaryInformationsDataInHavenBagMessage" then
		RC_LAST_CHANGE_TYPE = RC_CHANGE_TYPE_ENUM.HAVENBAG
	end

	if RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.NORMAL then

		if (RC_LAST_MAP_X + 1) == CurrentMapX then
			RC_DIRECTION = "right"
		elseif (RC_LAST_MAP_X - 1) == CurrentMapX then
			RC_DIRECTION = "left"
		elseif (RC_LAST_MAP_Y + 1) == CurrentMapY then
			RC_DIRECTION = "bottom"
		elseif (RC_LAST_MAP_Y - 1) == CurrentMapY then
			RC_DIRECTION = "top"
		end

        global:printSuccess("Direction du déplacement: "..RC_DIRECTION)

		if RC_INCLUDE_CELLID then
		   	--roadFile:write("	"..comment.."{ map = \""..RC_LAST_MAP_ID.."\""..FIGHT_OPTION..GATHER_OPTION..RC_CUSTOM..", path = \""..RC_DIRECTION.."("..RC_LAST_CELL_ID..")\", done = false },\n}")
		else
            if mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""] == nil then
                Utils:Print("New direction for " .. RC_LAST_MAP_ID)
                mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""] = {}
                mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""].toMapId = CurrentMapID
                mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""].mapId = RC_LAST_MAP_ID
                mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""].path = RC_DIRECTION
            end
		end
	elseif RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.INTERACTIVE then
        global:printSuccess("Changement de map par l'utilisation d'un objet interactif.")
        if mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""] == nil then
            Utils:Print("New direction for " .. RC_LAST_MAP_ID)
            mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""] = {}
            mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""].toMapId = CurrentMapID
            mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""].mapId = RC_LAST_MAP_ID
            mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""].door = RC_LAST_INTERACTIVE_CELLID
        end
	elseif RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.WALK then
        global:printSuccess("Changement de map par le déplacement sur une cellule.")
        if mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""] == nil then
            Utils:Print("New direction for " .. RC_LAST_MAP_ID)
            mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""] = {}
            mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""].toMapId = CurrentMapID
            mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""].mapId = RC_LAST_MAP_ID
            mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""].door = RC_LAST_CELL_ID
        end
	elseif RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.HAVENBAG then
        global:printSuccess("Changement de map par une téléportation au havre sac.")

	elseif RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.ZAAP then
        global:printSuccess("Changement de map par l'utilisation d'un zaap.")
	elseif RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.ZAAPI then
        global:printSuccess("Changement de map par l'utilisation d'un zaapi.")
		-- Ecriture dans le fichier
        if mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""] == nil then
            Utils:Print("New direction for " .. RC_LAST_MAP_ID)
            mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""] = {}
            mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""].toMapId = CurrentMapID
            mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""].mapId = RC_LAST_MAP_ID
            mapsDirection[RC_LAST_MAP_ID..""][CurrentMapID..""].zaapi = CurrentMapID
        end

	elseif RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.UNKNOWN then
        global:printSuccess("Changement de map par une autre méthode.")
	end

    local mapsDirectionEncode = JSON.encode(mapsDirection)
    local mapsDirectionFile = io.open(currentDirectory .. "\\mapsDirection.json", "w")
    mapsDirectionFile:write(mapsDirectionEncode)
    mapsDirectionFile:close()

	-- Reset
	RC_LAST_CHANGE_TYPE = RC_CHANGE_TYPE_ENUM.UNKNOWN

	-- Sauvegarder
	RC_LAST_MAP_X = CurrentMapX
	RC_LAST_MAP_Y = CurrentMapY
	RC_LAST_MAP_ID = CurrentMapID

	-- Cellule d'entrée à une nouvelle map
	for _, actor in ipairs(message.actors) do
	    if message.actors[_].name == character:name() then
	        RC_LAST_CELL_ID = message.actors[_].disposition.cellId
	        global:printSuccess("Votre cellule dans la nouvelle map est: "..RC_LAST_CELL_ID)
	        break
	    end
	end
end

function CB_ChangeMapMessage(packet)
	RC_LAST_CHANGE_TYPE = RC_CHANGE_TYPE_ENUM.NORMAL
	if packet.mapId == map:neighbourId("top") then
		RC_DIRECTION = "top"
	elseif packet.mapId == map:neighbourId("left") then
		RC_DIRECTION = "left"
	elseif packet.mapId == map:neighbourId("right") then
		RC_DIRECTION = "right"
	elseif packet.mapId == map:neighbourId("bottom") then
		RC_DIRECTION = "bottom"
	else
		RC_DIRECTION = "unknown"
	end
end

function neighbourMapExist(mapId)
    local mapJson = JSON.decode(Utils:ReadFile(currentDirectory .. "\\PF_Maps\\" .. map:currentMapId() .. ".json"))

    Utils:Print(mapJson.topNeighbourId)
    Utils:Print(mapJson.bottomNeighbourId)
    Utils:Print(mapJson.leftNeighbourId)
    Utils:Print(mapJson.rightNeighbourId)

    if Utils:Equal(mapJson.topNeighbourId, mapId) then
        return true
    elseif Utils:Equal(mapJson.bottomNeighbourId, mapId) then
        return true
    elseif Utils:Equal(mapJson.leftNeighbourId, mapId) then
        return true
    elseif Utils:Equal(mapJson.rightNeighbourId, mapId) then
        return true
    end
    return false
end

function mapExist(mapId)
    local mapJson = JSON.decode(Utils:ReadFile(currentDirectory .. "\\PF_Maps\\" .. mapId .. ".json"))
    if mapJson then
        return true
    end
    return false
end