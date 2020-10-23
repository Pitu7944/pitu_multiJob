--[[ edited ("insert date here") by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]
Config = {}
Config.clientSyncTime = 5 -- client sync time in seconds
Config.Jobs = {
    {
        name = 'testjob',
        blips = {
            {
                color = 1,
                id = 1,
                pos = {x = 123, y = 456, z = 789},
                label = 'testBlip'
            }
        },
        grades = {
            { grade = 1, label = 'rekrut', isboss = false },
            { grade = 2, label = 'g2', isboss = false },
            { grade = 3, label = 'g3', isboss = false },
            { grade = 4, label = 'g4', isboss = false },
            { grade = 5, label = 'Boss', isboss = true },
        },
        zones = {
            changerooms = {
                label = 'Press ~g~[E]~w~ to open Changing Room',
                enabled = true,
                pos = {x = 409.02, y = -980.94, z = 28.32}
            },
            armory = {
                label = 'Press ~g~[E]~w~ to open Armory',
                enabled = true,
                pos = {x = 408.88, y = -985.36, z = 28.28},
                webhook = {enabled = false, link = ''},
            },
            storage = {
                label = 'Press ~g~[E]~w~ to open Storage',
                enabled = true,
                pos = {x = 408.8, y = -989.24, z = 28.28},
                webhook = {enabled = false, link = ''}
            },
            garage = {
                label = 'Press ~g~[E]~w~ to open Garage',
                enabled = true,
                pos = {x = 408.0, y = -995.36, z = 28.28},
                vehicles = {
                    {spawnName = 'zentorno', label = 'Zentorno'}
                },
                spawner = {
                    x = 402.4,  y = -1001.72,  z = 29.36, h = 180.00
                },
            },
            deleter = {
                label = 'Press ~g~[E]~w~ to hide Vehicle',
                pos = {x = 402.4,  y = -1001.72,  z = 28.46}
            }
        },
        data = {}
    }
}
