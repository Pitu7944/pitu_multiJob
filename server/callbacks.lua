--[[ edited (22.04.2021) by :
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
            dprint(source)
            local job = db_getJob(source).job
            dprint("Callback - job: "..job)
            local storage = db_getAllFromStorage(job)
            cb(true, storage)
        end)
        ESX_CB.RegisterServerCallback('pitu_multijob:db:getPlayerStorage', function(source, cb)
            dprint(source)
            local xPlayer = ESX_CB.GetPlayerFromId(source)
            local inventory = xPlayer.getInventory(true)
            local items = {}
            for _, item in pairs(inventory) do 
                if item.count > 0 then
                    table.insert(items, {label = item.label, item = item.name, amount = item.count})
                end
            end
            dprint(json.encode(items))
            cb(true, items)
        end)
        ESX_CB.RegisterServerCallback('pitu_multijob:db:getBlackMoneyStock', function(source, cb)
            dprint(source)
            blackmoney = db_getMoneyStock(db_getJob(source).job, 'black')
            dprint(tostring(blackmoney))
            if blackmoney == nil then blackmoney = 0 end
            cb(true, blackmoney)
        end)
        ESX_CB.RegisterServerCallback('pitu_multijob:db:getMoneyStock', function(source, cb)
            dprint(source)
            cash = db_getMoneyStock(db_getJob(source).job, 'cash')
            if cash == nil then cash = 0 end
            cb(true, cash)
        end)
        ESX_CB.RegisterServerCallback('pitu_multijob:db:getPlayerBlackMoney', function(source, cb)
            local _source = source
            local xPlayer = ESX_CB.GetPlayerFromId(_source)
            cb(true, xPlayer.getAccount('black_money').money)
        end)
        ESX_CB.RegisterServerCallback('pitu_multijob:db:getPlayerMoney', function(source, cb)
            local _source = source
            local xPlayer = ESX_CB.GetPlayerFromId(_source)
            cb(true, xPlayer.getMoney())
        end)
        ESX_CB.RegisterServerCallback('pitu_multijob:conf:getJobWeaponStore', function(source, cb)
            local _source = source
            local xPlayer = ESX_CB.GetPlayerFromId(_source)
            local jobname = db_getJob(source).job
            local jobdata = conf_GetJobData(jobname)
            cb(true, jobdata.zones.armory.weapons)
        end)
        ESX_CB.RegisterServerCallback('pitu_multijob:bmenu:getjobMembers', function(source, cb)
            local _source = source
            local xPlayer = ESX_CB.GetPlayerFromId(_source)
            local jobname = db_getJob(source).job
            cb(true, db_getAllJobMembers(jobname))
        end)
        employees = {}
        ESX_CB.RegisterServerCallback('pitu_multijob:functions:getPlayerRPName', function(source, cb, steamIDs)
            local steamIDs = steamIDs
            employees = {}
            employees_fetched = false
            for i, isteamid in pairs(steamIDs) do
                MySQL.Async.fetchAll('SELECT firstname, lastname, identifier FROM users WHERE identifier = @steamid', { ['@steamid'] = isteamid }, function (results)
                    for i=1, #results, 1 do
                        table.insert(employees, {
                            name       = results[i].firstname .. ' ' .. results[i].lastname,
                            identifier = results[i].identifier,
                        })
                    end
                    employees_fetched = true
                end)
            end
            while employees_fetched == false do Wait(0) end
            if employees == {} then employees = false end
            cb(true, employees)
        end)
        ESX_CB.RegisterServerCallback('pitu_mulitjob:db:setjobSteamID', function(source, cb, data)
            if data.grade > 5 then data.grade = 5 end
            if data.grade <= 0 then data.grade = 1 end
            dprint("Pass")
            db_setjobIdent(data.steamID, data.job, data.grade)
            dprint("Setting: "..data.steamID.." to: "..data.job.." With Grade: "..data.grade)
            cb(true)
        end)
        ESX_CB.RegisterServerCallback('pitu_multijob:db:firePlayer', function(source, cb, data)
            local boss = db_getJob(source)
            dprint(json.encode(boss))
            dprint("ID: "..source.." is firing: "..data.steamHex)
            if boss ~= nil and boss.grade >= 5 then
                dprint('Allowing!')
                cb(db_removePlayer(data.steamHex))
            else
                cb(false) -- maybe ban this boi here?
            end
        end)
        ESX_CB.RegisterServerCallback('pitu_multijob:utils:getPlayers', function(source, cb)
            rpnames = {}
            for i, iplayer in pairs(ESX_CB.GetPlayers()) do
                local xPlayer = ESX_CB.GetPlayerFromId(iplayer)
                dprint(json.encode(db_getJob(iplayer)).. " | "..json.encode(iplayer))
                if db_getJob(iplayer) == nil then
                    table.insert(rpnames, {name = xPlayer.getName(), identifier = getSteamHex(iplayer)})
                end
            end
            cb(rpnames)
        end)
        dprint('[CB] Loaded')
    end)
end)


