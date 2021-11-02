-- Parametre utilisateur
local minMinutesOnFarmingZone, maxMinutesOnFarmingZone = 3, 5
local minPercentPodsBeforeBank, maxPercentPodsBeforeBank = 70, 90

local minPercentLifeBeforeFight = 80

local WORKTIME_JOB = {
    ["Lundi"] = {
        { startTime = "05:14", finishTime = "23:59", job = "Mineur" },
    },
    ["Mardi"] = {
        { startTime = "06:07", finishTime = "23:50", job = "Mineur" }
    },
    ["Mercredi"] = {
        { startTime = "06:00", finishTime = "23:45", job = "Bricoleur" },
    },
    ["Jeudi"] = {
        { startTime = "02:10", finishTime = "23:50", job = "Bricoleur" },
        { startTime = "19:50", finishTime = "19:55", job = "Chasse au trésor" },
        { startTime = "13:13", finishTime = "13:14", job = "" }
    },
    ["Vendredi"] = {
        { startTime = "06:00", finishTime = "23:59", job = "Bricoleur" },

    },
    ["Samedi"] = {
        { startTime = "06:00", finishTime = "23:59", job = "Bricoleur" }
    },
    ["Dimanche"] = {
        { startTime = "00:02", finishTime = "23:50", job = "Bricoleur" },
        { startTime = "03:22", finishTime = "07:12", job = "Pause" },
        { startTime = "07:12", finishTime = "10:14", job = "Alchimiste" },
        { startTime = "10:14", finishTime = "12:04", job = "Alchimiste" },
        { startTime = "12:04", finishTime = "13:12", job = "Pause" },
        { startTime = "13:12", finishTime = "15:22", job = "Bucheron" },
        { startTime = "15:22", finishTime = "17:43", job = "Mineur" },
        { startTime = "17:43", finishTime = "20:58", job = "Alchimiste" },
        { startTime = "20:58", finishTime = "23:22", job = "Bucheron" },
        { startTime = "23:22", finishTime = "05:12", job = "Pause" }
    }
}

-- Ankabot Params
GATHER = {}

MIN_MONSTERS, MAX_MONSTERS = 1, 8
FORBIDDEN_MONSTERS, FORCE_MONSTERS = {}, {}


