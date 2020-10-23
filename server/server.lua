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
RegisterNetEvent('pitu_multijob:db:setBlackMoneyStock')
RegisterNetEvent('pitu_multijob:db:setMoneyStock')
RegisterNetEvent('pitu_multijob:shop:buyWeapon')
-- end event registry --


Citizen.CreateThread(function() --event sync thread
    AddEventHandler('pitu_multijob:db:storeItem', function(item, amount)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local job = db_getJob(_source).job
        if xPlayer ~= nil and job ~= nil and xPlayer.getInventoryItem(item).count >= amount then
            db_insertToStorage(job, item, amount)
            TriggerClientEvent('pitu_multijob:functions:notify', _source, 'You Deposited ~g~'..amount..' of '..ESX.GetItemLabel(item)..'~w~')
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
                TriggerClientEvent('pitu_multijob:functions:notify', _source, 'You Withdrawn ~g~'..amount..' of '..ESX.GetItemLabel(item)..'~w~')
            end
        end 
    end)
    AddEventHandler('pitu_multijob:db:setBlackMoneyStock', function(newAmount, isPaying)
        dprint(newAmount)
        dprint(isPaying)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local playerJob = db_getJob(_source).job
        if xPlayer ~= nil then
            if playerJob ~= nil then
                if isPaying == true then
                    if xPlayer.getAccount('black_money').money < math.abs(newAmount) then
                        return
                    end
                end
                dprint("Pass")
                bma = db_setMoneyStock(playerJob, 'black', newAmount)
                if isPaying == false and bma ~= nil then
                    xPlayer.addAccountMoney('black_money', math.abs(newAmount))
                    TriggerClientEvent('pitu_multijob:functions:notify', _source, 'You Withdrawn ~g~'..math.abs(newAmount)..'$~w~ ~u~(~r~dirty~u~)~w~')
                elseif isPaying == true and bma ~= nil then
                    xPlayer.removeAccountMoney('black_money', math.abs(newAmount))
                    TriggerClientEvent('pitu_multijob:functions:notify', _source, 'You Deposited ~g~'..math.abs(newAmount)..'$~w~ ~u~(~r~dirty~u~)~w~')
                end
            end
        end
    end)
    AddEventHandler('pitu_multijob:db:setMoneyStock', function(newAmount, isPaying)
        dprint(newAmount)
        dprint(isPaying)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local playerJob = db_getJob(_source).job
        if xPlayer ~= nil then
            if playerJob ~= nil then
                if isPaying == true then
                    if xPlayer.getMoney() < math.abs(newAmount) then
                        return
                    end
                end
                bma = db_setMoneyStock(playerJob, 'cash', newAmount)
                if isPaying == false and bma ~= nil then
                    xPlayer.addMoney(math.abs(newAmount))
                    TriggerClientEvent('pitu_multijob:functions:notify', _source, 'You Withdrawn ~g~'..math.abs(newAmount)..'$~w~')
                elseif isPaying == true and bma ~= nil then
                    xPlayer.removeMoney(math.abs(newAmount))
                    TriggerClientEvent('pitu_multijob:functions:notify', _source, 'You Deposited ~g~'..math.abs(newAmount)..'$~w~')
                end
            end
        end
    end)
    AddEventHandler('pitu_multijob:shop:buyWeapon', function(weapon)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local playerJob = db_getJob(_source).job
        local jobData = conf_GetJobData(playerJob)
        local weapon = conf_getWeapon(jobData, weapon)
        if xPlayer ~= nil then
            if playerJob ~= nil then
                if xPlayer.getMoney() >= weapon.price then
                    dprint(weapon.price)
                    dprint(weapon.weaponName)
                    xPlayer.removeMoney(weapon.price)
                    xPlayer.addWeapon(weapon.weaponName, 100)
                    TriggerClientEvent('pitu_multijob:functions:notify', _source, 'You ~r~Bought~w~')
                    return
                else
                    TriggerClientEvent('pitu_multijob:functions:notify', _source, 'Not enough ~g~Money~w~')
                end
            end
            TriggerClientEvent('pitu_multijob:functions:notify', _source, 'Not Permited')
        end
        TriggerClientEvent('pitu_multijob:functions:notify', _source, 'Error!')
    end)
end)

Citizen.CreateThread(function() -- main event loop
    while db_ready == false do Wait(0) end
    dprint("[Server] Loaded")
    dprint(db_insertToStorage('testjob', 'clip', 5))
    dprint(db_getFromStorage('testjob', 'clip', 10))
end)

RegisterCommand('pmj_checkjob', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Pitu_MultiJob", json.encode(db_getJob(source))}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Pitu_MultiJob", "No permission to do this!"}
        })
    end
end, false)


RegisterCommand('pmjinfo', function(source)
    local jd = db_getJob(source)
    TriggerClientEvent('chat:addMessage', source, {
        color = { 255, 0, 0},
        multiline = true,
        args = {"System", "You belong to "..jd.job.." and your grade is "..getGrade(jd.job, jd.grade).label}
    })
end, false)

RegisterCommand('pmj_setjob', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Pitu_MultiJob", db_setJob(args[1], args[2], args[3])}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Pitu_MultiJob", "No permission to do this!"}
        })
    end
end, false)



--[[ edited ("insert date here") by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]