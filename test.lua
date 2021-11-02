Utils = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Utils.lua")
Movement = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Movement.lua")

PathFinder = {}

function move()
    if PathFinder:IsMine(97255939) then
        PathFinder:MovePath(PathFinder:LoadPathtoMapId(97255939))
    end
    global:delay(1000)
end

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
}

PathFinder.logTestedPath = {}
PathFinder.trashPath = {}
PathFinder.excludeMapId = {}

PathFinder.pathBeingBuilt = {}

PathFinder.iGetMap = 0

function PathFinder:MovePath(path)
    for _, v in pairs(path) do
        if Utils:Equal(v.fromMapId, map:currentMapId()) then
            map:changeMap(v.path)
        end
    end
end

function PathFinder:LoadPathtoMapId(toMapId)
    local fromMapId = map:currentMapId()

    while true do
        local nextMap = self:FindNextMap(fromMapId)

        if nextMap then
            self.iGetMap = self.iGetMap + 1
            table.insert(self.pathBeingBuilt, nextMap)
            if nextMap.toMapId == toMapId then
                local ret = self.pathBeingBuilt
                self.pathBeingBuilt = {}
                self.trashPath = {}
                self.logTestedPath = {}
                self.iGetMap = 0
                return ret
            end
            fromMapId = nextMap.toMapId
            --Utils:Dump(self.pathBeingBuilt, 50)
        else
            local trashPath = { iFail = self.iGetMap, path = self.pathBeingBuilt }
            self.iGetMap = 0
            fromMapId = map:currentMapId()
            table.insert(self.trashPath, trashPath)
            self.pathBeingBuilt = {}
            --Utils:Print("--------------------------------")
        end
    end
end

function PathFinder:FindNextMap(fromMapId)
    --Utils:Print("FindNextMap fromMapId = " .. fromMapId .. " toMapId = " .. toMapId)
    --global:delay(100)

    for _, vMapInfo in pairs(self.changeMapInfo) do
        if vMapInfo.mapId == fromMapId then
            local possibility = Utils:LenghtOfTable(vMapInfo.moveMapInfo)

            vMapInfo.moveMapInfo = Utils:ShuffleTbl(vMapInfo.moveMapInfo)

            for i, vMap in ipairs(vMapInfo.moveMapInfo) do
                if not self:IsHalfTurn(vMap.toMapId) and not self:IsLoop(vMap.toMapId) and not self:IsExcludeMapId(vMap.toMapId) then
                    if not self:PossibilityReached(vMap.toMapId) and not self:CheckTrashPath(vMap.toMapId, self.iGetMap)  then
                        self:LogMap(fromMapId, vMap.toMapId, possibility)
                        return { fromMapId = fromMapId, toMapId = vMap.toMapId, path = vMap.path }
                    else
                    end
                elseif not self:CheckTrashPath(vMap.toMapId, self.iGetMap) then
                    self:LogMap(fromMapId, vMap.toMapId, possibility)
                end
            end

            table.insert(self.excludeMapId, fromMapId)
        end
    end
    return nil
end

function PathFinder:LogMap(fromMapId, toMapId, possibility)
    fromMapId, toMapId = tostring(fromMapId), tostring(toMapId)

    if self.logTestedPath[fromMapId] == nil then
        --Utils:Print("new log "..fromMapId)
        self.logTestedPath[fromMapId] = { fromMapId = fromMapId, toMapId = toMapId, possibility = possibility, usedPossibility = 0 }
    end

    if self:PossibilityReached(toMapId) or possibility == 1 and not (map:currentMapId() == fromMapId and possibility == 1) then
        --Utils:Print("usedPossibility for "..fromMapId.." +1")
        self.logTestedPath[fromMapId].usedPossibility = self.logTestedPath[fromMapId].usedPossibility + 1
    elseif possibility == 1 and not (map:currentMapId() == fromMapId and possibility == 1) then
        --Utils:Print("Dans le elseIf "..fromMapId)
        self.logTestedPath[fromMapId].usedPossibility = self.logTestedPath[fromMapId].usedPossibility + 1
    end
end

function PathFinder:PossibilityReached(toMapId)
    for _, v in pairs(self.logTestedPath) do
        if Utils:Equal(v.fromMapId, toMapId) then
            if v.usedPossibility >= v.possibility then
                --Utils:Print(toMapId .. " Possibility reached")
                return true
            end
        end
    end
    return false
end

function PathFinder:IsExcludeMapId(mapId)
    for _, v in pairs(self.excludeMapId) do
        if Utils:Equal(v, mapId) then
            --Utils:Print(mapId .. "  exclude")
            return true
        end
    end
    return false
end

function PathFinder:IsHalfTurn(toMapId)
    local lenght = #self.pathBeingBuilt

    if lenght > 0 and self.pathBeingBuilt[lenght].fromMapId == toMapId then
        --Utils:Print(toMapId .. "  is halfTurn")
        return true
    end
    return false
end

function PathFinder:CheckTrashPath(toMapId, iMap)
    for _, vTrash in pairs(self.trashPath) do
        if Utils:Equal(vTrash.iFail, iMap) then
            if Utils:Equal(vTrash.path[#vTrash.path].fromMapId, toMapId) then
                --Utils:Print(toMapId .. "  is trashPath")

                return true
            end
        end
    end
    return false
end

function PathFinder:IsLoop(toMapId)
    for _, v in pairs(self.pathBeingBuilt) do
        if Utils:Equal(v.fromMapId, toMapId) then
            --Utils:Print(toMapId .. "  is loop")
            return true
        end
    end

    return false
end

function PathFinder:IsMine(compareMap)
    for _, vMap in pairs(self.changeMapInfo) do
        if Utils:Equal(vMap.mapId, compareMap) then
            return true
        end
    end
    return false
end