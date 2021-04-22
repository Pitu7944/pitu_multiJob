Config = {}
handcuff_config = {}
lock_Config = {}
--[[ edited (22.04.2021) by :
     ___  _    _        ___  ___   __    __          ___  ___  _  _ 
    | . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
    |  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
    |_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
    any issues? Dm me on discord (Pitu7944#2711)
]]
-- addon enable options --
Config.Enable_Handcuffs = true -- handcuff addon
Config.Enable_DoorLock = true -- doorlock addon

Config.DebugEnabled = false -- debug info
Config.clientSyncTime = 15 -- client sync time in seconds
handcuff_config.enableInventoryHud = false -- enable inventoryhud handcuffs
Config.Jobs = {
    {
        name = 'lagrassco', -- name of the job (to set job a player do /pmj_setjob {id} {name} {grade}
        blips = { -- job blips to be displayed (https://docs.fivem.net/docs/game-references/blips/)
            {
                color = 5, -- blip color
                id = 442, -- blip sprite  /pmj_setjob 2 lagrassco 5
                pos = {x = -1174.64,  y = -1153.64,  z = 5.64}, -- blip position
                label = 'LaGrassco - Siedziba' -- blip Text
            }
        },
        grades = { -- job grades
            { grade = 1, label = 'Pachołek'},
            { grade = 2, label = 'Członek'},
            { grade = 3, label = 'Zaufany'},
            { grade = 4, label = 'Prawa ręka'},
            { grade = 5, label = 'Szef'},
        },
        zones = {
            boss = { -- boss menu
                rq_grade = 5,
                label = 'Naciśnij ~g~[E]~w~ aby otworzyć Menu Szefa', -- zone action message
                pos = {x = 1007.88,  y = -3170.32,  z = -39.72} -- zone position ( remember to subtract one from Z coord! )
            },
            changerooms = { -- clothing change menu
                label = 'Naciśnij ~g~[E]~w~ aby otworzyć Przebieralnie', -- zone action message
                pos = {x = 1010.6,  y = -3167.68,  z = -39.72} -- zone position ( remember to subtract one from Z coord! )
            },
            armory = { -- weapon shop menu
                label = 'Naciśnij ~g~[E]~w~ aby otworzyć Zbrojownie', -- zone action message
                pos = {x = 1001.72,  y = -3177.12,  z = -39.72}, -- zone position ( remember to subtract one from Z coord! )
                weapons = { -- add weapons here
                    {weaponName = 'pistol', label = 'pistol', price = 150}, -- weaponName is weapon spawnname , label is Label
                    {weaponName = 'sns_pistol', label = 'pistol', price = 100} -- weaponName is weapon spawnname , label is Label
                }
            },
            storage = { -- item storage menu
                label = 'Naciśnij ~g~[E]~w~ aby otworzyć Magazyn', -- zone action message
                pos = {x = 997.88,  y = -3172.72,  z = -39.72}, -- zone position ( remember to subtract one from Z coord! )
            },
            garage = {
                label = 'Naciśnij ~g~[E]~w~ aby otworzyć Garaż', -- zone action message
                pos = {x = 1009.32,  y = -3156.2,  z = -39.72}, -- zone position ( remember to subtract one from Z coord! )
                vehicles = { -- add vehicles here
                    {spawnName = 'zentorno', label = 'Zentorno'} -- vehicle name and label
                },
                spawner = {
                    x = 1005.16,  y = -3159.64,  -39.72, h = 171.72 -- zone position ( remember to NOT subtract one from Z coord! )
                },
            },
            deleter = {
                label = 'Naciśnij ~g~[E]~w~ aby schować pojazd', -- zone action message
                pos = {x = 1005.16,  y = -3159.64,  z = -39.72}, -- zone position ( remember to subtract one from Z coord! )
            }
        },
    },
}
lock_Config.DoorList = {
	{
		objHash = -1430323452,
		objHeading = 264.695,
		objCoords = vector3(744.09880, -1906.70900, 29.57541),
		textCoords = vector3(743.8, -1906.082, 29.41),
		authorizedJobs = {'anonymous'},
		locked = true,
		maxDistance = 5,
		size = 1
	},
}