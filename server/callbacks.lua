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
        ESX_CB.RegisterServerCallback('pitu_multijob:db:getJobStorage', function(source, cb)
            dprint("cb2 Triggered!")
            --print(source)
            local job = db_getJob(source).job
            --print("Callback - job: "..job)
            local storage = db_getAllFromStorage(job)
            cb(true, storage)
        end)
        ESX_CB.RegisterServerCallback('pitu_multijob:db:getPlayerStorage', function(source, cb)
            --print(source)
            local xPlayer = ESX_CB.GetPlayerFromId(source)
            local inventory = xPlayer.getInventory(true)
            local items = {}
            for _, item in pairs(inventory) do 
                if item.count > 0 then
                    table.insert(items, {label = item.label, item = item.name, amount = item.count})
                end
            end
            --print(json.encode(items))
            cb(true, items)
        end)
        dprint('[CB] Loaded')
    end)
end)


