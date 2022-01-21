Config = {}
Config.minMinutesOnFarmingZone, Config.maxMinutesOnFarmingZone = 0, 0 -- Si 0, 0 temps gérez via le script
Config.minPercentPodsBeforeBank, Config.maxPercentPodsBeforeBank = 62, 87 -- Pods min, max avant le retour bank

Config.bankMapId = 192415750 -- Mapid intérieur de la bank de votre choix

Config.minPercentLifeBeforeFight = 80 -- Pourcentage minimum de vie avant régén

Config.houseMode = false -- Active ou désactive le retour maison (true/false)

Config.tradeMode = false -- Active ou désactive la vente/achat automatique (true/false)
Config.tradeArea = "Bonta" -- Choix de l'endroit pour l'utilisation des HDV (Bonta, Brakmar) Brak non implémenter
Config.tradeInterval = 4 -- Choix pour la vérification des items a vendre tout les x retour banque/maison

Config.wortimeJob = { -- Format hh:mm
    ["Lundi"] = {
        { startTime = "05:14", finishTime = "12:59", job = "Paysan" },
        { startTime = "12:59", finishTime = "23:59", job = "Bûcheron" },
    },
    ["Mardi"] = {
        { startTime = "06:07", finishTime = "23:50", job = "Bûcheron" }
    },
    ["Mercredi"] = {
        { startTime = "06:00", finishTime = "23:45", job = "Bûcheron" },
    },
    ["Jeudi"] = {
        { startTime = "02:10", finishTime = "23:50", job = "Bûcheron" },
    },
    ["Vendredi"] = {
        { startTime = "06:00", finishTime = "23:59", job = "Bûcheron" },
    },
    ["Samedi"] = {
        { startTime = "06:00", finishTime = "23:59", job = "Paysan" }
    },
    ["Dimanche"] = {
        { startTime = "00:02", finishTime = "23:50", job = "Alchimiste" },
    }
}

Config.zaapExcepted = { -- Zaap a exclure
    -- 00000000000,
    -- 00000000000,
}

Config.houseInfo = { -- Info pour le retour maison
    houseOwnerPseudo = "pseudoDuCompteMaison#1234", -- Vous pouvez récupérer votre pseudo dans l'onglet social de dofus
    houseOutsideMapId = 000000000, -- MapId éxtérieure de la maison
    houseDoorCellId = 000, -- CellId de la porte
    housePassword = 000000, -- Mot de passe de la porte
    chestCellId = 000, -- CellId du coffre
    chestPassword = 000000, -- Mot de passe du coffre, mettre -1 si le coffre appartient au bot
    inHousePath = {
        { map = 000000000, door = "316" }, -- Si votre maison a plusieurs pièces déplacer le bot jusqu'au coffre avec door pour une porte ou path si c'est un soleil
        { map = 000000000, inTheTrunkMap = true } -- Une fois arriver sur la map du coffre mettre inTheTrunkMap = true
    }
}

Config.colorPrint = { -- Couleur des print
    ["Craft"] = "#d7fa2a",
    ["Trading"] = "#00bbff",
    ["Server"] = "#21c2b4",
    ["Farming"] = "#a795de",
    ["Controller"] = "#caf700",
    ["Info"] = "#00fc4c",
    ["Bank"] = "#ffaa00",
    ["Error"] = "#fc0000"
}

Config.controller = { -- Non implémenter !
    serverToConnect = "",
    leaderAccountUsername = "",
    leaderInGameUsername = "",
    groupAccountUsername = {""},
    groupInGameUsername = {""}
}

-- craftName = nom du craft
-- craftId = id de l'objet a craft
-- nbCraftBeforeNextCraft = le nombre de craft a faire avant de passez au prochain craft
-- maxCraftPerDay non implémenter
-- minLvlToCraft = Active le craft quand le métier du craft en question atteint cette valeur
-- maxLvlToCraft = Désactive le craft quand le métier du craft en question atteint cette valeur

Config.craft = { -- Gestion des craft
    ["Mineur"] = {
        {
            craftName = "Magnesite",
            craftId = 748,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
    },
    ["Bûcheron"] = {
        {
            craftName = "Planche Agglomérée",
            craftId = 16489,
            nbCraftBeforeNextCraft = 100,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
        {
            craftName = "Substrat de buisson",
            craftId = 2539,
            nbCraftBeforeNextCraft = 100,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
        {
            craftName = "Substrat de bocage",
            craftId = 12745,
            nbCraftBeforeNextCraft = 100,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
    },
    ["Alchimiste"] = {
        {
            craftName = "Levure de boulanger",
            craftId = 286,
            nbCraftBeforeNextCraft = 500,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
        {
            craftName = "Potion de Mini Soin",
            craftId = 1182,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
        {
            craftName = "Potion de Rappel",
            craftId = 548,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
        {
            craftName = "Potion de souvenir",
            craftId = 7652,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
    },
    ["Paysan"] = {
        {
            craftName = "Pain d'Incarnam",
            craftId = 468,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
    },
    ["Pêcheur"] = {
        {
            craftName = "Goujon en tranche",
            craftId = 1813,
            nbCraftBeforeNextCraft = 100,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
    },
    ["Tailleur"] = {
        {
            craftName = "Petit Sac en Laine de Boufton",
            craftId = 1697,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
        {
            craftName = "Le Floude",
            craftId = 8533,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
    },
    ["Bijoutier"] = {
        {
            craftName = "La destinée dorée",
            craftId = 158,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
        {
            craftName = "Blessure du Sacrieur",
            craftId = 1493,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
    },
    ["Cordonnier"] = {
        {
            craftName = "Les Incrustes",
            craftId = 8535,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
    },
    ["Bricoleur"] = {
        {
            craftName = "Clef des Champs",
            craftId = 8143,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        }
    },
    ["Forgeron"] = {
        {
            craftName = "Couteau de Chasse",
            craftId = 1934,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
    },
    ["Sculpteur"] = {
        {
            craftName = "Demi-Baguette",
            craftId = 1356,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
    },
    ["Façonneur"] = {
        {
            craftName = "Bouclier du Bûcheron",
            craftId = 18676,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000,
            minLvlToCraft = 1,
            maxLvlToCraft = 200
        },
    }
}

-- Sales
  -- objectName = Nom de l'objet
  -- objectId = Id de l'objet
  -- lot = Nombre de lot a mettre en vente (1, 10, 100)
  -- maxLotInHdv = Nombre max de lot de cette item en hdv
  -- minPrice = Prix mini pour la vente et l'actualisation des prix
  -- maxPrice = Prix maxi pour la vente et l'actualisation des prix
-- Buy
  -- objectName = Nom de l'objet
  -- objectId = Id de l'objet
  -- minStockInBank = Quantité mini de l'objet en bank avant le rachat de l'objet
  -- maxPrice = Prix maxi pour l'achat

Config.salesInfo = { -- Gestion du mode vente
    ["Sale"] = {
        ["Ressources"] = {
            {
                objectName = "Blé",
                objectId = 289,
                lot = 100,
                maxLotInHdv = 10,
                minPrice = 500,
                maxPrice = 10000
            },
        },
        ["Consommables"] = {
        },
        ["Runes"] = {

        },
        ["Equipements"] = {

        }
    },
    ["Buy"] = {
        ["Ressources"] = {
            -- {
            --     objectName = "Blé",
            --     objectId = 289,
            --     minStockInBank = 0,
            --     maxPrice = 10000
            -- },
        },
        ["Consommables"] = {
    
        },
        ["Runes"] = {
    
        },
        ["Equipements"] = {
    
        }
    }
}

return Config