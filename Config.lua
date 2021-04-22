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
Config.Enable_Handcuffs = true -- enable handcuff addon
Config.Enable_DoorLock = true -- enable doorlock addon

Config.DebugEnabled = false -- show debug info
Config.clientSyncTime = 5 -- client sync time in seconds
handcuff_config.enableInventoryHud = false -- use inventoryhud handcuffs
Config.Jobs = {
    {
        name = 'anonymous', -- name of the job (to set job a player do /pmj_setjob {id} {name} {grade}
        blips = { -- job blips to be displayed (https://docs.fivem.net/docs/game-references/blips/)
            {
                color = 52, -- blip color
                id = 362, -- blip sprite
                pos = {x = 759.8,  y = -1913.2,  z = 29.44}, -- blip position
                label = 'Anonymous - Siedziba' -- blip Text
            }
        },
        grades = { -- job grades
            { grade = 1, label = 'frajer'},
            { grade = 2, label = 'Ciastek Batak'},
            { grade = 3, label = 'HG Developer'},
            { grade = 4, label = 'Hiszpanski przez noc'},
            { grade = 5, label = 'KeviiPL'},
        },
        zones = {
            boss = { -- boss menu
                rq_grade = 5,
                label = 'Naciśnij ~g~[E]~w~ aby otworzyć Menu Szefa', -- zone action message
                pos = {x = 763.8,  y = -1905.08,  z = 28.44} -- zone position ( remember to subtract one from Z coord! )
            },
            changerooms = { -- clothing change menu
                label = 'Naciśnij ~g~[E]~w~ aby otworzyć Przebieralnie', -- zone action message
                pos = {x = 759.8,  y = -1913.2,  z = 28.44} -- zone position ( remember to subtract one from Z coord! )
            },
            armory = { -- weapon shop menu
                label = 'Naciśnij ~g~[E]~w~ aby otworzyć Zbrojownie', -- zone action message
                pos = {x = 748.2,  y = -1913.4,  z = 28.48}, -- zone position ( remember to subtract one from Z coord! )
                weapons = { -- add weapons here
                    {weaponName = 'weapon_pistol', label = 'Pistol', price = 1000} -- weaponName is weapon spawnname , label is Label
                }
            },
            storage = { -- item storage menu
                label = 'Naciśnij ~g~[E]~w~ aby otworzyć Magazyn', -- zone action message
                pos = {x = 760.52,  y = -1904.28,  z = 28.44} -- zone position ( remember to subtract one from Z coord! )
            },
            garage = {
                label = 'Naciśnij ~g~[E]~w~ aby otworzyć Garaż', -- zone action message
                pos = {x = 743.56,  y = -1910.4,  z = 28.30}, -- zone position ( remember to subtract one from Z coord! )
                vehicles = { -- add vehicles here
                    {spawnName = 'zentorno', label = 'Zentorno'} -- vehicle name and label
                },
                spawner = {
                    x = 734.8,  y = -1912.72,  z = 29.30, h = 171.72 -- zone position ( remember to NOT subtract one from Z coord! )
                },
            },
            deleter = {
                label = 'Naciśnij ~g~[E]~w~ aby schować pojazd', -- zone action message
                pos = {x = 734.8,  y = -1912.72,  z = 28.30} -- zone position ( remember to subtract one from Z coord! )
            }
        },
    },
    {
        name = 'neak_boss', -- name of the job (to set job a player do /pmj_setjob {id} {name} {grade}
        blips = { -- job blips to be displayed (https://docs.fivem.net/docs/game-references/blips/)
            {
                color = 52, -- blip color
                id = 362, -- blip sprite
                pos = {x = 759.8,  y = -1913.2,  z = 29.44}, -- blip position
                label = 'Szef wszystkich szefów - Siedziba' -- blip Text
            }
        },
        grades = { -- job grades
            { grade = 1, label = 'Pachołek'},
            { grade = 2, label = 'Członek'},
            { grade = 3, label = 'Zaufany'},
            { grade = 4, label = 'Prawa ręka'},
            { grade = 5, label = 'NeaK'},
        },
        zones = {
            boss = { -- boss menu
                rq_grade = 5,
                label = 'Naciśnij ~g~[E]~w~ aby otworzyć Menu Szefa', -- zone action message
                pos = {x = 759.8,  y = -1913.2,  z = 28.44} -- zone position ( remember to subtract one from Z coord! )
            },
            changerooms = { -- clothing change menu
                label = 'Naciśnij ~g~[E]~w~ aby otworzyć Przebieralnie', -- zone action message
                pos = {x = 759.8,  y = -1913.2,  z = 28.44} -- zone position ( remember to subtract one from Z coord! )
            },
            armory = { -- weapon shop menu
                label = 'Naciśnij ~g~[E]~w~ aby otworzyć Zbrojownie', -- zone action message
                pos = {x = 748.2,  y = -1913.4,  z = 28.48}, -- zone position ( remember to subtract one from Z coord! )
                weapons = { -- add weapons here
                    {weaponName = 'weapon_pistol', label = 'Pistol', price = 1000} -- weaponName is weapon spawnname , label is Label
                }
            },
            storage = { -- item storage menu
                label = 'Naciśnij ~g~[E]~w~ aby otworzyć Magazyn', -- zone action message
                pos = {x = 760.52,  y = -1904.28,  z = 28.44} -- zone position ( remember to subtract one from Z coord! )
            },
            garage = {
                label = 'Naciśnij ~g~[E]~w~ aby otworzyć Garaż', -- zone action message
                pos = {x = 743.56,  y = -1910.4,  z = 28.30}, -- zone position ( remember to subtract one from Z coord! )
                vehicles = { -- add vehicles here
                    {spawnName = 'zentorno', label = 'Zentorno'} -- vehicle name and label
                },
                spawner = {
                    x = 734.8,  y = -1912.72,  z = 29.30, h = 171.72 -- zone position ( remember to NOT subtract one from Z coord! )
                },
            },
            deleter = {
                label = 'Naciśnij ~g~[E]~w~ aby schować pojazd', -- zone action message
                pos = {x = 734.8,  y = -1912.72,  z = 28.30} -- zone position ( remember to subtract one from Z coord! )
            }
        },
    }
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
	}
}