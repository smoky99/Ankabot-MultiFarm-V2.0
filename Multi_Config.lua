Config = {}
Config.minMinutesOnFarmingZone, Config.maxMinutesOnFarmingZone = 3, 5
Config.minPercentPodsBeforeBank, Config.maxPercentPodsBeforeBank = 70, 90

Config.minPercentLifeBeforeFight = 80

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
        { startTime = "06:00", finishTime = "23:59", job = "Bijoutier" }
    },
    ["Dimanche"] = {
        { startTime = "00:02", finishTime = "23:50", job = "Mineur" },
    }
}

Config.craft = {
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
            craftName = "Magnesite",
            craftId = 748,
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
    ["Bûcheron"] = {
        {
            craftName = "Substrat de buisson",
            craftId = 2539,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
        },
    },
    ["Alchimiste"] = {
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
    }
}


return Config