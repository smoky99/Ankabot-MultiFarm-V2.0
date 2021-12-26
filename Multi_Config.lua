Config = {}
Config.minMinutesOnFarmingZone, Config.maxMinutesOnFarmingZone = 3, 5
Config.minPercentPodsBeforeBank, Config.maxPercentPodsBeforeBank = 70, 90

Config.minPercentLifeBeforeFight = 80

Config.houseMode = false -- Mettre true pour activer le retour maison

Config.wortimeJob = {
    ["Lundi"] = {
        { startTime = "05:14", finishTime = "23:59", job = "Bûcheron" },
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
        { startTime = "06:00", finishTime = "23:59", job = "Façonneur" }
    },
    ["Dimanche"] = {
        { startTime = "00:02", finishTime = "23:50", job = "Alchimiste" },
    }
}

-- maxCraftPerDay non implémenter

Config.craft = {
    ["Mineur"] = {
        {
            craftName = "Magnesite",
            craftId = 748,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
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
            maxCraftPerDay = 1000
        },
    },
    ["Alchimiste"] = {
        {
            craftName = "Levure de boulanger",
            craftId = 286,
            nbCraftBeforeNextCraft = 500,
            maxCraftPerDay = 1000
        },
        {
            craftName = "Potion de Mini Soin",
            craftId = 1182,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
        },
        {
            craftName = "Potion de Rappel",
            craftId = 548,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
        },
        {
            craftName = "Potion de souvenir",
            craftId = 7652,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
        },
    },
    ["Paysan"] = {
        {
            craftName = "Pain d'Incarnam",
            craftId = 468,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
        },
    },
    ["Pêcheur"] = {
        {
            craftName = "Goujon en tranche",
            craftId = 1813,
            nbCraftBeforeNextCraft = 100,
            maxCraftPerDay = 1000
        },
    },
    ["Tailleur"] = {
        {
            craftName = "Petit Sac en Laine de Boufton",
            craftId = 1697,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
        },
        {
            craftName = "Le Floude",
            craftId = 8533,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
        },
    },
    ["Bijoutier"] = {
        {
            craftName = "La destinée dorée",
            craftId = 158,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
        },
        {
            craftName = "Blessure du Sacrieur",
            craftId = 1493,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
        },
    },
    ["Cordonnier"] = {
        {
            craftName = "Les Incrustes",
            craftId = 8535,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
        },
    },
    ["Bricoleur"] = {
        {
            craftName = "Clef des Champs",
            craftId = 8143,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
        }
    },
    ["Forgeron"] = {
        {
            craftName = "Couteau de Chasse",
            craftId = 1934,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
        },
    },
    ["Sculpteur"] = {
        {
            craftName = "Demi-Baguette",
            craftId = 1356,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
        },
    },
    ["Façonneur"] = {
        {
            craftName = "Bouclier du Bûcheron",
            craftId = 18676,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
        },
    }
}

Config.zaapExcepted = {

}

Config.houseInfo = {
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

return Config