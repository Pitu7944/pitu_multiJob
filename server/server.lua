--[[ edited (22.04.2021) by :
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
RegisterNetEvent('pitu_multijob:functions_s:notify')
-- end event registry --

print(Config)

Citizen.CreateThread(function() --event sync thread
    AddEventHandler('pitu_multijob:db:storeItem', function(item, amount)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        local job = db_getJob(_source).job
        if xPlayer ~= nil and job ~= nil and xPlayer.getInventoryItem(item).count >= amount then
            db_insertToStorage(job, item, amount)
            TriggerClientEvent('pitu_multijob:functions:notify', _source, string.format(trs['s_notifications_store_item'], amount, ESX.GetItemLabel(item)))
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
                TriggerClientEvent('pitu_multijob:functions:notify', _source, string.format(trs['s_notifications_withdraw_item'], amount, ESX.GetItemLabel(item)))
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
                    TriggerClientEvent('pitu_multijob:functions:notify', _source, string.format(trs['s_notifications_withdraw_money_black'], math.abs(newAmount)))
                elseif isPaying == true and bma ~= nil then
                    xPlayer.removeAccountMoney('black_money', math.abs(newAmount))
                    TriggerClientEvent('pitu_multijob:functions:notify', _source, string.format(trs['s_notifications_deposit_money_black'], math.abs(newAmount)))
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
                    TriggerClientEvent('pitu_multijob:functions:notify', _source, string.format(trs['s_notifications_withdraw_money'], math.abs(newAmount)))
                elseif isPaying == true and bma ~= nil then
                    xPlayer.removeMoney(math.abs(newAmount))
                    TriggerClientEvent('pitu_multijob:functions:notify', _source, string.format(trs['s_notifications_deposit_money'], math.abs(newAmount)))
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
                    TriggerClientEvent('pitu_multijob:functions:notify', _source, string.format(trs['s_notifications_weapon_bought'], weapon.label))
                    return
                else
                    TriggerClientEvent('pitu_multijob:functions:notify', _source, trs['s_notification_not_enough_money'])
                end
            end
            TriggerClientEvent('pitu_multijob:functions:notify', _source, trs['s_notifications_not_permitted'])
        end
        TriggerClientEvent('pitu_multijob:functions:notify', _source, trs['s_notifications_error'])
    end)
    AddEventHandler('pitu_multijob:functions_s:notify', function(target, msg)
        TriggerClientEvent('pitu_multijob:functions:notify', target, msg)
    end)
end)

Citizen.CreateThread(function() -- main event loop
    while db_ready == false do Wait(0) end
    dprint("[Server] Loaded")
end)

RegisterCommand('pmj_checkjob', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if args[1] == nil then 
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Pitu_MultiJob", trs['s_commands_error_no_id']}
        })
        return
    end
    if xPlayer.getGroup() ~= 'user' then
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Pitu_MultiJob", json.encode(db_getJob(args[1]))}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Pitu_MultiJob", trs['s_commands_error_no_permission']}
        })
    end
end, false)

RegisterCommand('pmj_unsetjob', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if args[1] == nil then 
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Pitu_MultiJob", trs['s_commands_error_no_id']}
        })
        return
    end
    if xPlayer.getGroup() ~= 'user' then
        db_removejob(args[1])
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Pitu_MultiJob", string.format(trs['s_commands_remove_job_succes'], args[1])}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Pitu_MultiJob", trs['s_commands_error_no_permission']}
        })
    end
end)


RegisterCommand('pmjinfo', function(source)
    local jd = db_getJob(source)
    if getGrade(jd.job, jd.grade) ~= nil then
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"System", string.format(trs, jd.job, getGrade(jd.job, jd.grade).label)}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = { 255, 0, 0},
            multiline = true,
            args = {"System", trs['s_commands_unemployed']}
        })
    end
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
            args = {"Pitu_MultiJob", trs['s_commands_error_no_permission']}
        })
    end
end, false)



--[[ edited (22.04.2021) by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]