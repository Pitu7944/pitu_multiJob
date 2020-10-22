--[[ edited ("insert date here") by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]


ESX_CB = nil
Citizen.CreateThread(function()
    while ESX_CB == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX_CB = obj end)
        Citizen.Wait(0)
    end
end)


Citizen.CreateThread(function() -- main event loop
    while db_ready == false do Wait(0) end
    Citizen.CreateThread(function()
        while ESX == nil do Wait(0) end
        ESX_CB.RegisterServerCallback('pitu_multijob:db:getPlayerJob', function(source, cb)
            dprint("cb Triggered!")
            cb(db_getJob(source))
        end)
        dprint('[CB] Loaded')
    end)
end)


