-- Parametre utilisateur
local minMinutesOnFarmingZone, maxMinutesOnFarmingZone = 5, 13
local minPercentPodsBeforeBank, maxPercentPodsBeforeBank = 30, 90

local minPercentLifeBeforeFight = 80

local WORKTIME_JOB = {
    ["Lundi"] = {
        { startTime = "05:12", finishTime = "10:14", job = "Mineur" },
        { startTime = "10:14", finishTime = "23:04", job = "Bricoleur" },
        { startTime = "12:04", finishTime = "13:12", job = "Pause" },
        { startTime = "13:12", finishTime = "15:22", job = "Bucheron" },
        { startTime = "15:22", finishTime = "17:43", job = "Mineur" },
        { startTime = "17:43", finishTime = "20:58", job = "Alchimiste" },
        { startTime = "20:58", finishTime = "23:22", job = "Bucheron" },
        { startTime = "23:22", finishTime = "05:12", job = "Pause" },
    },
    ["Mardi"] = {
        { startTime = "20:12", finishTime = "23:45", job = "Mineur" },
        { startTime = "06:07", finishTime = "23:50", job = "Alchimiste" }
    },
    ["Mercredi"] = {
        { startTime = "10:00", finishTime = "23:45", job = "Bricoleur" },
        { startTime = "23:45", finishTime = "08:50", job = "Alchimiste" }
    },
    ["Jeudi"] = {
        { startTime = "02:10", finishTime = "23:50", job = "Bricoleur" },
        { startTime = "19:50", finishTime = "19:55", job = "Chasse au trésor" },
        { startTime = "13:13", finishTime = "13:14", job = "" }      
    },
    ["Vendredi"] = {
        { startTime = "06:10", finishTime = "10:30", job = "Mineur" },
        { startTime = "10:30", finishTime = "11:00", job = "Alchimiste" },
        { startTime = "11:00", finishTime = "12:00", job = "Bucheron" },
        { startTime = "12:00", finishTime = "23:24", job = "Bricoleur" },

    },
    ["Samedi"] = {
        { startTime = "10:00", finishTime = "23:59", job = "Bricoleur" }
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
OPEN_BAGS = true
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
    Argent = { name = "Argent", gatherId = 24, objectId = 312, jobId = 24, minLvlToFarm = 120 },
    Bauxite = { name = "Bauxite", gatherId = 26, objectId = 446, jobId = 24, minLvlToFarm = 140 },
    Or = { name = "Or", gatherId = 25, objectId = 312, jobId = 24, minLvlToFarm = 160 },
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

-- Classes

    Worker = {}
    Time = {}
    Error = {}
    Math = {}

    -- Move
    Movement.savedZaap = {}

    Movement.inBank = false
    Movement.printBank = false

    Movement.goToSaveZaap = false
    Movement.goToMapId  = 0


    Movement.configRoad = false
    Movement.mapIdToRoad = {}

    Movement.dropAction = ""

    Movement.podsMaxBeforeBank = 0

    Movement.lastSubAreaFarmed = 0

    function Movement:Move()
        self.inBank = false

        if self.goToSaveZaap then
            if map:currentMapId() ~= self.goToMapId then
                Movement:LoadRoad(self.goToMapId)
                Movement:MoveNext()
            else
                self.goToSaveZaap = false
                self.goToMapId = 0
            end
        end

        if inventory:podsP() >= self.podsMaxBeforeBank then
            Craft.checkPossibleCraft = false
        end

        Worker:WorkManager()

        Craft:CraftManager()

        if not Craft.canCraft and Craft.selectedItemToFarm then

            if not self.configRoad then
                self:ConfigRoad()
            end

            if self.configRoad then

                if self.dropAction =="fight" then
                    if Movement:InMapChecker(self.mapIdToRoad) then
                        local printLife = false
                        while minPercentLifeBeforeFight > character:lifePointsP() do
                            if not printLife then
                                Utils:Print("Régénération des PV avant combat !", "Combat")
                                printLife = true
                            end
                            global:delay(1)
                        end
                        map:fight()
                    end
                else
                    map:gather()
                end

                if Time:Timer() then
                    Utils:Print("Changement de ressource a farm", "Farming")
                    self.configRoad = false
                    Craft.selectedItemToFarm = false
                    self:Move()
                end

                Movement:RoadZone(self.mapIdToRoad)
            end
        end
    end

    function Movement:RoadZone(tblMapId)
        if tblMapId ~= nil and Utils:LenghtOfTable(tblMapId) > 0 then
            if map:currentMapId() == self.RZNextMapId or self.RZNextMapId == -1 then

                self.RZNextMapId = tblMapId[global:random(1, Utils:LenghtOfTable(tblMapId))]

                local dist = map:GetPathDistance(map:currentMapId(), self.RZNextMapId)

                if dist > 20 then
                    self:HavenBag()
                end

                if not map:loadMove(self.RZNextMapId) then
                    Utils:Print("Impossible de charger un chemin jusqu'a la mapId : ("..self.RZNextMapId..") changement de map avant re tentative", "RoadZone", "warn")
                end
            end

            if map:currentMap() == "0,0" then
                local nextMap = self.RZNextMapId
                self.RZNextMapId = -1
                self:UseZaap(nextMap)
            end

            self:MoveNext()

            --Utils:Print("Apres MoveNext", "RoadZone")
            self.RZNextMapId = -1
            self:RoadZone(tblMapId)
        else
            Utils:Print("Table nil", "RoadZone", "error")
        end
    end

    function Movement:ConfigRoad()
        self.mapIdToRoad = {}
        local mstrDrop = Monsters:GetMonsterIdByDropId(Craft.ItemsToDrop[Craft.currentIndexItemToDrop].itemId)

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
                            MIN_MONSTERS = 4
                            MAX_MONSTERS = 8
                        elseif diffPercent >= 100 then
                            MIN_MONSTERS = 4
                            MAX_MONSTERS = 6
                        elseif diffPercent >= 75 then
                            MIN_MONSTERS = 3
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

                        table.insert(FORCE_MONSTERS, v)

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
                        local possibleResFarm = {}

                        Utils:Print("Vous n'avez pas le niveau requis pour farm la ressouce " .. inventory:itemNameId(v.objectId), "Info")
                        for _, v2 in pairs(GatherInfo) do
                            if v2.jobId == v.jobId and job:level(v.jobId) >= v2.minLvlToFarm then
                                table.insert(possibleResFarm, v2)
                            end
                        end

                        local maxLvl = 0
                        local gatherIdToFarm = 0

                        for _, v in pairs(possibleResFarm) do
                            if v.minLvlToFarm > maxLvl then
                                maxLvl = v.minLvlToFarm
                                gatherIdToFarm = v.gatherId
                            end
                        end

                        table.insert(GATHER, gatherIdToFarm)

                        local subAreaContainsResToFarm = Zone:RetrieveSubAreaContainingRessource(gatherIdToFarm)

                        local function getRandSubArea()

                            local rand = global:random(1, Utils:LenghtOfTable(subAreaContainsResToFarm))

                            local i = 1

                            for kSubAreaId, vMaps in pairs(subAreaContainsResToFarm) do
                                if i == rand then
                                    if self.lastSubAreaFarmed == kSubAreaId and Utils:LenghtOfTable(subAreaContainsResToFarm) > 1 then
                                        getRandSubArea()
                                    end
                                    self.lastSubAreaFarmed = kSubAreaId
                                    self.mapIdToRoad = vMaps
                                    break
                                end
                                i = i + 1
                            end
                        end

                        getRandSubArea()
                    else
                        Utils:Print("Test", "Info")
                    end
                end
            end
        end

        if Utils:LenghtOfTable(self.mapIdToRoad) > 0 then
            self.configRoad = true
        end
    end

    function Movement:Bank()
        Craft.checkPossibleCraft = false
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

    function Movement:UseZaap(mapIdDest)
        local source = 3
        if map:currentMap() ~= "0,0" then
            source = 0
        end

        map:toZaap(self:CanUseZaap(mapIdDest), source)
    end

    function Movement:UseBank()
        npc:npcBank(-1)
        exchange:putAllItems()
    end

    function Movement:CanUseZaap(mapIdDest)
        developer:registerMessage("ZaapDestinationsMessage", CB_ZaapDestinationsMessage)
        local closestZaap = map:closestZaap(mapIdDest)
        developer:suspendScriptUntil("ZaapDestinationsMessage", 100, false)
        developer:unRegisterMessage("ZaapDestinationsMessage")

        for _, v in pairs(self.savedZaap) do
            if Utils:Equal(v, closestZaap) then
                return closestZaap
            end
        end

        self.goToSaveZaap = true
        self.goToMapId = closestZaap
        global:leaveDialog()
        if map:currentMap() == "0,0" then
            map:changeMap('havenbag')
        end
    end

    function CB_ZaapDestinationsMessage(packet)
        for _, v in pairs(packet.destinations) do
            local alreadySaved = false
            for _, v2 in pairs(Movement.savedZaap) do
                if Utils:Equal(v.mapId, v2) then
                    alreadySaved = true
                    break
                end
            end
            if not alreadySaved then
                table.insert(Movement.savedZaap, v.mapId)
            end
        end
    end
    -- Timem

    Time.TimerInitialized = false
    Time.TimerHourStart = 0
    Time.TimerMinuteStart = 0
    Time.TimerRandTimeToWait = 0

    function Time:Timer()
        if not self.TimerInitialized then
            self.TimerRandTimeToWait = global:random(minMinutesOnFarmingZone, maxMinutesOnFarmingZone)
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

    -- Craft

    Craft.CraftInfo = {
        ["Bricoleur"] = {
            {
                craftName = "Clef des Champs",
                craftId = 8143,
                nbCraftBeforeNextCraft = 50,
                maxCraftPerDay = 1000
            }
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

        if not self.canCraft then
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
                    --A faire !!!
                end
            end

            if self.workshopInfoInitialized then
                Movement:LoadRoad(self.currentWorkshopMapId)

                if map:currentMapId() == self.currentWorkshopMapId then
                    map:useById(self.currentWorkshopId, -1)

                    for _, vIngInfo in pairs(self.currentCraft.ingredients) do                       
                        craft:putItem(vIngInfo.ingredientId, vIngInfo.quantity)
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

            maxItemInInventory = global:random(1, maxItemInInventory)

            if exchange:storageItemQuantity(vIng.ingredientId) < maxItemInInventory then
                self.canCraft = false
                local ins = {}
                ins.itemId = vIng.ingredientId
                ins.itemsToRetrieve = maxItemInInventory
                table.insert(self.ItemsToDrop, ins)
            end
        end

        if self.canCraft then
            local maxPossibleItemToCraft = self:CalculMaxPossibleItemToCraft()

            Utils:Print(maxPossibleItemToCraft)

            for _, vIngInfo in pairs(self.currentCraft.ingredients) do
                exchange:getItem(vIngInfo.ingredientId, vIngInfo.quantity * maxPossibleItemToCraft)
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
        return ((math.round((inventory:podsMax() - inventory:pods()) - 100, 100)) / totalWeightIngCraft) * nbIng
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
    return Movement:Move()
end

function bank()
    return Movement:Bank()
end

function math.sign(v) -- Dependance de math.round
    return (v >= 0 and 1) or -1
end

function math.round(v, bracket) -- Sert a arrondir un nombre
    bracket = bracket or 1
    return math.floor(v/bracket + math.sign(v) * 0.5) * bracket
end