local GatherInfo = {
    -- Bucheron
    Frene =  { name = "Frêne", gatherId = 1, objectId = 303, jobId = 2, minLvlToFarm = 1 },
    Chataignier =  { name = "Châtaignier", gatherId = 33, objectId = 473, jobId = 2, minLvlToFarm = 20 },
    Noyer = { name = "Noyer", gatherId = 34, objectId = 476, jobId = 2, minLvlToFarm = 40 },
    Chene = { name = "Chêne", gatherId = 8, objectId = 460, jobId = 2, minLvlToFarm = 60 },
    Bombu = { name = "Bombu", gatherId = 98, objectId = 2358, jobId = 2, minLvlToFarm = 70 },
    Erable = { name = "Erable", gatherId = 31, objectId = 471, jobId = 2, minLvlToFarm = 80 },
    Oliviolet = { name = "Oliviolet", gatherId = 101, objectId = 2357, jobId = 2, minLvlToFarm = 90 },
    If = { name = "If", gatherId = 28, objectId = 461, jobId = 2, minLvlToFarm = 100 },
    Bambou = { name = "Bambou", gatherId = 108, objectId = 7013, jobId = 2, minLvlToFarm = 110 },
    Merisier = { name = "Merisier", gatherId = 35, objectId = 474, jobId = 2, minLvlToFarm = 120 },
    Noisetier = { name = "Noisetier", gatherId = 259, objectId = 16488, jobId = 2, minLvlToFarm = 130 },
    Ebene = { name = "Ebène", gatherId = 29, objectId = 449, jobId = 2, minLvlToFarm = 140 },
    Kaliptus = { name = "Kaliptus", gatherId = 121, objectId = 7925, jobId = 2, minLvlToFarm = 150 },
    Charme = { name = "Charme", gatherId = 32, objectId = 472, jobId = 2, minLvlToFarm = 160 },
    BambouSombre = { name = "Bambou Sombre", gatherId = 109, objectId = 7016, jobId = 2, minLvlToFarm = 170 },
    Orme = { name = "Orme", gatherId = 30, objectId = 470, jobId = 2, minLvlToFarm = 180 },
    BambouSacre = { name = "Bambou Sacré", gatherId = 110, objectId = 7014, jobId = 2, minLvlToFarm = 190 },
    Tremble = { name = "Tremble", gatherId = 133, objectId = 11107, jobId = 2, minLvlToFarm = 200 },
    -- Alchimiste
    Ortie = { name = "Ortie", gatherId = 254, objectId = 421, jobId = 26, minLvlToFarm = 1 },
    Sauge = { name = "Sauge", gatherId = 255, objectId = 428, jobId = 26, minLvlToFarm = 20 },
    Trefle = { name = "Trèfle à 5 feuilles", gatherId = 67, objectId = 395, jobId = 26, minLvlToFarm = 40 },
    MentheSauvage = { name = "Menthe Sauvage", gatherId = 66, objectId = 380, jobId = 26, minLvlToFarm = 60 },
    OrchideeFreyesque = { name = "Orchidée Freyesque", gatherId = 68, objectId = 593, jobId = 26, minLvlToFarm = 80 },
    Edelweiss = { name = "Edelweiss", gatherId = 61, objectId = 594, jobId = 26, minLvlToFarm = 100 },
    Pandouille = { name = "Graine de pandouille", gatherId = 112, objectId = 7059, jobId = 26, minLvlToFarm = 120 },
    Ginseng = { name = "Ginseng", gatherId = 256, objectId = 16385, jobId = 26, minLvlToFarm = 140 },
    Belladone = { name = "Belladone", gatherId = 257, objectId = 16387, jobId = 26, minLvlToFarm = 160 },
    Mandragore = { name = "Mandragore", gatherId = 258, objectId = 16389, jobId = 26, minLvlToFarm = 180 },
    PerceNeige = { name = "Perce-Neige", gatherId = 131, objectId = 11102, jobId = 26, minLvlToFarm = 200 },
    Salikrone = { name = "Salikrone", gatherId = 288, objectId = 17992, jobId = 26, minLvlToFarm = 200 },
    TulipeEnPapier = { name = "Tulipe en papier", gatherId = 364, objectId = 23824, jobId = 26, minLvlToFarm = 200 },
    -- Mineur
    Fer = { name = "Fer", gatherId = 17, objectId = 312, jobId = 24, minLvlToFarm = 1 },
    Cuivre = { name = "Cuivre", gatherId = 53, objectId = 441, jobId = 24, minLvlToFarm = 20 },
    Bronze = { name = "Bronze", gatherId = 55, objectId = 442, jobId = 24, minLvlToFarm = 40 },
    Kobalte = { name = "Kobalte", gatherId = 37, objectId = 443, jobId = 24, minLvlToFarm = 60 },
    Manganese = { name = "Manganèse", gatherId = 54, objectId = 445, jobId = 24, minLvlToFarm = 80 },
    Etain = { name = "Etain", gatherId = 52, objectId = 444, jobId = 24, minLvlToFarm = 100 },
    Silicate = { name = "Silicate", gatherId = 114, objectId = 7032, jobId = 24, minLvlToFarm = 100 },
    Argent = { name = "Argent", gatherId = 24, objectId = 350, jobId = 24, minLvlToFarm = 120 },
    Bauxite = { name = "Bauxite", gatherId = 26, objectId = 446, jobId = 24, minLvlToFarm = 140 },
    Or = { name = "Or", gatherId = 25, objectId = 313, jobId = 24, minLvlToFarm = 160 },
    Dolomite = { name = "Dolomite", gatherId = 113, objectId = 7033, jobId = 24, minLvlToFarm = 180 },
    Obsidienne = { name = "Obsidienne", gatherId = 135, objectId = 11110, jobId = 24, minLvlToFarm = 200 },
    -- Paysan
    Ble = { name = "Blé", gatherId = 38, objectId = 289, jobId = 28, minLvlToFarm = 1 },
    Orge = { name = "Orge", gatherId = 43, objectId = 400, jobId = 28, minLvlToFarm = 20 },
    Avoine = { name = "Avoine", gatherId = 45, objectId = 533, jobId = 28, minLvlToFarm = 40 },
    Houblon = { name = "Houblon", gatherId = 39, objectId = 401, jobId = 28, minLvlToFarm = 60 },
    Lin = { name = "Lin", gatherId = 42, objectId = 423, jobId = 28, minLvlToFarm = 80 },
    Riz = { name = "Riz", gatherId = 111, objectId = 7018, jobId = 28, minLvlToFarm = 100 },
    Seigle = { name = "Seigle", gatherId = 44, objectId = 532, jobId = 28, minLvlToFarm = 100 },
    Malt = { name = "Malt", gatherId = 47, objectId = 405, jobId = 28, minLvlToFarm = 120 },
    Chanvre = { name = "Chanvre", gatherId = 46, objectId = 425, jobId = 28, minLvlToFarm = 140 },
    Mais = { name = "Maïs", gatherId = 260, objectId = 16454, jobId = 28, minLvlToFarm = 160 },
    Millet = { name = "Millet", gatherId = 261, objectId = 16456, jobId = 28, minLvlToFarm = 180 },
    Frostiz = { name = "Frostiz", gatherId = 134, objectId = 11109, jobId = 28, minLvlToFarm = 200 },
    -- Autres
    Puits = { name = "Puits", gatherId = 84, objectId = 311, jobId = 2, minLvlToFarm = 1 }
}

