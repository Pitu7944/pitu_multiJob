--[[ edited ("insert date here") by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)


-- event registry --
RegisterNetEvent('pitu_multijob:db:storeItem')
RegisterNetEvent('pitu_multijob:db:getItem')

-- end event registry --


Citizen.CreateThread(function() --event sync thread
    AddEventHandler('pitu_multijob:db:storeItem', function(item, amount)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local job = db_getJob(_source).job
        if xPlayer ~= nil and job ~= nil and xPlayer.getInventoryItem(item).count >= amount then
            db_insertToStorage(job, item, amount)
            xPlayer.removeInventoryItem(item, amount)
        end 
    end)
    AddEventHandler('pitu_multijob:db:getItem', function(item, amount)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local job = db_getJob(_source).job
        if xPlayer ~= nil and job ~= nil then
            if db_getFromStorage(job, item, amount) ~= false then
                xPlayer.addInventoryItem(item, amount)
            end
        end 
    end)
end)

Citizen.CreateThread(function() -- main event loop
    while db_ready == false do Wait(0) end
    dprint("[Server] Loaded")
    dprint(db_insertToStorage('testjob', 'clip', 5))
    dprint(db_getFromStorage('testjob', 'clip', 10))
end)

RegisterCommand('sti', function(source, args)
    
end, false)

RegisterCommand('pmj_checkjob', function(source, args)
    dprint(db_getJob(source))
    TriggerClientEvent('chat:addMessage', source, {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Pitu_MultiJob", json.encode(db_getJob(source))}
    })
end, false)


RegisterCommand('pmjinfo', function(source, args)
    local jd = db_getJob(source)
    TriggerClientEvent('chat:addMessage', source, {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Pitu_MultiJob", "You are: "..jd.job.." and your grade is "..getGrade(jd.job, jd.grade).label}
    })
end, false)

RegisterCommand('pmj_setjob', function(source, args)
    TriggerClientEvent('chat:addMessage', source, {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Pitu_MultiJob", db_setJob(args[1], args[2], args[3])}
    })
end, false)



--[[ edited ("insert date here") by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]