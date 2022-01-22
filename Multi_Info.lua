Info = {}

Info.gatherInfo = {
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
    -- Pêcheur
    Goujon = { name = "Goujon", gatherId = 75, objectId = 1782, jobId = 36, minLvlToFarm = 1 },
    Greuvette = { name = "Greuvette", gatherId = 71, objectId = 598, jobId = 36, minLvlToFarm = 10 },
    Truite = { name = "Truite", gatherId = 74, objectId = 1844, jobId = 36, minLvlToFarm = 20 },
    Crabe = { name = "Crab Sourimis", gatherId = 77, objectId = 1757, jobId = 36, minLvlToFarm = 30 },
    PoissonChaton = { name = "Poisson-Chaton", gatherId = 76, objectId = 603, jobId = 36, minLvlToFarm = 40 },
    PoissonPane = { name = "Poisson Pané", gatherId = 78, objectId = 1750, jobId = 36, minLvlToFarm = 50 },
    CarpeDiem = { name = "Carpe d'Iem", gatherId = 79, objectId = 1794, jobId = 36, minLvlToFarm = 60 },
    SardineBrillante = { name = "Sardine Brillante", gatherId = 81, objectId = 1805, jobId = 36, minLvlToFarm = 70 },
    Brochet = { name = "Brochet", gatherId = 263, objectId = 1847, jobId = 36, minLvlToFarm = 80 },
    Kralamoure = { name = "Kralamoure", gatherId = 264, objectId = 600, jobId = 36, minLvlToFarm = 90 },
    Anguille = { name = "Anguille", gatherId = 265, objectId = 16461, jobId = 36, minLvlToFarm = 100 },
    DoradeGrise = { name = "Dorade Grise", gatherId = 266, objectId = 16463, jobId = 36, minLvlToFarm = 110 },
    Perche = { name = "Perche", gatherId = 267, objectId = 1801, jobId = 36, minLvlToFarm = 120 },
    RaieBleue = { name = "Raie Bleue", gatherId = 268, objectId = 1784, jobId = 36, minLvlToFarm = 130 },
    Lotte = { name = "Lotte", gatherId = 269, objectId = 16465, jobId = 36, minLvlToFarm = 140 },
    RequinMarteauFaucille = { name = "Requin Marteau-Faucille", gatherId = 270, objectId = 602, jobId = 36, minLvlToFarm = 150 },
    BarRikain = { name = "Bar Rikain", gatherId = 271, objectId = 1779, jobId = 36, minLvlToFarm = 160 },
    Morue = { name = "Morue", gatherId = 272, objectId = 16467, jobId = 36, minLvlToFarm = 170 },
    Tanche = { name = "Tanche", gatherId = 273, objectId = 16469, jobId = 36, minLvlToFarm = 180 },
    Espadon = { name = "Espadon", gatherId = 274, objectId = 16471, jobId = 36, minLvlToFarm = 190 },
    PichonDencre = { name = "Pichon d'encre", gatherId = 365, objectId = 23825, jobId = 36, minLvlToFarm = 200 },
    Poisskaille = { name = "Poisskaille", gatherId = 132, objectId = 11106, jobId = 36, minLvlToFarm = 200 },


    -- Autres
    Puits = { name = "Puits", gatherId = 84, objectId = 311, jobId = 2, minLvlToFarm = 1 }
}

Info.bagsId = {
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
    16539
}

