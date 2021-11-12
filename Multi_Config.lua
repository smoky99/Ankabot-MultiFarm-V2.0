Config = {}
Config.minMinutesOnFarmingZone, Config.maxMinutesOnFarmingZone = 3, 5
Config.minPercentPodsBeforeBank, Config.maxPercentPodsBeforeBank = 70, 90

Config.minPercentLifeBeforeFight = 80

Config.wortimeJob = {
    ["Lundi"] = {
        { startTime = "05:14", finishTime = "23:59", job = "Mineur" },
    },
    ["Mardi"] = {
        { startTime = "06:07", finishTime = "23:50", job = "Mineur" }
    },
    ["Mercredi"] = {
        { startTime = "06:00", finishTime = "23:45", job = "Mineur" },
    },
    ["Jeudi"] = {
        { startTime = "02:10", finishTime = "23:50", job = "Bijoutier" },
        { startTime = "19:50", finishTime = "19:55", job = "Chasse au trésor" },
        { startTime = "13:13", finishTime = "13:14", job = "" }
    },
    ["Vendredi"] = {
        { startTime = "06:00", finishTime = "23:59", job = "Bijoutier" },

    },
    ["Samedi"] = {
        { startTime = "06:00", finishTime = "23:59", job = "Mineur" }
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
            craftName = "Koliet Aclou",
            craftId = 766,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
        },
        {
            craftName = "Blessure du Sacrieur",
            craftId = 1493,
            nbCraftBeforeNextCraft = 50,
            maxCraftPerDay = 1000
        },
    }
}


return Config