MAPS_BEFORE_HAVENBAG = {}

MAPS_BEFORE_HAVENBAG.maps = {

    { map = 165153537, path = "left" },

    --Mine Ebbernard

    { map = 29622275, path = "450" },
    { map = 29622272, path = "450" },
    { map = 29622531, path = "450" },
    { map = 29622534, path = "424" },

    -- Mine manganese ile dragoeuf

    { map = 86246410, path = "431" },

    -- Mine Bwork

    { map = 104860165, path = "444" },
    { map = 104859139, path = "444" },
    { map = 104860169, path = "263" },
    { map = 104861193, path = "254" },
    { map = 104859145, path = "457" },
    { map = 104858121, path = "507" },
    { map = 104861189, path = "451" },
    { map = 104862213, path = "376" },
    { map = 104858119, path = "207" },

    { map = 104861191, path = "457" },
    { map = 104860167, path = "478" },
    { map = 104859143, path = "543" },
    { map = 104862215, path = "472" },


    -- Mine Maksage

    { map = 57017861, path = "270" },
    { map = 56886787, path = "396" },
    { map = 56885763, path = "436" },
    { map = 57016837, path = "401" },
    { map = 57016835, path = "409" },
    { map = 57017859, path = "395" },

    -- Malle au tresor

    { map = 128452097, path = "504" },
    { map = 128451073, door = "549" },

    -- Zone astrub

    { map = 188745734, path = "bottom" },

    -- Territoire des porco

    { map = 72619524, path = "left" },
}

function MAPS_BEFORE_HAVENBAG:RunCheck()
    for _, v in pairs(self.maps) do
        if map:currentMapId() == v.map then
            if v.door then
                map:door(v.door)
            elseif v.path then
                map:changeMap(v.path)
            end
        end
    end
end

return MAPS_BEFORE_HAVENBAG