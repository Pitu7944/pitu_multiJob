--[[ edited ("insert date here") by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]
Config = {}
Config.DebugEnabled = false
Config.clientSyncTime = 5 -- client sync time in seconds
Config.Jobs = {
    {
        name = 'testjob', -- name of the job (to set job a player do /pmj_setjob {id} {name} {grade}
        blips = { -- job blips to be displayed (https://docs.fivem.net/docs/game-references/blips/)
            {
                color = 1, -- blip color
                id = 1, -- blip sprite
                pos = {x = 123, y = 456, z = 789}, -- blip position
                label = 'testBlip' -- blip Text
            }
        },
        grades = { -- job grades
            { grade = 1, label = 'rekrut', isboss = false },
            { grade = 2, label = 'g2', isboss = false },
            { grade = 3, label = 'g3', isboss = false },
            { grade = 4, label = 'g4', isboss = false },
            { grade = 5, label = 'Boss', isboss = true },
        },
        zones = {
            changerooms = { -- clothing change menu
                label = 'Press ~g~[E]~w~ to open Changing Room', -- zone action message
                pos = {x = 409.02, y = -980.94, z = 28.32} -- zone position ( remember to subtract one from Z coord! )
            },
            armory = { -- weapon shop menu
                label = 'Press ~g~[E]~w~ to open Armory', -- zone action message
                pos = {x = 408.88, y = -985.36, z = 28.28}, -- zone position ( remember to subtract one from Z coord! )
                weapons = { -- add weapons here
                    {weaponName = 'weapon_pistol', label = 'Pistol', price = 1000} -- weaponName is weapon spawnname , label is Label
                }
            },
            storage = { -- item storage menu
                label = 'Press ~g~[E]~w~ to open Storage', -- zone action message
                pos = {x = 408.8, y = -989.24, z = 28.28} -- zone position ( remember to subtract one from Z coord! )
            },
            garage = {
                label = 'Press ~g~[E]~w~ to open Garage', -- zone action message
                pos = {x = 408.0, y = -995.36, z = 28.28}, -- zone position ( remember to subtract one from Z coord! )
                vehicles = { -- add vehicles here
                    {spawnName = 'zentorno', label = 'Zentorno'} -- vehicle name and label
                },
                spawner = {
                    x = 402.4,  y = -1001.72,  z = 29.36, h = 180.00 -- zone position ( remember to NOT subtract one from Z coord! )
                },
            },
            deleter = {
                label = 'Press ~g~[E]~w~ to hide Vehicle', -- zone action message
                pos = {x = 402.4,  y = -1001.72,  z = 28.46} -- zone position ( remember to subtract one from Z coord! )
            }
        },
    },
    {
        name = 'testjob2', -- name of the job (to set job a player do /pmj_setjob {id} {name} {grade}
        blips = { -- job blips to be displayed (https://docs.fivem.net/docs/game-references/blips/)
            {
                color = 1, -- blip color
                id = 1, -- blip sprite
                pos = {x = 123, y = 456, z = 789}, -- blip position
                label = 'testBlip2' -- blip Text
            }
        },
        grades = { -- job grades
            { grade = 1, label = 'rekrut', isboss = false },
            { grade = 2, label = 'g2', isboss = false },
            { grade = 3, label = 'g3', isboss = false },
            { grade = 4, label = 'g4', isboss = false },
            { grade = 5, label = 'Boss', isboss = true },
        },
        zones = {
            changerooms = { -- clothing change menu
                label = 'Press ~g~[E]~w~ to open Changing Room', -- zone action message
                pos = {x = 409.02, y = -980.94, z = 28.32} -- zone position ( remember to subtract one from Z coord! )
            },
            armory = { -- weapon shop menu
                label = 'Press ~g~[E]~w~ to open Armory', -- zone action message
                pos = {x = 408.88, y = -985.36, z = 28.28}, -- zone position ( remember to subtract one from Z coord! )
                weapons = { -- add weapons here
                    {weaponName = 'weapon_pistol', label = 'Pistol', price = 1000} -- weaponName is weapon spawnname , label is Label
                }
            },
            storage = { -- item storage menu
                label = 'Press ~g~[E]~w~ to open Storage', -- zone action message
                pos = {x = 408.8, y = -989.24, z = 28.28} -- zone position ( remember to subtract one from Z coord! )
            },
            garage = {
                label = 'Press ~g~[E]~w~ to open Garage', -- zone action message
                pos = {x = 408.0, y = -995.36, z = 28.28}, -- zone position ( remember to subtract one from Z coord! )
                vehicles = { -- add vehicles here
                    {spawnName = 'zentorno', label = 'Zentorno'} -- vehicle name and label
                },
                spawner = {
                    x = 402.4,  y = -1001.72,  z = 29.36, h = 180.00 -- zone position ( remember to NOT subtract one from Z coord! )
                },
            },
            deleter = {
                label = 'Press ~g~[E]~w~ to hide Vehicle', -- zone action message
                pos = {x = 402.4,  y = -1001.72,  z = 28.46} -- zone position ( remember to subtract one from Z coord! )
            }
        },
    }
}
