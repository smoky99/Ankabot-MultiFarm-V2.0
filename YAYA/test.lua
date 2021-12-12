Zone = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Zone.lua")
Monsters = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Monsters.lua")
Movement = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Movement.lua")
Utils = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Utils.lua")
Graph = nil

ChangeMapInfo = {
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

function move()
    local path = constructPath(97260035)
    Utils:Dump(path)
end

function constructPath(toMapId)
    if Graph == nil then
        Graph = newGraph(1, true)
        for _, vMap in pairs(ChangeMapInfo) do

            for _, vInfo in pairs(vMap.moveMapInfo) do
                Graph:addEdge(vMap.mapId, vInfo.toMapId, 1.0) -- edge from 0 to 1 is 5.0 in distance
            end
        end
    end

    local pathToRet = {}
    local dijkstra = newDijkstra()
    dijkstra:run(Graph, 97261059)--map:currentMapId())

    Utils:Print(dijkstra:hasPathTo(97261059))
    Utils:Print(dijkstra:hasPathTo(972610))

    local path = dijkstra:getPathTo(toMapId)

    for i = 0,path:size()-1 do
        table.insert(pathToRet, getChangeMapInfo(path:get(i):from(), path:get(i):to()))
        --Utils:Print('# from ' .. path:get(i):from() .. ' to ' .. path:get(i):to() .. ' ( distance: ' .. path:get(i).weight .. ' )')
    end

    --return pathToRet
end

function getChangeMapInfo(fromMapId, toMapId)
    for _, vMap in pairs(ChangeMapInfo) do
        if Utils:Equal(vMap.mapId, fromMapId) then
            for _, vChangeMap in pairs(vMap.moveMapInfo) do
                if Utils:Equal(vChangeMap.toMapId, toMapId) then
                    if vChangeMap.path then
                        return { map = fromMapId, path = vChangeMap.path }
                    else
                        return { map = fromMapId, path = vChangeMap.door }
                    end
                end
            end
        end
    end
    return nil
end

function newGraph(vertex, directed)
    return dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Graph\\data\\graph.lua").create(vertex, directed)
end

function newDijkstra()
    return dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Graph\\shortest_paths\\Dijkstra.lua").create()
end