local bankMapId = 192415750

Zone = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Zone.lua")
Monsters = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Monsters.lua")
Movement = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Movement.lua")
Craft = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Craft.lua")
Utils = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Utils.lua")
Graph = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Graph.lua")

-- Classes

    Worker = {}
    Time = {}
    Error = {}
    Math = {}
    Packet = {}
    Action = {}
    PathFinder = {}

    -- Move
    Movement.zaapDestinations = {}

    Movement.inBank = false
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

    function Movement:Move()
        self.inBank = false

        if inventory:podsP() >= self.podsMaxBeforeBank then
            Craft.checkPossibleCraft = false
        end

        Action:OpenBags()

        Worker:WorkManager()

        Craft:CraftManager()

        if not Craft.canCraft and Craft.selectedItemToFarm then

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
                        Craft.selectedItemToFarm = false
                        self:Move()
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
                            while minPercentLifeBeforeFight > character:lifePointsP() do
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
                    --map:gather()
                end

                Movement:RoadZone(self.mapIdToRoad)

                --Utils:Print("Apres RoadZone", "dev")
            end
        end

        Utils:Print("Fin move", "dev")

        if not Craft.canCraft then
            self.RoadLoaded = false
            self.tpBank = false
            self.tpZoneFarm = false
            Craft.selectedItemToFarm = false
        end
    end

    function Movement:ConfigRoad()
        self.mapIdToRoad = {}
        self.monsterDropItem = {}
        local mstrDrop = Monsters:GetMonsterIdByDropId(Craft.ItemsToDrop[Craft.currentIndexItemToDrop].itemId)

        local function getRandSubArea(subAreaContainsResToFarm, gatherIdToFarm)
            self.mapIdToRoad = {}
            Utils:Print("Get rand subArea")
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
                            Utils:Print("logFarmedGatherId = " .. self.logFarmedZone[iLog].gatherId, "dev")
                            Utils:Print("gatherIdToFarm = " .. gatherIdToFarm, "dev")
                            if self.logFarmedZone[iLog].gatherId == gatherIdToFarm then
                                Utils:Print("logFarmedSubAreaId = " .. self.logFarmedZone[iLog].subAreaId, "dev")
                                Utils:Print("kSubAreaId = " .. kSubAreaId, "dev")

                                if self.logFarmedZone[iLog].subAreaId == kSubAreaId then
                                    Utils:Print("Re rand")
                                    getRandSubArea(subAreaContainsResToFarm, gatherIdToFarm)
                                end
                            end

                            if iStep == math.ceil((#subAreaContainsResToFarm / 4) * 3) then
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

                    if countResInSubArea > 10 and Utils:LenghtOfTable(subAreaContainsResToFarm) > 1 then
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

        if mstrDrop ~= nil and Utils:LenghtOfTable(mstrDrop) > 0 then
            Utils:Print("Fight mode", "ConfigRoad")
            self.dropAction = "fight"
            for _, v in pairs(mstrDrop) do
                local favArea = Monsters:GetFavoriteSubArea(v)

                if favArea ~= nil then
                    local subAreaMapId = Zone:GetSubAreaMapId(favArea)
                    if subAreaMapId ~= nil then
                        FORBIDDEN_MONSTERS = {}
                        FORCE_MONSTERS = {}

                        local monsterInfo = Monsters:GetMonstersInfoByGrade(v, 5)

                        local diffPercent = Math:DiffPercent(character:level(), monsterInfo.level)

                        if diffPercent >= 150 then
                            MIN_MONSTERS = 2
                            MAX_MONSTERS = 8
                        elseif diffPercent >= 100 then
                            MIN_MONSTERS = 2
                            MAX_MONSTERS = 6
                        elseif diffPercent >= 75 then
                            MIN_MONSTERS = 2
                            MAX_MONSTERS = 5
                        elseif diffPercent >= 50 then
                            MIN_MONSTERS = 2
                            MAX_MONSTERS = 3
                        elseif diffPercent >= 25 then
                            MIN_MONSTERS = 1
                            MAX_MONSTERS = 3
                        elseif diffPercent >= 0 then
                            MIN_MONSTERS = 1
                            MAX_MONSTERS = 2
                        elseif diffPercent < 0 then
                            MIN_MONSTERS = 1
                            MAX_MONSTERS = 1
                        end

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

            for k, v in pairs(GatherInfo) do
                if v.objectId == Craft.ItemsToDrop[Craft.currentIndexItemToDrop].itemId then
                    if job:level(v.jobId) < v.minLvlToFarm then
                        Utils:Print(job:level(v.jobId), "Dev")
                        Utils:Print(v.minLvlToFarm, "Dev")
                        global:delay(10000)
                        local possibleResFarm = {}

                        Utils:Print("Vous n'avez pas le niveau requis pour farm la ressouce " .. inventory:itemNameId(v.objectId), "Info")
                        for _, v2 in pairs(GatherInfo) do
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

                        local subAreaContainsResToFarm = Zone:RetrieveSubAreaContainingRessource(gatherIdToFarm)

                        getRandSubArea(subAreaContainsResToFarm, gatherIdToFarm)
                    else
                        local gatherIdToFarm = 0

                        for _, vGather in pairs(GatherInfo) do
                            if vGather.objectId == Craft.ItemsToDrop[Craft.currentIndexItemToDrop].itemId then
                                gatherIdToFarm = vGather.gatherId
                                table.insert(GATHER, vGather.gatherId)
                                break
                            end
                        end

                        local subAreaContainsResToFarm = Zone:RetrieveSubAreaContainingRessource(gatherIdToFarm)

                        getRandSubArea(subAreaContainsResToFarm, gatherIdToFarm)
                    end
                end
            end
        end

        if Utils:LenghtOfTable(self.mapIdToRoad) > 0 then
            self.configRoad = true
        end
    end

    function Movement:IsIncarnamMapId(mapId)
        for _, v in pairs(Zone:GetAreaMapId(45)) do
            if v == mapId then
                return true
            end
        end
        return false
    end

    function Movement:RoadZone(tblMapId)
        if tblMapId ~= nil and #tblMapId > 0 then

            if map:currentMapId() == self.RZNextMapId or self.RZNextMapId == -1 then
                self.pathMineLoaded = false
                self.RZNextMapId = tblMapId[global:random(1, #tblMapId)]

                while self:AlreadyCrossedRZNextMapId(tblMapId, self.RZNextMapId) or self:ExcludeMapId(self.RZNextMapId) do
                    --Utils:Print("Map AlreadyCrossed", "dev")
                    self.RZNextMapId = tblMapId[global:random(1, #tblMapId)]
                end

                Utils:Print("RZNextMapId = " .. self.RZNextMapId, "dev")

                table.insert(self.logRZNextMapId, self.RZNextMapId)

                if #self.logRZNextMapId > 50 then
                    table.remove(self.logRZNextMapId, 51)
                end

                --if not map:loadMove(self.RZNextMapId) then
                    --Utils:Print("Impossible de charger un chemin jusqu'a la mapId : ("..self.RZNextMapId..") changement de map avant re tentative", "RoadZone", "warn")
                --end
            end

            if not self.tpZoneFarm then
                if self:MapDistance(map:currentMapId(), self.RZNextMapId) > 20 and not self:IsIncarnamMapId(self.RZNextMapId) then
                    if map:currentMap() == "0,0" then
                        self.tpZoneFarm = true
                        local nextMap = self.RZNextMapId
                        self.RZNextMapId = -1
                        self:UseZaap(nextMap)
                    else
                        self:HavenBag()
                    end
                else
                    self.tpZoneFarm = true
                    if map:currentMap() == "0,0" then
                        map:changeMap('havenbag')
                    end
                end
            end

            if self.tpZoneFarm then
                if PathFinder:IsMine(self.RZNextMapId) and PathFinder:IsMine(map:currentMapId()) then
                    if not self.pathMineLoaded then
                        self.pathMine = PathFinder:LoadPathtoMapId(self.RZNextMapId)
                        self.pathMineLoaded = true
                    end
                    PathFinder:MovePath(self.pathMine)
                    global:delay(1000)
                else
                    for _ = 1, 10 do
                        map:moveToward(self.RZNextMapId)
                    end
                end

                if self.lastFailMapId == map:currentMapId() and self.countFailMoveNext > 100 then
                    Craft.selectedItemToFarm = false
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

            if iStep == math.ceil((#tblMapId / 4) * 3) then
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

    function Movement:Bank()
        Craft.selectedItemToFarm = false
        Craft.checkPossibleCraft = false
        self.tpZoneFarm = false
        return self:Move()
    end

    function Movement:HavenBag()
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

            if map:currentMap() == "0,0" then
                self.tpBank = true
                Movement:UseZaap(bankMapId)
            end
        end

        Movement:LoadRoad(bankMapId)

        if map:currentMapId() == bankMapId then
            self.inBank = true
            self.printBank = false
            self.tpBank = false
            self:UseBank()
        else
            Movement:MoveNext()
        end
    end

    function Movement:UseZaap(mapIdDest, zaapCellId)
        local source = 3
        zaapCellId = zaapCellId or 310

        developer:registerMessage("ZaapDestinationsMessage", CB_ZaapDestinations)

        if map:currentMap() ~= "0,0" then
            source = 0
        else
            map:door(zaapCellId)
        end

        developer:suspendScriptUntil("ZaapDestinationsMessage", 100, false)
        developer:unRegisterMessage("ZaapDestinationsMessage")

        local closestZaap = self:ClosestZaap(mapIdDest)

        if closestZaap == 0 then
            map:changeMap('havenbag')
        else
            Packet:SendPacket("TeleportRequestMessage", function(msg)
                msg.sourceType = source
                msg.destinationType = 0
                msg.mapId = closestZaap
                return msg
            end)
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
        Movement.zaapDestinations = {}
        for _, v in pairs(packet.destinations) do
            table.insert(Movement.zaapDestinations, v)
        end
    end

    -- Action

    Action.statedElements = {}
    Action.integereractiveElements = {}

    Action.harvestableElements = {}

    Action.bagsId = {
        -- Paysan
        7941,
        7942,
        7943,
        7944,
        7945,
        7946,
        7947,
        7948,
        7949,
        11113,
        16532,
        16533,


        -- Bucheron
        7950,
        7951,
        7952,
        7953,
        7954,
        7955,
        7956,
        7957,
        7958,
        7959,
        7960,
        7961,
        7962,
        7963,
        7996,
        8081,
        11112,
        16531,

        -- Alchimiste

        7964,
        7965,
        7966,
        7967,
        7968,
        7969,
        7970,
        11103,
        16528,
        16529,
        16530,
        18059,
        24041,

        -- Mineur

        7971,
        7972,
        7973,
        7974,
        7975,
        7976,
        7977,
        7978,
        7979,
        7980,
        7981,
        11114,

        -- Pecheur

        7982,
        7983,
        7984,
        7985,
        7986,
        7987,
        7988,
        7989,
        7990,
        7991,
        7992,
        7993,
        7994,
        7995,
        11111,
        16534,
        16535,
        16536,
        16537,
        16538,
        16539,


    }

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

        for _, vHarvestableElement in pairs(self.harvestableElements) do
            map:door(vHarvestableElement.cellId)
        end

        self.harvestableElements = {}
    end

    function Action:SortHarvestableElementsByDist()
        for _, vHarvestableElement in pairs(self.harvestableElements) do
            vHarvestableElement.dist = Utils:ManhattanDistanceCellId(map:currentCell(), vHarvestableElement.cellId)
        end

        table.sort(self.harvestableElements, function(a, b)
            return a.dist < b.dist
        end)

        local iSort = 1

        while true do
            local minDist = 1000
            local iModif = 1

            if iSort == #self.harvestableElements then
                self.harvestableElements[iSort].dist = 1000
                break
            end

            for i, vHarvestableElement in ipairs(self.harvestableElements) do
                local clcDist = Utils:ManhattanDistanceCellId(self.harvestableElements[iSort].cellId, vHarvestableElement.cellId)
                if clcDist < minDist and clcDist ~= 0 then
                    minDist = clcDist
                    iModif = i
                end
            end

            self.harvestableElements[iModif].dist = minDist

            iSort = iSort + 1
        end

        table.sort(self.harvestableElements, function(a, b)
            return a.dist > b.dist
        end)
    end

    function Action:OpenBags()
        for _, idBags in pairs(self.bagsId) do
            while inventory:itemCount(idBags) > 0 do
                inventory:useItem(idBags)
            end
        end
    end

    function CB_MapComplementaryInformations(packet)
        Action.statedElements = packet.statedElements
        Action.integereractiveElements = packet.integereractiveElements
    end

    -- Craft

    Craft.CraftInfo = {
        ["Bricoleur"] = {
            {
                craftName = "Clef des Champs",
                craftId = 8143,
                nbCraftBeforeNextCraft = 50,
                maxCraftPerDay = 1000
            }
        },
        ["Mineur"] = {
            {
                craftName = "Aluminite",
                craftId = 747,
                nbCraftBeforeNextCraft = 50,
                maxCraftPerDay = 1000,
                toolType = "Fondre"
            },
        }
    }

    Craft.propertiesInit = false
    Craft.checkPossibleCraft = false
    Craft.canCraft = false

    Craft.ItemsToDrop = {}
    Craft.selectedItemToFarm = false
    Craft.currentIndexItemToDrop = 0

    Craft.workshopInfoInitialized = false
    Craft.currentWorkshopMapId = 0
    Craft.currentWorkshopId = 0
    Craft.toolType = ""

    Craft.currentCraft = {}

    Craft.craftQueue = {}

    function Craft:CraftManager()
        if not self.propertiesInit then
            self:InitCraftProperties()
            self.propertiesInit = true
        end

        if not self.checkPossibleCraft then
            if not Movement.inBank then
                Movement:GoBank()
            end
            if Movement.inBank then
                self:CheckCraft()
            end
        end

        if not self.canCraft and self.checkPossibleCraft then
            while not self.selectedItemToFarm do
                if Utils:LenghtOfTable(self.ItemsToDrop) > 1 then
                    local rand = global:random(1, Utils:LenghtOfTable(self.ItemsToDrop))

                    if rand ~= self.currentIndexItemToDrop and inventory:itemCount(self.ItemsToDrop[rand].itemId) < self.ItemsToDrop[rand].itemsToRetrieve then
                        self.currentIndexItemToDrop = rand
                        self.selectedItemToFarm = true
                        Utils:Print("Go drop "..inventory:itemNameId(self.ItemsToDrop[rand].itemId), "Info")
                    end
                else
                    self.currentIndexItemToDrop = 1
                    self.selectedItemToFarm = true
                    Utils:Print("Go drop "..inventory:itemNameId(self.ItemsToDrop[1].itemId), "Info")
                end
            end
        end

        if self.canCraft then

            if not self.workshopInfoInitialized then
                local workshopInfo = self:GetCurrentWorkShopInfo("Astrub")

                self.currentWorkshopMapId = workshopInfo.mapId

                if workshopInfo.singleWorkshopJob then
                    local rand = global:random(1, #workshopInfo.workshopId)

                    self.currentWorkshopId = workshopInfo.workshopId[rand]

                    self.workshopInfoInitialized = true
                else
                    for kToolType, vTbl in pairs(workshopInfo.workshopId) do
                        if Utils:Equal(kToolType, self.currentCraft.toolType) then
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

                    craft:changeQuantityToCraft(self:CalculMaxPossibleItemToCraft())

                    craft:ready()
                    global:leaveDialog()

                    self.checkPossibleCraft = false
                    self:CraftManager()
                else
                    Movement:MoveNext()
                end
            end
        end
    end

    function Craft:GetCurrentWorkShopInfo(area)
        local workshopAreaInfo = nil

        for kJob, vWorkShopAreaInfo in pairs(Movement.WorkshopInfo) do
            if Utils:Equal(Worker.currentJob, kJob) then
                workshopAreaInfo = vWorkShopAreaInfo
                break
            end
        end

        if workshopAreaInfo ~= nil then
            if Utils:Equal(area, "rand") then
                -- A faire !!!
            else
                local workshopInfo = nil

                for kArea, vWorkShopInfo in pairs(workshopAreaInfo) do

                    if Utils:Equal(kArea, area) then
                        workshopInfo = vWorkShopInfo
                        break
                    end
                end

                if workshopInfo ~= nil then
                    return workshopInfo
                end
            end
        end
        Utils:Print("Erreur workshopInfo = nil", "Craft:GetCurrentWorkshopMapId()", "error")
        global:finishScript()
    end

    function Craft:CheckCraft()
        Utils:Print("Check craft", "Info")

        self.currentCraft = self:GetCurrentCraft()

        -- Verif si ingredient = craft a faire

        self.canCraft = true

        for _, vIng in pairs(self.currentCraft.ingredients) do
            local maxItemInInventory = self:MaxPossibleItemInInventoryForCraft(self:CalculTotalWeightIng(self.currentCraft.ingredients), vIng.quantity)

            if exchange:storageItemQuantity(vIng.ingredientId) < maxItemInInventory then
                self.canCraft = false
                local ins = {}
                ins.itemId = vIng.ingredientId
                ins.itemsToRetrieve = maxItemInInventory
                table.insert(self.ItemsToDrop, ins)
            end
        end

        if self.canCraft then
            for _, vIngInfo in pairs(self.currentCraft.ingredients) do
                exchange:getItem(vIngInfo.ingredientId, self:MaxPossibleItemInInventoryForCraft(self:CalculTotalWeightIng(self.currentCraft.ingredients), vIngInfo.quantity))
            end

            Movement.podsMaxBeforeBank = 101
            Utils:Print("Can craft")
        else
            Movement.podsMaxBeforeBank = global:random(minPercentPodsBeforeBank, maxPercentPodsBeforeBank)
            Utils:Print("Prochain retour a la banque a " .. Movement.podsMaxBeforeBank .. "% pods", "Info")
        end

        self.checkPossibleCraft = true
        global:leaveDialog()
    end

    function Craft:CalculTotalWeightIng(tblIng)
        local weight = 0
        for _, v in pairs(tblIng) do
            weight = weight + (inventory:itemWeight(v.ingredientId) * v.quantity)
        end
        return weight
    end

    function Craft:CalculMaxPossibleItemToCraft()
        local init = false
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
            init = true
        end


        return maxItem
    end

    function Craft:InitCraftProperties()
        for _, vTblCraft in pairs(self.CraftInfo) do
            for _, vCraft in pairs(vTblCraft) do
                if vCraft.currentCraftedItems == nil then
                    vCraft.currentCraftedItems = 0
                end
            end
        end
    end

    function Craft:GetCurrentCraft()
        for _, v in pairs(self:GetJobCraft()) do
            if v.currentCraftedItems < v.nbCraftBeforeNextCraft and job:level(Craft:GetJobId(v.craftId)) >= Craft:GetLevel(v.craftId) then
                local ret = Craft:GetCraftInfo(v.craftId)
                ret.craftName = v.craftName
                if v.toolType then
                    ret.toolType = v.toolType
                end
                return ret
            end
        end
        return nil
    end

    function Craft:GetJobCraft()
        for kJob, vTblCraft in pairs(self.CraftInfo) do
            if Utils:Equal(Worker.currentJob, kJob) then
                return vTblCraft
            end
        end
        return nil
    end

    function Craft:MaxPossibleItemInInventoryForCraft(totalWeightIngCraft, nbIng)
        --Utils:Print("totalWeight = " .. totalWeightIngCraft .. " nbIng = " .. nbIng)
        return ((math.round((inventory:podsMax() - inventory:pods()) - 100, 100)) / totalWeightIngCraft) * nbIng
    end

    -- PathFinder (mine)

    PathFinder.changeMapInfo = {
        -- Mine Hérale
        ["97261059"] = {
            mapId = 97261059,
            moveMapInfo = {
                { path =  417, toMapId = 97260033 }
            }
        },
        ["97260033"] = {
            mapId = 97260033,
            moveMapInfo = {
                { path =  405, toMapId = 97261057 },
                { path =  183, toMapId = 97261059 },
    
            }
        },
        ["97261057"] = {
            mapId = 97261057,
            moveMapInfo = {
                { path = 421, toMapId = 97259011 },
                { path = 235, toMapId = 97255939 },
                { path = 487, toMapId = 97257987 },
                { path = 227, toMapId = 97260033 }
            }
        },
        ["97259011"] = {
            mapId = 97259011,
            moveMapInfo = {
                { path = 276, toMapId = 97261057 }
            }
        },
        ["97255939"] = {
            mapId = 97255939,
            moveMapInfo = {
                { path = 478, toMapId = 97261057 },
                { path = 446, toMapId = 97256963 }
            }
        },
        ["97256963"] = {
            mapId = 97256963,
            moveMapInfo = {
                { path = 172, toMapId = 97255939 },
                { path = 492, toMapId = 97257987 }
            }
        },
        ["97257987"] = {
            mapId = 97257987,
            moveMapInfo = {
                { path = 249, toMapId = 97256963 },
                { path = 212, toMapId = 97261057 },
                { path = 492, toMapId = 97260035 }
            }
        },
        ["97260035"] = {
            mapId = 97260035,
            moveMapInfo = {
                { path = 288, toMapId = 97257987 }
            }
        },
        -- Mine Astirite
        ["97261071"] = {
            mapId = 97261071,
            moveMapInfo = {
                { path = 248, toMapId = 97260047 }
            }
        },
        ["97260047"] = {
            mapId = 97260047,
            moveMapInfo = {
                { path = 379, toMapId = 97261071 },
                { path = 432, toMapId = 97257999 }
            }
        },
        ["97257999"] = {
            mapId = 97257999,
            moveMapInfo = {
                { path = 268, toMapId = 97260047 },
                { path = 247, toMapId = 97259023 },
                { path = 403, toMapId = 97256975 },
            }
        },
        ["97259023"] = {
            mapId = 97259023,
            moveMapInfo = {
                { path = 451, toMapId = 97257999 }
            }
        },
        ["97256975"] = {
            mapId = 97256975,
            moveMapInfo = {
                { path = 323, toMapId = 97257999 },
                { path = 497, toMapId = 97255951 }
            }
        },
        ["97255951"] = {
            mapId = 97255951,
            moveMapInfo = {
                { path = 203, toMapId = 97256975 }
            }
        },
        -- Mine porco 1
        ["30670848"] = {
            mapId = 30670848,
            moveMapInfo = {
                { path = 344, toMapId = 30671107 }
            }
        },
        ["30671107"] = {
            mapId = 30671107,
            moveMapInfo = {
                { path = 298, toMapId = 30670848 },
                { path = 247, toMapId = 30671110 }
            }
        },
        ["30671110"] = {
            mapId = 30671110,
            moveMapInfo = {
                { path = 479, toMapId = 30671107 },
                { path = 188, toMapId = 30671116 }
            }
        },
        ["30671116"] = {
            mapId = 30671116,
            moveMapInfo = {
                { path = 292, toMapId = 30671110 }
            }
        },
    }

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
        local path = dijkstra:getPathTo(toMapId)

        for i = 0,path:size()-1 do
            table.insert(pathToRet, self:GetChangeMapInfo(path:get(i):from(), path:get(i):to()))
            --Utils:Print('# from ' .. path:get(i):from() .. ' to ' .. path:get(i):to() .. ' ( distance: ' .. path:get(i).weight .. ' )')
        end

        return pathToRet
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
                Graph.PFgraph:addEdge(vMap.mapId, vInfo.toMapId, 1.0) -- edge from 0 to 1 is 5.0 in distance
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

        for kDay, vTbl in pairs(WORKTIME_JOB) do
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
        min = min or minMinutesOnFarmingZone
        max = max or maxMinutesOnFarmingZone

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
        while true do
            if hStart == hFinish and mStart == mFinish then
                return diffTimeMin
            end
            if mStart == 60 then
                hStart = hStart + 1
                mStart = 0
            end
            if hStart == 24 then
                hStart = 0  
            end
            diffTimeMin = diffTimeMin + 1
            mStart = mStart + 1
        end
    end

    -- Packet
    function Packet:SubManager(packetToSub, register)
        for kPacketName, vCallBack in pairs(packetToSub) do
            if register then -- Abonnement au packet
                if not developer:isMessageRegistred(kPacketName) then
                    --Print("Abonnement au packet : "..packetName, "packet")
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

    -- Math

    function Math:DiffPercent(a, b)
        return (a - b) / b * 100
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

function math.sign(v) -- Dependance de math.round
    return (v >= 0 and 1) or -1
end

function math.round(v, bracket) -- Sert a arrondir un nombre
    bracket = bracket or 1
    return math.floor(v/bracket) * bracket
end