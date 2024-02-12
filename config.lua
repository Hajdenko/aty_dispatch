Config = {
    Framework = "esx", -- esx - this fork can only work on esx :/ (because i dont have a qb server)
    GPSItem = "gps",
    SetWaypoingKey = "G",

    WaitTimes = { -- Cooldown after a dispatch to send another one.
        Shooting = 2, -- Second
        Speeding = 10, -- Seconds
        KradezAuta = 2, -- Seconds || Car Stolen - Translated from Czech
    },

    Enable = { -- Enable or disable built-in dispatches
        Speeding = true,
        Shooting = true,
        PlayerDeath = true,
        UseSuppressorControl = true,
        UseGPS = true, -- Players will receive an alert if only they have a gps 
    },

    WhitelistedJobs = { -- Jobs that won't going to give an alert.
        "police",
        "sheriff",
        "ambulance"
    },

    BlipRemoveTime = 120, -- Seconds

    Notification = function(title, message, type, length)
        -- Your notification here
    end,

    BlackListedWeapons = { -- Weapons that wont give an alert
        'WEAPON_STUNGUN',
        'WEAPON_BZGAS',
        'WEAPON_SNOWBALL',
        'WEAPON_MOLOTOV',
        'WEAPON_FLARE',
        'WEAPON_BALL',
        'WEAPON_PETROLCAN',
        'WEAPON_HAZARDCAN',
        'WEAPON_FIREEXTINGUISHER',
    },

    Suppressors = { -- Suppressor hash codes
        0x65EA7EBB,
        0xC304849A,
        0xA73D4664,
        0x9307D6FA,
        0xE608B35E,
        0x837445AA,
        0xAC42DF71,
        0x9BC64089,
    }
}
