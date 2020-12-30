C = {}

C.Version = 1.0

C.policeCount = 2 -- Gerekli polis sayısı
C.Car = {x = -558.956, y = -1689.99, z = 18.851, h = 30.628728866577}

C.NPC = {
    ["hash"] = "a_m_m_eastsa_02",
    ["coords"] = {x = 499.1151, y = -2669.31, z = 5.7056, h = 204.79641723633},
}

C.Items = {
    ["wire"] = {
        ["name"] = "kablo",
        ["price"] = math.random(3, 6),
        ["label"] = "Kablo",
    },
    ["motor"] = {
        ["name"] = "arabamotoru",
        ["price"] = math.random(400, 700),
        ["label"] = "Motor",
    },
    ["rim"] = {
        ["name"] = "highrim",
        ["price"] = math.random(150, 250),
        ["label"] = "Jant",
    },
    ["radio"] = {
        ["name"] = "highradio",
        ["price"] = math.random(75, 150),
        ["label"] = "Radyo",
    },

    -- Ev soygunu itemleri
    ["boscanta"] = {
        ["name"] = "boscanta",
        ["price"] = math.random(5, 20),
    },
    ["bospaket"] = {
        ["name"] = "bospaket",
        ["price"] = math.random(5, 20),
    },
    ["sackurutma"] = {
        ["name"] = "sackurutma",
        ["price"] = math.random(15, 25),
    },
    ["bant"] = {
        ["name"] = "bant",
        ["price"] = math.random(3, 5),
    },
    ["bottle"] = {
        ["name"] = "bottle",
        ["price"] = math.random(3, 5),
    },
    ["kacaksigara"] = {
        ["name"] = "kacaksigara",
        ["price"] = math.random(5, 10),
    },
}

L = {
    ["wreck"] = "~r~E ~w~- Aracı Parçala",
    ["sell"] = "~r~E ~w~- Illegal Abi",
}
