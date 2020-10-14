--[[ edited ("insert date here") by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]
Config = {}
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
        zones = {
            changerooms = {
                label = 'Press ~g~[E]~w~ to open Changing Room',
                enabled = true,
                pos = {x = 123, y = 456, z = 789}
            },
            armory = {
                label = 'Press ~g~[E]~w~ to open Armory',
                enabled = true,
                pos = {x = 123, y = 456, z = 789},
                webhook = {enabled = false, link = ''}
            },
            storage = {
                label = 'Press ~g~[E]~w~ to open Storage',
                enabled = true,
                pos = {x = 123, y = 456, z = 789},
                webhook = {enabled = false, link = ''}
            },
            garage = {
                label = 'Press ~g~[E]~w~ to open Garage',
                enabled = true,
                pos = {x = 123, y = 456, z = 789}
            }
        }
    }
}