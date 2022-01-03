-- Ankabot Params 133432578
GATHER = {}

MIN_MONSTERS, MAX_MONSTERS = 1, 8
FORBIDDEN_MONSTERS, FORCE_MONSTERS = {}, {}

local bankMapId = 99095051

Config = dofile(global:getCurrentScriptDirectory() .. "\\Multi_Config.lua")
Info = dofile(global:getCurrentScriptDirectory() .. "\\Multi_Info.lua")
Zone = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Zone.lua")
Monsters = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Monsters.lua")
Craft = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Craft.lua")
Utils = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Utils.lua")
Graph = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Graph.lua")
Movement = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Movement.lua")
Movement.CheckHavenBag = dofile(global:getCurrentScriptDirectory() .. "\\Multi_HavenBag.lua")

-- Classes

    Worker = {}
    Time = {}
    Error = {}
    Math = {}
    Packet = {}
    Action = {}
    PathFinder = {}
    Shop = {}
    Character = {}

    -- Move
    Movement.zaapDestinations = {}

    Movement.inBank = false
    Movement.inHouse = false
    Movement.printBank = false

    Movement.configRoad = false
    Movement.mapIdToRoad = {}

    Movement.tpZoneFarm = false

    Movement.dropAction = ""

    Movement.podsMaxBeforeBank = 0

    Movement.logFarmedZone = {}
    Movement.logRZNextMapId = {}

    Movement.lastFailMapId = 0
    Movement.countFailMoveNext = 0

    Movement.excludeMapId = {
        183762952,
        183762954
    }

    Movement.monsterDropItem = {}

    Movement.pathMineLoaded = false
    Movement.pathMine = {}

    Movement.iZaapOpen = false

    function Movement:Move()
        Packet:SubManager({["LeaveDialogMessage"] = CB_LeaveDialogMessage, ["TextInformationMessage"] = CB_TextInformationMessage}, true)
        self.inBank = false

        if inventory:podsP() >= self.podsMaxBeforeBank then
            Craft.checkPossibleCraft = false
        end

        Action:OpenBags()

        Worker:WorkManager()

        Shop:ShopManager()

        Craft:CraftManager()

        if not Craft.canCraft and Craft.selectedItemToFarm and not ( Shop.needToGoHDV or Shop.needPriceUpdate ) then

            if not self.configRoad then
                self:ConfigRoad()
            end

            if self.configRoad then

                if Movement:InMapChecker(self.mapIdToRoad) then
                    local min, max = 0, 0

                    if #self.mapIdToRoad < 5 then
                        min, max = 1, 2
                    elseif #self.mapIdToRoad < 10 then
                        min, max = 2, 4
                    elseif #self.mapIdToRoad < 15 then
                        min, max = 3, 4
                    elseif #self.mapIdToRoad < 20 then
                        min, max = 4, 5
                    elseif #self.mapIdToRoad < 25 then
                        min, max = 5, 6
                    elseif #self.mapIdToRoad < 30 then
                        min, max = 6, 8
                    else
                        min, max = 7, 10
                    end

                    if Time:Timer(min, max) then
                        Utils:Print("Changement de ressource a farm", "Farming")
                        self.configRoad = false
                        self.tpZoneFarm = false
                        self.RZNextMapId = -1
                        self.mapIdToRoad = {}
                        self.pathMine = {}
                        Craft.selectedItemToFarm = false
                        return self:Move()
                    end
                end

                if self.dropAction =="fight" then
                    if Movement:InMapChecker(self.mapIdToRoad) then
                        FORCE_MONSTERS = {}
                        FORBIDDEN_MONSTERS = {}

                        local monsterGroupInfo = map:monsterGroups()

                        for _, vGroup in pairs(monsterGroupInfo) do
                            local canFight = false
                            if #vGroup.monsters >= MIN_MONSTERS and #vGroup.monsters <= MAX_MONSTERS then
                                for _, vMonster in pairs(vGroup.monsters) do
                                    for _, v in pairs(self.monsterDropItem) do
                                        if v == vMonster.id then
                                            canFight = true
                                            break
                                        end
                                    end
                                    if canFight then
                                        break
                                    end
                                end
                            end

                            if canFight then
                                table.insert(FORCE_MONSTERS, vGroup.contextualId)
                            else
                                table.insert(FORBIDDEN_MONSTERS, vGroup.contextualId)
                            end
                        end

                        --Utils:Print("Min monsters = " .. MIN_MONSTERS)
                        --Utils:Print("Max monsters = " .. MAX_MONSTERS)
                        --Utils:Dump(FORCE_MONSTERS)

                        if #FORCE_MONSTERS > 0 then
                            local printLife = false
                            while Config.minPercentLifeBeforeFight > character:lifePointsP() do
                                if not printLife then
                                    Utils:Print("Régénération des PV avant combat !", "Combat")
                                    printLife = true
                                end
                                global:delay(10)
                            end
                            map:fight()
                        end
                    end
                else
                    --Utils:Dump(GATHER)
                    Action:Gather()
                    map:gather()
                end

                Movement:RoadZone(self.mapIdToRoad)

                --Utils:Print("Apres RoadZone", "dev")
            end
        end


        Utils:Print("Fin move", "dev")

        if not Craft.canCraft then
            global:leaveDialog()
            Craft.selectedItemToFarm = false
            Time.TimerInitialized = false
            self.RoadLoaded = false
            self.tpZoneFarm = false
            self.tpBank = false
            self.configRoad = false
            self.countFailMoveNext = 0
            self.lastFailMapId = 0
            self:HavenBag()
            self:Move()
        end
    end

    function Movement:ConfigRoad()
        self.mapIdToRoad = {}
        self.pathMine = {}
        self.monsterDropItem = {}
        local mstrDrop = Monsters:GetMonsterIdByDropId(Craft.itemsToDrop[Craft.currentIndexItemToDrop].itemId)

        local function getRandSubArea(subAreaContainsResToFarm, gatherIdToFarm)
            --Utils:Print("Get rand subArea")
            self.mapIdToRoad = {}
            self.pathMine = {}
            if Utils:LenghtOfTable(self.logFarmedZone) > 10 then
                table.remove(self.logFarmedZone, 11)
            end

            local rand = global:random(1, Utils:LenghtOfTable(subAreaContainsResToFarm))

            local i = 1

            for kSubAreaId, vMaps in pairs(subAreaContainsResToFarm) do
                if i == rand then
                    --Utils:Print(Utils:LenghtOfTable(subAreaContainsResToFarm), "dev")

                    if Utils:LenghtOfTable(subAreaContainsResToFarm) > 1 then
                        local iStep = 0
                        --Utils:Print("Ici", "dev")

                         for iLog = #self.logFarmedZone, 1, -1 do
                            --Utils:Print("logFarmedGatherId = " .. self.logFarmedZone[iLog].gatherId, "dev")
                            --Utils:Print("gatherIdToFarm = " .. gatherIdToFarm, "dev")
                            if self.logFarmedZone[iLog].subAreaId == kSubAreaId then
                                --Utils:Print("Re rand")
                                getRandSubArea(subAreaContainsResToFarm, gatherIdToFarm)
                            end

                            if iStep == math.floor((#subAreaContainsResToFarm / 4) * 3) then
                                break
                            end

                            iStep = iStep + 1
                        end
                    end

                    local countResInSubArea = 0

                    for _, vMap in pairs(vMaps) do
                        for _, vGather in pairs(vMap.gatherElements) do
                            if Utils:Equal(vGather.gatherId, gatherIdToFarm) then
                                countResInSubArea = countResInSubArea + vGather.count
                            end
                        end
                    end

                    if countResInSubArea > 1 then
                        table.insert(self.logFarmedZone, { gatherId = gatherIdToFarm, subAreaId = kSubAreaId })

                        for _, vMap in pairs(vMaps) do
                            table.insert(self.mapIdToRoad, vMap.mapId)
                        end

                        break
                    else
                        getRandSubArea(subAreaContainsResToFarm, gatherIdToFarm)
                    end
                end
                i = i + 1
            end
        end

        if mstrDrop ~= nil and Utils:LenghtOfTable(mstrDrop) > 0 and Craft.itemsToDrop[Craft.currentIndexItemToDrop].itemId ~= 311 then
            Utils:Print("Fight mode", "ConfigRoad")
            self.dropAction = "fight"
            for _, v in pairs(mstrDrop) do
                local favArea = Monsters:GetFavoriteSubArea(v)

                if favArea ~= nil then
                    local subAreaMapId = Zone:GetSubAreaMapId(favArea)
                    if subAreaMapId ~= nil then
                        FORBIDDEN_MONSTERS = {}
                        FORCE_MONSTERS = {}

                        local diffTable = {
                            {350, 300, 250, 200, 150, 125, 100, 0},
                            {700, 600, 500, 450, 400, 200, 100, 0}
                        }

                        local iDiffT = 1

                        local maxLifePoint = Monsters:GetHighestLifeMonstersZone(favArea)

                        local diffPercent = Math:DiffPercent(character:maxLifePoints(), maxLifePoint)

                        if maxLifePoint < 500 then
                            iDiffT = 2
                        end

                        if diffPercent >= Utils:GetTableValue(1, diffTable[iDiffT]) then
                            MIN_MONSTERS = 1
                            MAX_MONSTERS = 8
                        elseif diffPercent >= Utils:GetTableValue(2, diffTable[iDiffT]) then
                            MIN_MONSTERS = 1
                            MAX_MONSTERS = 7
                        elseif diffPercent >= Utils:GetTableValue(3, diffTable[iDiffT]) then
                            MIN_MONSTERS = 1
                            MAX_MONSTERS = 6
                        elseif diffPercent >= Utils:GetTableValue(4, diffTable[iDiffT]) then
                            MIN_MONSTERS = 1
                            MAX_MONSTERS = 5
                        elseif diffPercent >= Utils:GetTableValue(5, diffTable[iDiffT]) then
                            MIN_MONSTERS = 1
                            MAX_MONSTERS = 4
                        elseif diffPercent >= Utils:GetTableValue(6, diffTable[iDiffT]) then
                            MIN_MONSTERS = 1
                            MAX_MONSTERS = 3
                        elseif diffPercent >= Utils:GetTableValue(7, diffTable[iDiffT]) then
                            MIN_MONSTERS = 1
                            MAX_MONSTERS = 2
                        elseif diffPercent < Utils:GetTableValue(8, diffTable[iDiffT]) then
                            MIN_MONSTERS = 1
                            MAX_MONSTERS = 1
                        end
                        
                        Utils:Print("Difficulté des monstres établie a " .. MAX_MONSTERS .. " monstres maximum dans le combat !", "Fight")

                        self.monsterDropItem = mstrDrop

                        self.mapIdToRoad = subAreaMapId
                        break
                    end
                end
            end

        else
            Utils:Print("Gather mode", "ConfigRoad")
            self.dropAction = "gather"
            GATHER = {}

            for _, vToDrop in pairs(Craft.itemsToDrop) do
                local isMonsterDrop = Monsters:GetMonsterIdByDropId(vToDrop.itemId)

                --if #isMonsterDrop == 0 or vToDrop.itemId == 311 then
                    for k, v in pairs(Info.gatherInfo) do
                        if v.objectId == vToDrop.itemId then
                            if job:level(v.jobId) < v.minLvlToFarm then
                                Utils:Print("Vous n'avez pas le niveau requis pour farm la ressouce " .. inventory:itemNameId(v.objectId), "Info")

                                local possibleResFarm = {}

                                for _, v2 in pairs(Info.gatherInfo) do
                                    if v2.jobId == v.jobId and job:level(v.jobId) >= v2.minLvlToFarm then
                                        table.insert(possibleResFarm, v2)
                                    end
                                end

                                local maxLvl = 0
                                local gatherIdToFarm = 0

                                for _, vRes in pairs(possibleResFarm) do
                                    if vRes.minLvlToFarm > maxLvl then
                                        maxLvl = vRes.minLvlToFarm
                                        gatherIdToFarm = vRes.gatherId
                                    end
                                end

                                if gatherIdToFarm == 0 then
                                    Utils:Print("GatherIdToFarm = 0", "configroad")
                                end

                                table.insert(GATHER, gatherIdToFarm)

                                if Craft.itemsToDrop[Craft.currentIndexItemToDrop].itemId == v.objectId then
                                    local subAreaContainsResToFarm = Zone:RetrieveSubAreaContainingRessource(gatherIdToFarm)

                                    getRandSubArea(subAreaContainsResToFarm, gatherIdToFarm)
                                end
                            else
                                local gatherIdToFarm = 0

                                for _, vGather in pairs(Info.gatherInfo) do
                                    if vGather.objectId == vToDrop.itemId then
                                        gatherIdToFarm = vGather.gatherId
                                        table.insert(GATHER, vGather.gatherId)
                                        break
                                    end
                                end

                                if Craft.itemsToDrop[Craft.currentIndexItemToDrop].itemId == v.objectId then
                                    local subAreaContainsResToFarm = Zone:RetrieveSubAreaContainingRessource(gatherIdToFarm)

                                    getRandSubArea(subAreaContainsResToFarm, gatherIdToFarm)
                                end
                            end
                            
                        end
                    end

                --end
            end

        end

        if Utils:LenghtOfTable(self.mapIdToRoad) > 0 then
            self.configRoad = true
        end
    end

    function Movement:RoadZone(tblMapId)
        if tblMapId ~= nil and #tblMapId > 0 then

            if map:currentMapId() == self.RZNextMapId or self.RZNextMapId == -1 then
                self.pathMineLoaded = false
                self.RZNextMapId = tblMapId[global:random(1, #tblMapId)]

                local tentaNewMap = 0

                while self:AlreadyCrossedRZNextMapId(tblMapId, self.RZNextMapId) or self:ExcludeMapId(self.RZNextMapId) do
                    --Utils:Print("Map AlreadyCrossed", "dev")
                    self.RZNextMapId = tblMapId[global:random(1, #tblMapId)]
                    tentaNewMap = tentaNewMap + 1
                    if tentaNewMap == 20 then
                        Craft.selectedItemToFarm = false
                        Time.TimerInitialized = false
                        self.RoadLoaded = false
                        self.tpZoneFarm = false
                        self.tpBank = false
                        self.configRoad = false
                        self.countFailMoveNext = 0
                        self.lastFailMapId = 0
                        self:HavenBag()
                        self:Move()
                    end
                end

                --Utils:Print("RZNextMapId = " .. self.RZNextMapId, "dev")

                table.insert(self.logRZNextMapId, self.RZNextMapId)

                if #self.logRZNextMapId > 50 then
                    table.remove(self.logRZNextMapId, 51)
                end

                --if not map:loadMove(self.RZNextMapId) then
                    --Utils:Print("Impossible de charger un chemin jusqu'a la mapId : ("..self.RZNextMapId..") changement de map avant re tentative", "RoadZone", "warn")
                --end
            end

            if not self.tpZoneFarm then
                if self:IsIncarnamMapId(map:currentMapId()) and not self:IsIncarnamMapId(self.RZNextMapId) then
                    return self:GoAstrub()
                end
                if not self:IsIncarnamMapId(self.RZNextMapId) then
                    if map:currentMap() == "0,0" then
                        self.tpZoneFarm = true
                        local nextMap = self.RZNextMapId
                        self.RZNextMapId = -1
                        self:UseZaap(nextMap)
                    else
                        self:HavenBag()
                    end
                else
                    if map:currentMap() == "0,0" then
                        self.tpZoneFarm = true
                        self:UseZaap(191105026)
                    else
                        self:HavenBag()
                    end
                end
            end

            if self.tpZoneFarm then
                developer:suspendScriptUntil("ZaapDestinationsMessage", 100, false)
                if self.iZaapOpen then
                    global:leaveDialog()
                    developer:suspendScriptUntil("LeaveDialogMessage", 100, false)
                end

                if PathFinder:IsMine(self.RZNextMapId) and PathFinder:IsMine(map:currentMapId()) then
                    if not self.pathMineLoaded then
                        self.pathMine = PathFinder:LoadPathtoMapId(self.RZNextMapId)
                        self.pathMineLoaded = true
                    end
                    PathFinder:MovePath(self.pathMine)
                    global:delay(1000)
                else
                    map:moveToward(self.RZNextMapId)
                    map:moveRandomToward(self.RZNextMapId)
                end

                if self.lastFailMapId == map:currentMapId() and self.countFailMoveNext > 25 then
                    global:leaveDialog()
                    Craft.selectedItemToFarm = false
                    Time.TimerInitialized = false
                    self.RoadLoaded = false
                    self.tpZoneFarm = false
                    self.tpBank = false
                    self.configRoad = false
                    self.countFailMoveNext = 0
                    self.lastFailMapId = 0
                    self:HavenBag()
                    self:Move()
                end

                self.lastFailMapId = map:currentMapId()
                self.countFailMoveNext = self.countFailMoveNext + 1
                self.RZNextMapId = -1
            end


            Utils:Print("Apres moveNext", "dev")
            global:leaveDialog()
            self:RoadZone(tblMapId)
        else
            Utils:Print("Table nil", "RoadZone", "error")
        end
    end

    function Movement:AlreadyCrossedRZNextMapId(tblMapId, compareMap)
        local iStep = 0

        for i = #self.logRZNextMapId, 1, -1 do
            --Utils:Print(self.logRZNextMapId[i])
            --Utils:Print(compareMap)
            --Utils:Print("--------------------")
            if self.logRZNextMapId[i] == compareMap then
                --Utils:Print("true")
                return true
            end

            iStep = iStep + 1

            if iStep == math.floor((#tblMapId / 4) * 3) then
                return false
            end
        end
        return false
    end

    function Movement:ExcludeMapId(mapId)
        for _, vMapId in pairs(self.excludeMapId) do
            if mapId == vMapId then
                return true
            end
        end
        return false
    end

    function Movement:IsIncarnamMapId(mapId)
        for _, v in pairs(Zone:GetAreaMapId(45)) do
            if v == mapId then
                return true
            end
        end
        return false
    end

    function Movement:Bank()
        Craft.selectedItemToFarm = false
        Craft.checkPossibleCraft = false
        Time.TimerInitialized = false
        self.mapIdToRoad = {}
        self.configRoad = false
        self.tpZoneFarm = false
        return self:Move()
    end

    function Movement:HavenBag()
        self.CheckHavenBag:RunCheck()

        if map:currentMap() ~= "0,0" then
            map:changeMap('havenbag')
        end
    end

    function Movement:GoBank()
        if not self.printBank then
            Utils:Print("Go bank", "bank")
            self.printBank = true
        end

        if not self.tpBank then
            self:HavenBag()

            if Config.houseMode then
                bankMapId = Config.houseInfo.houseOutsideMapId
            end

            if map:currentMap() == "0,0" then
                self.tpBank = true
                Movement:UseZaap(bankMapId)
            end
        end

        if Config.houseMode and self.inHouse then
            local inTheTrunkMap = false

            for _, v in pairs(Config.houseInfo.inHousePath) do
                if v.map == map:currentMapId() then
                    if v.inTheTrunkMap then
                        inTheTrunkMap = true
                        break
                    end

                    if v.door then
                        map:door(tonumber(v.door))
                    elseif v.path then
                        map:changeMap(v.path)
                    end
                end
            end

            if inTheTrunkMap then
                self.inBank = true
                self.printBank = false
                self.tpBank = false
                self.inHouse = false
                if Config.houseInfo.chestPassword < 0 then
                    map:door(Config.houseInfo.chestCellId)
                else
                    map:lockedStorage(Config.houseInfo.chestCellId, Config.houseInfo.chestPassword)
                end
                exchange:putAllItems()
                return Craft:CraftManager()
            end
        end

        Movement:LoadRoad(bankMapId)

        if map:currentMapId() == bankMapId and not Config.houseMode then -- Bank
            self.inBank = true
            self.printBank = false
            self.tpBank = false
            self:UseBank()
        elseif map:currentMapId() == bankMapId and Config.houseMode then -- Maison
            self.inHouse = true
            map:lockedHouse(Config.houseInfo.houseDoorCellId, Config.houseInfo.housePassword, Config.houseInfo.houseOwnerPseudo)
        else
            Movement:MoveNext()
        end
    end

    function Movement:UseZaap(mapIdDest, zaapCellId)
        local source = 3
        zaapCellId = zaapCellId or 310

        if map:currentMap() ~= "0,0" then
            source = 0
        else
            --map:door(zaapCellId)
        end

        --developer:suspendScriptUntil("ZaapDestinationsMessage", 100, false)

        local closestZaap = map:closestZaapV2(mapIdDest, Config.zaapExcepted) --self:ClosestZaap(mapIdDest)

        if closestZaap == 0 then
            map:changeMap('havenbag')
        else
            map:toZaap(closestZaap, source)
            -- Packet:SendPacket("TeleportRequestMessage", function(msg)
            --     msg.sourceType = source
            --     msg.destinationType = 0
            --     msg.mapId = closestZaap
            --     return msg
            -- end)
        end
        global:delay(1000)
    end

    function Movement:ClosestZaap(mapIdDest)
        local dist = 0
        local map = 0
        for _, v in pairs(self.zaapDestinations) do
            --local mapDistance = map:GetPathDistance(mapIdDest, v.mapId)
            local mapDistance = self:MapDistance(mapIdDest, v.mapId)
            if dist == 0 and v.cost < character:kamas() then
                dist = mapDistance
                map = v.mapId
            elseif mapDistance < dist and v.cost < character:kamas() then
                dist = mapDistance
                map = v.mapId
            end
        end
        --Utils:Print(map)

        return map
    end

    function Movement:UseBank()
        npc:npcBank(-1)
        exchange:putAllItems()
    end

    function Movement:MapDistance(mapIdStart, mapIdEnd)
        local startX = map:getX(mapIdStart)
        local startY = map:getY(mapIdStart)
        local endX = map:getX(mapIdEnd)
        local endY = map:getY(mapIdEnd)

        local iStep = 1

        local dist = 0

        if startX > endX then
            iStep = -1
        end

        for _ = startX, endX, iStep do
            dist = dist + 1
        end

        if startY > endY then
            iStep = -1
        elseif iStep == -1 then
            iStep = 1
        end

        for _ = startY, endY, iStep do
            dist = dist + 1
        end
        --Utils:Print("------------------------")
        --Utils:Print(mapIdEnd)
        --Utils:Print(dist)
        --Utils:Print("------------------------")
        return dist
    end

    function CB_ZaapDestinations(packet)
        Movement.iZaapOpen = true
        Movement.zaapDestinations = {}
        for _, v in pairs(packet.destinations) do
            table.insert(Movement.zaapDestinations, v)
        end
    end

    function CB_LeaveDialogMessage(packet)
        if packet.dialogType == 10 then
            Movement.iZaapOpen = false
        end
    end

    -- Action

    Action.statedElements = {}
    Action.integereractiveElements = {}

    Action.harvestableElements = {}

    Action.bagsId = Info.bagsId

    function Action:Gather()
        Packet:SubManager({ 
            ["MapComplementaryInformationsDataMessage"] = CB_MapComplementaryInformations,
        }, true)

        local failMessage

        developer:suspendScriptUntil("MapComplementaryInformationsDataMessage", 10, false, failMessage)

        if failMessage then
            Utils:Print(failMessage)
        end

        for _, vInteractive in pairs(self.integereractiveElements) do
            if developer:typeOf(vInteractive) == "InteractiveElementWithAgeBonus" and vInteractive.onCurrentMap then
                for _, vGather in pairs(GATHER) do
                    if vGather == vInteractive.elementTypeId then
                        table.insert(self.harvestableElements, { elementId = vInteractive.elementId })
                        break
                    end
                end
            end
        end

        for _, vHarvestableElement in pairs(self.harvestableElements) do
            for _, vStatedElement in pairs(self.statedElements) do
                if vHarvestableElement.elementId == vStatedElement.elementId then
                    vHarvestableElement.cellId = vStatedElement.elementCellId
                    break
                end
            end
        end

        self:SortHarvestableElementsByDist()

        for _, vHarvestableElement in pairs(self.harvestableElements) do
            map:door(vHarvestableElement.cellId)
        end

        self.harvestableElements = {}
    end

    function Action:SortHarvestableElementsByDist()
        local startCell = map:currentCell()
        local tmpSort = {}

        while #self.harvestableElements > 0 do
            local minDist = 1000
            local iTmp = 1
            for i = 1, #self.harvestableElements do
                local dist = Utils:ManhattanDistanceCellId(startCell, self.harvestableElements[i].cellId)
                if dist < minDist then
                    iTmp = i
                    minDist = dist
                end
            end

            startCell = self.harvestableElements[iTmp].cellId
            table.insert(tmpSort, self.harvestableElements[iTmp])
            table.remove(self.harvestableElements, iTmp)
        end

        self.harvestableElements = tmpSort
    end

    function Action:OpenBags()
        for _, idBags in pairs(self.bagsId) do
            while inventory:itemCount(idBags) > 0 do
                inventory:useItem(idBags)
            end
        end
    end

    function Action:ResetScript()
        global:leaveDialog()
        Craft.selectedItemToFarm = false
        Time.TimerInitialized = false
        Movement.RoadLoaded = false
        Movement.tpZoneFarm = false
        Movement.tpBank = false
        Movement.configRoad = false
        Movement.mapIdToRoad = {}
        Movement.countFailMoveNext = 0
        Movement.lastFailMapId = 0
        Movement:HavenBag()
        Movement:Move()
    end

    function CB_MapComplementaryInformations(packet)
        Action.statedElements = packet.statedElements
        Action.integereractiveElements = packet.integereractiveElements
    end

    -- Craft

    Craft.CraftInfo = Config.craft

    Craft.propertiesInit = false
    Craft.checkPossibleCraft = false
    Craft.canCraft = false

    Craft.itemsToDrop = {}
    Craft.selectedItemToFarm = false
    Craft.currentIndexItemToDrop = 0

    Craft.workshopInfoInitialized = false
    Craft.currentWorkshopMapId = 0
    Craft.currentWorkshopId = 0

    Craft.currentCraft = {}

    function Craft:CraftManager()
        if not self.propertiesInit then
            self:InitCraftProperties()
            self.propertiesInit = true
        end

        if not self.checkPossibleCraft and not ( Shop.needToGoHDV or Shop.needPriceUpdate ) then
            if not Movement.inBank then
                Movement:GoBank()
            end
            if Movement.inBank then
                self:CheckCraft()
            end
        end

        if not self.canCraft and self.checkPossibleCraft and not ( Shop.needToGoHDV or Shop.needPriceUpdate ) then
            local allItemDroped = true

            for _, vDrop in pairs(self.itemsToDrop) do
                if inventory:itemCount(vDrop.itemId) < vDrop.itemsToRetrieve then
                    allItemDroped = false
                end
            end

            if allItemDroped then
                Utils:Print("Tout les items nécéssaire au craft on était récupérer retour a la bank !", "Craft")
                self.checkPossibleCraft = false
                self.selectedItemToFarm = false
                Time.TimerInitialized = false
                Movement.RoadLoaded = false
                Movement.tpZoneFarm = false
                Movement.tpBank = false
                Movement.configRoad = false
                Movement.countFailMoveNext = 0
                Movement.lastFailMapId = 0
                self:CraftManager()
            end

            while not self.selectedItemToFarm do
                if Utils:LenghtOfTable(self.itemsToDrop) > 1 then
                    local rand = global:random(1, Utils:LenghtOfTable(self.itemsToDrop))

                    if rand ~= self.currentIndexItemToDrop and inventory:itemCount(self.itemsToDrop[rand].itemId) < self.itemsToDrop[rand].itemsToRetrieve then
                        self.currentIndexItemToDrop = rand
                        self.selectedItemToFarm = true
                        Utils:Print("Go drop "..inventory:itemNameId(self.itemsToDrop[rand].itemId), "Info")
                    end
                else
                    self.currentIndexItemToDrop = 1
                    self.selectedItemToFarm = true
                    Utils:Print("Go drop "..inventory:itemNameId(self.itemsToDrop[1].itemId), "Info")
                end
            end
        end

        if self.canCraft then

            if not self.workshopInfoInitialized then
                local workshopInfo = self:GetCurrentWorkShopInfo("Astrub")

                self.currentWorkshopMapId = workshopInfo.mapId

                for kSkillId, vTbl in pairs(workshopInfo.workshopId) do
                    if Utils:Equal(kSkillId, self.currentCraft.skillId) then
                        local rand = global:random(1, #vTbl)
                        self.currentWorkshopId = vTbl[rand]
                        self.workshopInfoInitialized = true
                        break
                    end
                end

                if not self.workshopInfoInitialized then
                    Utils:Print("Aucun workshop trouvée !", "CraftManager", "error")
                end
            end

            if self.workshopInfoInitialized then
                --Utils:Print("workshopInit, mapid = "..self.currentWorkshopMapId)
                Movement:LoadRoad(self.currentWorkshopMapId)

                if map:currentMapId() == self.currentWorkshopMapId then
                    map:useById(self.currentWorkshopId, -1)
                    local nbCraftedItem = 0

                    for _, vIngInfo in pairs(self.currentCraft.ingredients) do        
                        nbCraftedItem = inventory:itemCount(vIngInfo.ingredientId) / vIngInfo.quantity
                        craft:putItem(vIngInfo.ingredientId, vIngInfo.quantity)
                    end

                    for kJob, vTblCraft in pairs(self.CraftInfo) do
                        if Utils:Equal(Worker.currentJob, kJob) then
                            for _, v in pairs(vTblCraft) do
                                if v.craftId == self.currentCraft.craftId then
                                    v.currentCraftedItems = v.currentCraftedItems + nbCraftedItem
                                end
                            end
                        end
                    end

                    local lot = self:CalculMaxPossibleItemToCraft()

                    craft:changeQuantityToCraft(lot)

                    craft:ready()

                    Utils:Print("L'objet " .. inventory:itemNameId(self.currentCraft.craftId) .. " a était fabriqué par lot de x" .. lot .. " !", "Craft")

                    global:leaveDialog()

                    self.checkPossibleCraft = false
                    self:CraftManager()
                elseif map:currentMap() == "0,0" then
                    Movement:UseZaap(self.currentWorkshopMapId)
                else
                    Movement:MoveNext()
                end
            end
        end
    end

    function Craft:GetCurrentWorkShopInfo(area)
        local workshopAreaInfo = nil

        for kJob, vWorkShopAreaInfo in pairs(Info.workshopInfo) do
            if Utils:Equal(job:name(self.currentCraft.jobId), kJob) then
                workshopAreaInfo = vWorkShopAreaInfo
                break
            end
        end

        if workshopAreaInfo ~= nil then
            if Utils:Equal(area, "rand") then
                -- A faire !!!
            else
                for kArea, vWorkShopInfo in pairs(workshopAreaInfo) do
                    if Utils:Equal(kArea, area) then
                        return vWorkShopInfo
                    end
                end
            end
        end
        Utils:Print("Erreur workshopInfo = nil", "Craft:GetCurrentWorkshopMapId()", "error")
        global:finishScript()
    end

    function Craft:CheckCraft()
        local function calculItemToPick(vIng)
            local maxItemInInventory = self:CalculMaxIngredientsInInventory(self:CalculTotalWeightIng(self.currentCraft.ingredients), vIng.quantity)
            if maxItemInInventory / vIng.quantity > self.currentCraft.nbCraftBeforeNextCraft then
                maxItemInInventory = self.currentCraft.nbCraftBeforeNextCraft * vIng.quantity
            end
            return maxItemInInventory
        end

        local function checkThatAllIngToCraft(craft)
            for _, vIng in pairs(craft.ingredients) do
                if exchange:storageItemQuantity(vIng.ingredientId) < calculItemToPick(vIng) then
                    return false
                end
            end
            return true
        end

        local function addAllMissingIngToDrop(craft)
            local currentCraftName = inventory:itemNameId(self.currentCraft.craftId)
            for _, vIng in pairs(craft.ingredients) do
                local nbItemToPick = calculItemToPick(vIng)
                if exchange:storageItemQuantity(vIng.ingredientId) < nbItemToPick then
                    local craftInfo = self:GetCraftInfo(vIng.ingredientId)
                    if craftInfo ~= nil then
                        Utils:Print("Le craft (" .. currentCraftName .. ") nécéssite de fabriquée l'objet (" .. inventory:itemNameId(craftInfo.craftId) .. ") du métier " .. job:name(craftInfo.jobId), "Craft")
                        craftInfo.nbCraftBeforeNextCraft = nbItemToPick

                        if job:level(craftInfo.jobId) < craftInfo.craftLvl then
                            Utils:Print("Votre métier " .. job:name(craftInfo.jobId) .. " n'a pas le niveau requis pour crafter l'objet (" .. inventory:itemNameId(craftInfo.craftId) .. ")", "craft")
                            self.currentCraft = self:GetHighestLevelRecipeCanBeCrafted(job:name(craftInfo.jobId))
                            self.currentCraft.nbCraftBeforeNextCraft = 50
                            Utils:Print("Vous allez fabriquée l'objet (" .. inventory:itemNameId(self.currentCraft.craftId) .. ") pour monter le niveau de votre métier " .. job:name(self.currentCraft.jobId), "craft")
                        else
                            self.currentCraft = craftInfo
                        end

                        addAllMissingIngToDrop(self.currentCraft)
                    else
                        local ins = {}
                        ins.itemId = vIng.ingredientId
                        ins.itemsToRetrieve = nbItemToPick
                        table.insert(self.itemsToDrop, ins)
                    end
                end
            end
        end

        Utils:Print("Vérification des craft possible !", "Craft")

        self.currentCraft = self:GetCurrentCraft()

        self.itemsToDrop = {}

        addAllMissingIngToDrop(self.currentCraft)

        if checkThatAllIngToCraft(self.currentCraft) then
            Utils:Print("L'objet " .. inventory:itemNameId(self.currentCraft.craftId) .. " peut être crafter !", "Craft")
            self.workshopInfoInitialized = false
            Movement.configRoad = false
            Movement.tpZoneFarm = false
            Time.TimerInitialized = false
            self.canCraft = true

            local toPick = {}
            for _, vIng in pairs(self.currentCraft.ingredients) do
                table.insert(toPick, {ingredientId = vIng.ingredientId, quantity = calculItemToPick(vIng)})
            end

            for _, vIng in pairs(toPick) do
                exchange:getItem(vIng.ingredientId, vIng.quantity)
            end

            Movement.podsMaxBeforeBank = 101
        else
            self.canCraft = false
            Shop:ShopManager()
            if not Shop.needToGoHDV then
                Movement.podsMaxBeforeBank = global:random(Config.minPercentPodsBeforeBank, Config.maxPercentPodsBeforeBank)
                Utils:Print("Prochain retour a la banque a " .. Movement.podsMaxBeforeBank .. "% pods", "Info")
            else
                Movement.podsMaxBeforeBank = 101
            end
        end

        --Utils:Dump(self.itemsToDrop)

        self.checkPossibleCraft = true
        global:leaveDialog()
        map:changeMap('havenbag')
    end

    function Craft:GetHighestLevelRecipeCanBeCrafted(jobName)
        local highestCraft
        for kJob, vTblCraft in pairs(self.CraftInfo) do
            if Utils:Equal(kJob, jobName) then
                for _, vCraft in pairs(vTblCraft) do
                    local craftInfo = self:GetCraftInfo(vCraft.craftId)

                    if job:level(craftInfo.jobId) >= craftInfo.craftLvl then
                        highestCraft = craftInfo
                    else
                        return highestCraft
                    end
                end
            end
        end
    end

    function Craft:CalculTotalWeightIng(tblIng)
        local weight = 0
        for _, v in pairs(tblIng) do
            weight = weight + (inventory:itemWeight(v.ingredientId) * v.quantity)
        end
        return weight
    end

    function Craft:CalculMaxIngredientsInInventory(totalWeightIngCraft, nbIng)
        --Utils:Print("totalWeight = " .. totalWeightIngCraft .. " nbIng = " .. nbIng)
        --Utils:Print("Round " .. (math.round((inventory:podsMax() - inventory:pods()) - 100, 100)))
        return ((Math:Round((inventory:podsMax() - inventory:pods()) - 100, 100)) / totalWeightIngCraft) * nbIng
    end

    function Craft:CalculMaxPossibleItemToCraft()
        local init = true
        local maxItem = 0

        for _, vIngInfo in pairs(self.currentCraft.ingredients) do
            local tmp = inventory:itemCount(vIngInfo.ingredientId) / vIngInfo.quantity

            if tmp == 0 then
                tmp = exchange:storageItemQuantity(vIngInfo.ingredientId) / vIngInfo.quantity
            end

            if init then
                maxItem = math.floor(tmp)
            else
                if tmp < maxItem then
                    maxItem = math.floor(tmp)
                end

            end
            init = false
        end

        return maxItem
    end

    function Craft:InitCraftProperties()
        for _, vTblCraft in pairs(self.CraftInfo) do
            for _, vCraft in pairs(vTblCraft) do
                if vCraft.currentCraftedItems == nil then
                    vCraft.currentCraftedItems = 0
                end

                if vCraft.minLvlToCraft == nil then
                    vCraft.minLvlToCraft = 1
                end

                if vCraft.maxLvlToCraft == nil then
                    vCraft.maxLvlToCraft = 200
                end
            end
        end
    end

    function Craft:GetCurrentCraft(updateLimite)
        local jobLevel
        for _, v in pairs(self:GetJobCraft()) do
            jobLevel = job:level(Craft:GetJobId(v.craftId))

            if v.currentCraftedItems < v.nbCraftBeforeNextCraft and jobLevel >= Craft:GetLevel(v.craftId) and ( jobLevel >= v.minLvlToCraft and jobLevel <= v.maxLvlToCraft ) then
                local ret = Craft:GetCraftInfo(v.craftId)
                Utils:Print("L'objet " .. inventory:itemNameId(v.craftId) .. " est séléctionner !", "Craft")
                ret.craftName = v.craftName
                ret.nbCraftBeforeNextCraft = v.nbCraftBeforeNextCraft
                ret.maxCraftPerDay = v.maxCraftPerDay
                return ret
            end
        end
        if updateLimite then
            Utils:Print("Aucun craft n'a pu être séléctionner vérifier d'avoir ajouter des craft pour le métier " .. Worker.currentJob .. " de niveau inférieur ou égal a " .. jobLevel, "Craft", "error")
            global:finishScript()
        end
        self:UpdateLimitCraft()
        return self:GetCurrentCraft(true)
    end

    function Craft:UpdateLimitCraft()
        for _, v in pairs(self:GetJobCraft()) do
            v.currentCraftedItems = 0
        end
    end

    function Craft:GetJobCraft()
        for kJob, vTblCraft in pairs(self.CraftInfo) do
            if Utils:Equal(Worker.currentJob, kJob) then
                return vTblCraft
            end
        end
        return nil
    end

    -- Shop

    Shop.needToGoHDV = false
    Shop.needPriceUpdate = false
    Shop.printInfo = false
    Shop.currentInterval = Config.tradeInterval
    Shop.receivedTextInformationMessage = developer:suspendScriptUntil("TextInformationMessage", 0, false, "", 1000)

    Shop.infoHdv = {
        ["Ressources"] = { availableSpace = -1, itemsInHdv = {}, priceUpdated = false },
        ["Consommables"] = { availableSpace = -1, itemsInHdv = {}, priceUpdated = false },
        ["Runes"] = { availableSpace = -1, itemsInHdv = {}, priceUpdated = false },
        ["Equipements"] = { availableSpace = -1, itemsInHdv = {}, priceUpdated = false }
    }

    Shop.itemsToSale = {}
    Shop.itemsToBuy = {}

    Shop.remainingPods = 0

    Shop.currentMode = ""
    Shop.selectedTypeHDV = ""
    Shop.currentShopInfo = {}

    function Shop:ShopManager()

        if self.currentInterval >= Config.tradeInterval and not self.needPriceUpdate then
            Craft.checkPossibleCraft = false
        end

        if Movement.inBank then
            self.currentInterval = self.currentInterval + 1
        end

        if Movement.inBank and self.currentInterval >= Config.tradeInterval then
            Utils:Print("Vérification des items a vendre/acheter", "Trading")
            self.currentInterval = 0
            self.needPriceUpdate = true
            self:CheckItemsForTrade()
            return
        end

        if self.needToGoHDV then

            if Utils:LenghtOfTable(self.itemsToSale) > 0 then
                self.currentMode = "sale"
            elseif Utils:LenghtOfTable(self.itemsToBuy) > 0 then
                self.currentMode = "buy"
            else
                Utils:Print("Tous les items on était mit en vente/acheter", "Trade")
                self.needToGoHDV = false
            end

            if self.needToGoHDV then
                if self.currentShopInfo.shopMapId == nil then
                    self:SelectHDV(self.currentMode)
                end

                if self.currentShopInfo.shopMapId ~= nil then
                    if map:currentMapId() ~= self.currentShopInfo.shopMapId then
                        if map:currentMap() == "0,0" then
                            Movement:UseZaap(self.currentShopInfo.shopMapId)
                        end
                        Movement:LoadRoad(self.currentShopInfo.shopMapId)
                        Movement:MoveNext()
                    elseif map:currentMapId() == self.currentShopInfo.shopMapId then
                        --Utils:Print("Arrivé a l'hotel de vente", "dev")
                        self:UseHdv()
                        self.currentShopInfo = {}
                        self:ShopManager()
                    end
                end
            end
        end

        if self.needPriceUpdate and not self.needToGoHDV then
            self.currentMode = "update"
            self:SelectHdvToUpdate()

            if not self.printInfo then
                Utils:Print("Actualisation du prix des items en hotel de vente, au lancement du script le bot fera le tour des hotel de vente", "Trade")
                self.printInfo = true
            end

            if self.needPriceUpdate then
                if self.currentShopInfo.shopMapId ~= nil then
                    if map:currentMapId() ~= self.currentShopInfo.shopMapId then
                        if map:currentMap() == "0,0" then
                            Movement:UseZaap(self.currentShopInfo.shopMapId)
                        end
                        Movement:LoadRoad(self.currentShopInfo.shopMapId)
                        Movement:MoveNext()
                    elseif map:currentMapId() == self.currentShopInfo.shopMapId then
                        Utils:Print("Arrivé a l'hotel de vente", "dev")
                        self:UseHdv()
                        self.currentShopInfo = {}
                        self:ShopManager()
                    end
                end
            else
                Utils:Print("Les prix de tout les hotel de vente on était actualisé", "Trade")
                self.printInfo = false
                for _, vInfo in pairs(self.infoHdv) do
                    if Utils:LenghtOfTable(vInfo.itemsInHdv) > 0 then
                        vInfo.priceUpdated = false
                    end
                end
                Shop:ShopManager()
            end
        end

    end

    function Shop:UseHdv()
        --Utils:Print("Ouverture de l'hotel de vente en mode " .. self.currentMode, "dev")

        if self.currentMode == "sale" then
            npc:npc(self.currentShopInfo.elementId, 5)
            global:delay(10000)
            self:UpdateInfoItemsOnSale()
            self:UpdatePrice()
            self:SellItems()
        elseif self.currentMode == "update" then
            npc:npc(self.currentShopInfo.elementId, 5)
            global:delay(10000)
            self:UpdateInfoItemsOnSale()
            self:UpdatePrice()
            global:leaveDialog()
        elseif self.currentMode == "buy" then
            npc:npc(self.currentShopInfo.elementId, 6)
            global:delay(10000)
            self:BuyItems()
        end

    end

    function Shop:SellItems()
        Utils:Print("Mise en vente des items", "Trade")
        local lotConvert = { ["100"] = 3, ["10"] = 2, ["1"] = 1 }
        for _, vItem in pairs(self.itemsToSale[self.selectedTypeHDV]) do
            local maxLotToSell = self:GetMaxLotToSell(vItem.objectId)
            if maxLotToSell > 0 then
                local hdvPrice = sale:getPriceItem(vItem.objectId, lotConvert[tostring(vItem.lot)])

                if hdvPrice < vItem.minPrice then
                    Utils:Print("L'objet [" .. vItem.objectName .. "] ne peut pas être vendu pour le moment, le prix est actuellement inférieur a minPrice", "Trade")
                elseif hdvPrice > vItem.maxPrice then
                    Utils:Print("L'objet [" .. vItem.objectName .. "] ne peut pas être vendu pour le moment, le prix est actuellement supérieur a maxPrice", "Trade")
                else
                    if self.infoHdv[self.selectedTypeHDV].availableSpace == 0 then
                        Utils:Print("Plus de place dans l'hotel de vente " .. self.selectedTypeHDV, "Trade")
                        break
                    elseif self.infoHdv[self.selectedTypeHDV].availableSpace < maxLotToSell then
                        maxLotToSell = self.infoHdv[self.selectedTypeHDV].availableSpace
                    end

                    if maxLotToSell < vItem.nbLotToSell then
                        vItem.nbLotToSell = maxLotToSell
                    end

                    for _ = 1, vItem.nbLotToSell do
                        Utils:Print("Mise en vente de x" .. vItem.lot .. " [" .. vItem.objectName .. "] au prix de " .. hdvPrice .."k", "Trade")
                        self.infoHdv[self.selectedTypeHDV].availableSpace = self.infoHdv[self.selectedTypeHDV].availableSpace - 1
                        table.insert(self.infoHdv[self.selectedTypeHDV].itemsInHdv, { itemGID = vItem.objectId, lot = vItem.lot, price = hdvPrice })
                        sale:sellItem(vItem.objectId, vItem.lot, hdvPrice)
                    end
                end

            elseif maxLotToSell == 0 then
                Utils:Print("Le nombre de lot max et atteint pour l'item [" .. inventory:itemNameId(vItem.objectId) .. "]", "Trade")
            end
        end
        self.itemsToSale[self.selectedTypeHDV] = nil
        global:leaveDialog()
    end

    function Shop:BuyItems()
        Utils:Print("Achat des items", "Trade")

        for _, vItem in pairs(self.itemsToBuy[self.selectedTypeHDV]) do
            local requiredPods = vItem.quantityToBuy * inventory:itemWeight(vItem.objectId)

            if requiredPods > Character:RemainingPods() then
                for _ = vItem.quantityToBuy / vItem.lot, 0, -1 do
                    vItem.quantityToBuy = vItem.quantityToBuy - vItem.lot
                    requiredPods = vItem.quantityToBuy * inventory:itemWeight(vItem.objectId)
                    if requiredPods < Character:RemainingPods() then
                        break
                    end
                end
            end

            for _ = 1, vItem.quantityToBuy / vItem.lot do
                sale:buyItem(vItem.objectId, vItem.lot, vItem.maxPrice)
            end
        end

        self.itemsToBuy[self.selectedTypeHDV] = nil
        global:leaveDialog()
    end

    function Shop:UpdatePrice()
        Utils:Print("Actualisation des prix de l'hotel de vente " .. self.selectedTypeHDV, "Trade")
        local lotConvert = { ["100"] = 3, ["10"] = 2, ["1"] = 1 }
        for i = 1, sale:itemsOnSale() do
            local itemGID = sale:getItemGID(i)
            local lot = sale:getItemQuantity(i)
            local newPrice = sale:getPriceItem(itemGID, lotConvert[tostring(lot)])
            if sale:getItemPrice(i) ~= newPrice then
                for _, vItem in pairs(Config.salesInfo["Sale"][self.selectedTypeHDV]) do
                    if vItem.objectId == itemGID then
                        if newPrice < vItem.minPrice then
                            Utils:Print("Le prix de l'item [" .. vItem.objectName .. "] ne peut pas être actualisé, le prix et inférieur a minPrice", "Trade")
                        elseif newPrice > vItem.maxPrice then
                            Utils:Print("Le prix de l'item [" .. vItem.objectName .. "] ne peut pas être actualisé, le prix et supérieur a maxPrice", "Trade")
                        else
                            Utils:Print("Actualisation du prix de l'item [" .. vItem.objectName .. "] nouveau prix = " .. newPrice .."k", "Trade")
                            sale:editPrice(sale:getItemGUID(i), newPrice, lot)
                        end
                    end
                end
            end
        end

        self.infoHdv[self.selectedTypeHDV].priceUpdated = true
    end

    function Shop:GetMaxLotToSell(objectId)
        local maxLot = 0
        for _, vType in pairs(Config.salesInfo["Sale"]) do
            local goBreak = false
            for _, vItem in pairs(vType) do
                if vItem.objectId == objectId then
                    maxLot = vItem.maxLotInHdv
                    goBreak = true
                    break
                end
            end
            if goBreak then
                break
            end
        end

        local nbLot = 0

        for _, vType in pairs(self.infoHdv) do
            for _, vInfo in pairs(vType.itemsInHdv) do
                if vInfo.itemGID == objectId then
                    nbLot = nbLot + 1
                end
            end
            if nbLot > 0 then
                break
            end
        end

        return maxLot - nbLot
    end

    function Shop:UpdateInfoItemsOnSale()
        self.infoHdv[self.selectedTypeHDV].availableSpace = sale:availableSpace()
        self.infoHdv[self.selectedTypeHDV].itemsInHdv = {}

        for i = 1, sale:itemsOnSale() do
            table.insert(self.infoHdv[self.selectedTypeHDV].itemsInHdv, { itemGID = sale:getItemGID(i), lot = sale:getItemQuantity(i), price = sale:getItemPrice(i) })
        end

    end

    function Shop:SelectHDV(mode)
        if Utils:Equal(mode, "sale") then
            for kType, _ in pairs(self.itemsToSale) do
                --Utils:Print("Selection de l'hotel de vente " ..kType, "dev")
                self.selectedTypeHDV = tostring(kType)
                self.currentShopInfo = self:GetShopInfo("bonta", kType)
                break
            end
        else
            for kType, _ in pairs(self.itemsToBuy) do
                --Utils:Print("Selection de l'hotel de vente " ..kType, "dev")
                self.selectedTypeHDV = tostring(kType)
                self.currentShopInfo = self:GetShopInfo("bonta", kType)
                break
            end
        end
    end

    function Shop:SelectHdvToUpdate()
        local allUpdated = true
        for kType, vInfo in pairs(self.infoHdv) do
            if not vInfo.priceUpdated then
                allUpdated = false
                self.selectedTypeHDV = tostring(kType)
                self.currentShopInfo = self:GetShopInfo("bonta", kType)
                break
            end
        end
        if allUpdated then
            self.needPriceUpdate = false
        end
    end

    function Shop:GetShopInfo(area, hdvType)
        for kArea, vTbl in pairs(Info.shopInfo) do
            if Utils:Equal(kArea, area) then
                for kType, vInfo in pairs(vTbl) do
                    if Utils:Equal(kType, hdvType) then
                        return vInfo
                    end
                end
            end
        end
        Utils:Print("Impossible de trouver les info du shop " .. hdvType .. " dans la zone de " .. area, "dev")
        return nil
    end

    function Shop:CheckItemsForTrade()
        self.remainingPods = Character:RemainingPods()

        for kType, vType in pairs(Config.salesInfo["Sale"]) do
            Utils:Print("Vérification des items de type " .. kType .. " a vendre", "Trade")

            for _, vObj in pairs(vType) do
                local objectQuantity = Math:Round(exchange:storageItemQuantity(vObj.objectId), 100, "<")
                local maxLotToSell = self:GetMaxLotToSell(vObj.objectId)
                if objectQuantity >= vObj.lot and maxLotToSell > 0 then
                    if objectQuantity > vObj.lot * maxLotToSell then
                        objectQuantity = vObj.lot * maxLotToSell
                    end

                    for i = objectQuantity / vObj.lot, 0, -1 do
                        objectQuantity = vObj.lot * i
                        local requiredPods = objectQuantity * inventory:itemWeight(vObj.objectId)

                        if requiredPods < Character:RemainingPods() then
                            break
                        end
                    end

                    if objectQuantity ~= 0 then
                        local tmpObj = vObj
                        tmpObj.nbLotToSell = objectQuantity / vObj.lot

                        Utils:Print("L'item [" .. vObj.objectName .. "] peut être vendu pour " .. tmpObj.nbLotToSell .." lot de x" .. vObj.lot, kType)

                        if self.itemsToSale[kType] == nil then
                            self.itemsToSale[kType] = {}
                        end

                        table.insert(self.itemsToSale[kType], tmpObj)
                        exchange:getItem(vObj.objectId, objectQuantity)
                        self.needToGoHDV = true
                    else
                        self.currentInterval = Config.tradeInterval
                    end
                end
            end
        end

        for kType, vType in pairs(Config.salesInfo["Buy"]) do
            Utils:Print("Vérification des items de type " .. kType .. " a acheter", "Trade")

            for _, vObj in pairs(vType) do
                local base

                if vObj.minStockInBank >= 100 then
                    base = 100
                elseif vObj.minStockInBank >= 10 then
                    base = 10
                else
                    base = 1
                end

                local objectQuantity = Math:Round(exchange:storageItemQuantity(vObj.objectId), base, "<")

                if vObj.minStockInBank > objectQuantity then
                    local quantityToBuy = Math:Round(vObj.minStockInBank - objectQuantity, base, ">")
                    Utils:Print("L'item [" .. vObj.objectName .. "] a besoin d'être acheter, quantité manquante = " .. quantityToBuy, kType)

                    local requiredPods = quantityToBuy * inventory:itemWeight(vObj.objectId)

                    --Utils:Print("Remaining = " .. self.remainingPods)
                    --Utils:Print("Required = " .. requiredPods)

                    if requiredPods > self.remainingPods then
                        for _ = quantityToBuy / base, 0, -1 do
                            quantityToBuy = quantityToBuy - base
                            requiredPods = quantityToBuy * inventory:itemWeight(vObj.objectId)
                            if requiredPods < self.remainingPods then
                                break
                            end
                        end
                        self.currentInterval = Config.tradeInterval
                    end

                    if quantityToBuy > 0 then
                        self.remainingPods = self.remainingPods - requiredPods
                        local tmpObj = vObj
                        tmpObj.lot = base
                        tmpObj.quantityToBuy = quantityToBuy
                        if self.itemsToBuy[kType] == nil then
                            self.itemsToBuy[kType] = {}
                        end
                        table.insert(self.itemsToBuy[kType], tmpObj)
                        self.needToGoHDV = true
                    end
                end
            end
        end

        --Utils:Print(self.remainingPods)
        --Utils:Dump(self.itemsToBuy)
    end

    function CB_TextInformationMessage(packet)
        if tonumber(packet.msgId) == 65 then -- Vente d'un item
            for _, vInfo in pairs(Shop.infoHdv) do
                local goBreak = false
                for i = Utils:LenghtOfTable(vInfo.itemsInHdv), 1, -1 do
                    if Utils:Equal(vInfo.itemsInHdv[i].itemGID, packet.parameters[2]) then
                        --Utils:Print("Hdv updated", "dev")
                        table.remove(vInfo.itemsInHdv, i)
                        vInfo.availableSpace = vInfo.availableSpace + 1
                        goBreak = true
                        break
                    end
                end
                if goBreak then
                    break
                end
            end
        end
    end

    -- PathFinder (mine)

    PathFinder.changeMapInfo = dofile(global:getCurrentScriptDirectory() .. "\\MapGraph.lua")

    PathFinder.PFinit = false

    function PathFinder:MovePath(path)
        for _, v in pairs(path) do
            if Utils:Equal(v.map, map:currentMapId()) then
                if v.path then
                    map:changeMap(v.path)
                else
                    map:door(v.door)
                end
            end
        end
    end

    function PathFinder:LoadPathtoMapId(toMapId)
        if not self.PFinit then
            self:CreateGraph()
            self.init = true
        end
        local dijkstra = Graph:NewDijkstra()
        local pathToRet = {}
        dijkstra:run(Graph.PFgraph, map:currentMapId())

        if dijkstra:hasPathTo(toMapId) then
            local path = dijkstra:getPathTo(toMapId)

            for i = 0, path:size() - 1 do
                table.insert(pathToRet, self:GetChangeMapInfo(path:get(i):from(), path:get(i):to()))
                --Utils:Print('# from ' .. path:get(i):from() .. ' to ' .. path:get(i):to() .. ' ( distance: ' .. path:get(i).weight .. ' )')
            end

            return pathToRet
        else
            Utils:Print("Dijkstra ne trouve aucun path pour la mapId ("..toMapId..")", "dev", "error")
            Action:ResetScript()
        end
    end

    function PathFinder:GetChangeMapInfo(fromMapId, toMapId)
        for _, vMap in pairs(self.changeMapInfo) do
            if Utils:Equal(vMap.mapId, fromMapId) then
                for _, vChangeMap in pairs(vMap.moveMapInfo) do
                    if Utils:Equal(vChangeMap.toMapId, toMapId) then
                        if vChangeMap.path then
                            return { map = fromMapId, path = vChangeMap.path }
                        else
                            return { map = fromMapId, door = vChangeMap.door }
                        end
                    end
                end
            end
        end
        return nil
    end

    function PathFinder:IsMine(compareMap)
        for _, vMap in pairs(self.changeMapInfo) do
            if Utils:Equal(vMap.mapId, compareMap) then
                return true
            end
        end
        return false
    end

    function PathFinder:CreateGraph()
        Graph.PFgraph = Graph:NewGraph(1, true)
        for _, vMap in pairs(self.changeMapInfo) do
            for _, vInfo in pairs(vMap.moveMapInfo) do
                Graph.PFgraph:addEdge(vMap.mapId, vInfo.toMapId, 1.0)
            end
        end
    end

    -- Worker

    Worker.init = false
    Worker.nextTimeToReassignJob = ""
    Worker.currentJob = ""

    function Worker:WorkManager()
        if not self.init or self.nextTimeToReassignJob == os.date("%H:%M") then
            self:AssignJob()
        end
    end

    function Worker:AssignJob()
        local jobAssign = false
        local day = os.date("%A")
        local hour, minute = Utils:GenerateDateTime("h"), Utils:GenerateDateTime("m")

        for kDay, vTbl in pairs(Config.wortimeJob) do
            --Utils:Print(kDay .. " | " .. day)
            if Utils:Equal(kDay, day) then
                for _, v in pairs(vTbl) do
                    local hourStart, minuteStart = tonumber(string.match(v.startTime, "%d%d")), tonumber(string.match(v.startTime, "%d%d", 2))
                    local hourFinish, minuteFinish = tonumber(string.match(v.finishTime, "%d%d")), tonumber(string.match(v.finishTime, "%d%d", 2))
                    --Utils:Print(hour .. ":" .. minute)
                    --Utils:Print(hourStart .. ":" .. minuteStart .. " | " .. hourFinish .. ":" .. minuteFinish)
                    if hourFinish == 0 then
                        hourFinish = 24
                    end
                    if ((hour == hourStart and minute >= minuteStart) or hour > hourStart) and ((hour == hourFinish and minute < minuteFinish) or hour < hourFinish) then
                        self.currentJob = string.lower(v.job)
                        self.nextTimeToReassignJob = v.finishTime
                        jobAssign = true
                        Utils:Print("Métier "..self.currentJob.." assigné !", "JOB")
                        break
                    end
                end

            end

            if jobAssign then
                break
            end
        end

        if not jobAssign then
            Error:ErrorManager("Impossible d'assigner un métier, vérifier la table WORKTIME", "AssignJob")          
        end

        --SetJobId()

        if self.init then
            Utils:Print("Changement de métier, go farm le métier "..self.currentJob, "job")
            --ResetScript()
            return --FinDeBoucle()
        else
            self.init = true
        end
    end

    -- Time

    Time.TimerInitialized = false
    Time.TimerHourStart = 0
    Time.TimerMinuteStart = 0
    Time.TimerRandTimeToWait = 0

    function Time:Timer(min, max)
        min = min or Config.minMinutesOnFarmingZone
        max = max or Config.maxMinutesOnFarmingZone

        if not self.TimerInitialized then
            self.TimerRandTimeToWait = global:random(min, max)
            Utils:Print("Changement de zone dans "..self.TimerRandTimeToWait.." minutes", "Timer")
            self.TimerHourStart, self.TimerMinuteStart = Utils:GenerateDateTime("h"), Utils:GenerateDateTime("m")
            self.TimerInitialized = true
        end

        local curH, curM = Utils:GenerateDateTime("h"), Utils:GenerateDateTime("m")

        if self:DiffTime(self.TimerHourStart, self.TimerMinuteStart, curH, curM) >= self.TimerRandTimeToWait then
            self.TimerInitialized = false
            self.TimerHourStart = 0
            self.TimerMinuteStart = 0
            self.TimerRandTimeToWait = 0
            return true
        end
        return false
    end

    function Time:DiffTime(hStart, mStart, hFinish, mFinish)
        local diffTimeMin = 0
        local cond = (tonumber(hStart) == tonumber(hFinish)) and (tonumber(mStart) == tonumber(mFinish))
        while not cond do
            if tonumber(mStart) >= 60 then
                hStart = hStart + 1
                mStart = 0
            end
            if tonumber(hStart) >= 24 then
                hStart = 0
            end
            diffTimeMin = diffTimeMin + 1
            mStart = mStart + 1
            cond = (tonumber(hStart) == tonumber(hFinish)) and (tonumber(mStart) == tonumber(mFinish))
            if diffTimeMin > 2880 then
                return diffTimeMin
            end
        end
        return diffTimeMin
    end

    -- Packet

    function Packet:SubManager(packetToSub, register)
        for kPacketName, vCallBack in pairs(packetToSub) do
            if register then -- Abonnement au packet
                if not developer:isMessageRegistred(kPacketName) then
                    Utils:Print("Abonnement au packet : "..kPacketName, "packet")
                    developer:registerMessage(kPacketName, vCallBack)
                end            
            else -- Désabonnement des packet
                if developer:isMessageRegistred(kPacketName) then
                    --Print("Désabonnement du packet : "..packetName, "packet")
                    developer:unRegisterMessage(kPacketName)
                end
            end
        end
    end

    function Packet:SendPacket(packetName, fn)
        Utils:Print("Envoie du packet "..packetName, "packet")
        local msg = developer:createMessage(packetName)

        if fn ~= nil then
            msg = fn(msg)
        end

        developer:sendMessage(msg)
    end

    -- Erreur

    function Error:ErrorManager(msgError, funcName)
        Utils:Print(msgError..", arrêt du script", funcName, "error")
        global:finishScript()
    end

    -- Monsters

    function Monsters:GetHighestLifeMonstersZone(subArea)
        local monstersZone = Zone:GetSubAreaMonsters(subArea)
        local maxLife = 0
        for _, v in pairs(monstersZone) do
            local infoMonsters = Monsters:GetMonstersInfoByGrade(v, 5)
            if infoMonsters.lifePoints > maxLife then
                maxLife = infoMonsters.lifePoints
            end
        end
        return maxLife
    end

    -- Character

    function Character:RemainingPods()
        return inventory:podsMax() - inventory:pods()
    end

    -- Math

    function Math:DiffPercent(a, b)
        return (a - b) / b * 100
    end

    function Math:Round(v, bracket, upperOrLower)
        bracket = bracket or 1
        upperOrLower = upperOrLower or "<"
        if upperOrLower == "<" then
            return math.floor(v/bracket) * bracket
        else
            return math.ceil(v/bracket) * bracket
        end
    end

-- Ankabot Main Func

function move()
    while true do
        Movement:Move()
    end
end

function bank()
    return Movement:Bank()
end

function phenix()
    Utils:Print("Votre personnage et en fantôme !", "Info")
end