Info.workshopInfo = {
    ["Mineur"] = {
        skillId = {32, 48},
        ["Astrub"] = {
            ["32"] = { -- Fondre
                mapId = 192939010,
                workshopId = {
                    515660,
                    515666
                }
            },
            ["48"] = { -- Polir
                mapId = 192939010,
                workshopId = {
                    515702
                }
            }
        },
        ["Bonta"] = {
            ["32"] = { -- Fondre
                mapId = 217060356,
                workshopId = {
                    521478,
                    521474
                }
            },
            ["48"] = { -- Polir
                mapId = 217061380,
                workshopId = {
                    521483,
                    521482
                }
            }
        }

    },
    ["Bûcheron"] = {
        skillId = {101},
        ["Astrub"] = {
            ["101"] = {
                mapId = 192940034,
                workshopId = {
                    516166,
                    515493
                }
            }
        },
        ["Bonta"] = {
            ["101"] = {
                mapId = 217063430,
                workshopId = {
                    521477,
                    521476,
                    521475
                }
            }
        }
    },
    ["Alchimiste"] = {
        skillId = {23},
        ["Astrub"] = {
            ["23"] = {
                mapId = 192937988,
                workshopId = {
                    515520,
                    515549,
                    515516
                }
            }
        },
        ["Bonta"] = {
            ["23"] = {
                mapId = 217057284,
                workshopId = {
                    521386,
                    523984
                }
            }
        }
    },
    ["Paysan"] = {
        skillId = {27, 47},
        ["Astrub"] = {
            ["27"] = { -- Cuire
                mapId = 192939008,
                workshopId = {
                    514880,
                    514876
                }
            },
            ["47"] = { -- Moudre
                mapId = 192939008,
                workshopId = {
                    514878,
                    516162
                }
            },
        },
        ["Bonta"] = {
            ["27"] = { -- Cuire
                mapId = 217061382,
                workshopId = {
                    521568,
                    521569
                }
            },
            ["47"] = { -- Moudre
                mapId = 217061382,
                workshopId = {
                    521460,
                    521459
                }
            },
        }
    },
    ["Pêcheur"] = {
        skillId = {135},
        ["Astrub"] = {
            ["135"] = {
                mapId = 192937984,
                workshopId = {
                    515961,
                    516163
                }
            }
        },
        ["Bonta"] = {
            ["135"] = {
                mapId = 217062406,
                workshopId = {
                    521467,
                    521464,
                    521463
                }
            }
        }
    },
    ["Chasseur"] = {
        skillId = {134},
        ["Astrub"] = {
            ["134"] = {
                mapId = 192937994,
                workshopId = {
                    515869
                }
            }
        },
        ["Bonta"] = {
            ["134"] = {
                mapId = 217062404,
                workshopId = {
                    521493,
                    521490,
                    521489,
                    521492
                }
            }
        }
    },
    ["Tailleur"] = {
        skillId = {63},
        ["Astrub"] = {
            ["63"] = {
                mapId = 192940032,
                workshopId = {
                    515146,
                    515145,
                    515147
                }
            }
        },
        ["Bonta"] = {
            ["63"] = {
                mapId = 217056260,
                workshopId = {
                    523819,
                    521377,
                    523886
                }
            }
        }
    },
    ["Bijoutier"] = {
        skillId = {12},
        ["Astrub"] = {
            ["12"] = {
                mapId = 192937990,
                workshopId = {
                    515740,
                    515739,
                    516168,
                    516169
                }
            }
        },
        ["Bonta"] = {
            ["12"] = {
                mapId = 217058310,
                workshopId = {
                    521413,
                    521671,
                    521672
                }
            }
        }
    },
    ["Cordonnier"] = {
        skillId = {13},
        ["Astrub"] = {
            ["13"] = {
                mapId = 192939016,
                workshopId = {
                    515848,
                    516200,
                    515851
                }
            }
        },
        ["Bonta"] = {
            ["13"] = {
                mapId = 217055238,
                workshopId = {
                    521402,
                    521401,
                    521399
                }
            }
        }
    },
    ["Forgeron"] = {
        skillId = {20},
        ["Astrub"] = {
            ["20"] = {
                mapId = 192939010,
                workshopId = {
                    516165
                }
            }
        },
        ["Bonta"] = {
            ["20"] = {
                mapId = 217055236,
                workshopId = {
                    522298,
                    524084,
                    524086
                }
            }
        }
    },
    ["Sculpteur"] = {
        skillId = {15},
        ["Astrub"] = {
            ["15"] = {
                mapId = 192940034,
                workshopId = {
                    515963,
                    515964
                }
            }
        },
        ["Bonta"] = {
            ["15"] = {
                mapId = 217058308,
                workshopId = {
                    524090,
                    521431,
                    521432
                }
            }
        }
    },
    ["Bricoleur"] = {
        skillId = {171},
        ["Astrub"] = {
            ["171"] = {
                mapId = 192940038,
                workshopId = {
                    516170,
                    515689
                }
            }
        },
        ["Bonta"] = {
            ["171"] = {
                mapId = 217059334,
                workshopId = {
                    521442,
                    521441
                }
            }
        }
    },
    ["Façonneur"] = {
        skillId = {171, 297, 201, 380},
        ["Astrub"] = {
            ["156"] = { -- Bouclier
                mapId = 192940040,
                workshopId = {
                    515830
                }
            },
            ["297"] = { -- Idole
                mapId = 192940040,
                workshopId = {
                    516199
                }
            },
            ["201"] = { -- Trophée
                mapId = 192940040,
                workshopId = {
                    516172
                }
            },
            ["380"] = { -- Prysmaradite
                mapId = 192940040,
                workshopId = {
                    518018
                }
            }
        },
        ["Bonta"] = {
            ["156"] = { -- Bouclier
                mapId = 217059332,
                workshopId = {
                    521454
                }
            },
            ["297"] = { -- Idole
                mapId = 217059332,
                workshopId = {
                    521443
                }
            },
            ["201"] = { -- Trophée
                mapId = 217059332,
                workshopId = {
                    521673
                }
            },
            ["380"] = { -- Prysmaradite
                mapId = 217059332,
                workshopId = {
                    523888
                }
            }
        }

    }
}

Info.shopInfo = {
    ["Bonta"] = {
        ["Ressources"] = {
            shopMapId = 212601350,
            elementId = 522694
        },
        ["Consommables"] = {
            shopMapId = 212600839,
            elementId = 522692
        },
        ["Equipements"] = {
            shopMapId = 212600837,
            elementId = 522691
        },
        ["Runes"] = {
            shopMapId = 212601859,
            elementId = 522693
        }
    }
}

return Info