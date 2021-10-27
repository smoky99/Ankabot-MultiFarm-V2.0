Utils = dofile(global:getCurrentDirectory() .. "\\YAYA\\Module\\Utils.lua")

function move()
    while true do
        Utils:Print(map:currentSubArea())
    end
end