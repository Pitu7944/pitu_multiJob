--[[ edited ("insert date here") by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]

ESX_DB = nil
Citizen.CreateThread(function()
    while ESX_DB == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX_DB = obj end)
        Citizen.Wait(0)
    end
end)


dprint("[DB] Connecting")

Citizen.CreateThread(function() -- db sync loop
    MySQL.ready(function ()
        dprint('[DB] Connected!')
        db_ready = true
    end)
end)

Citizen.CreateThread(function() -- db cleanup thread ( removes items with count 0 )
    while true do 
        db_cleanup()
        Wait(60000)
    end
end)

function getSteamHex(source)
    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            return v
        end
    end
end

function db_getStorage(jobname)
    local result = MySQL.Sync.fetchAll('SELECT * FROM pitu_multijob_storage WHERE jobname = "'..jobname..'"')
    if result ~= nil then return result else return false end
end

function db_getJob(source)
    local steamhex = getSteamHex(source)
    --print(steamhex)
    if steamhex ~= nil then
        local result = MySQL.Sync.fetchAll('SELECT * FROM pitu_multijob_users WHERE identifier = "'..steamhex..'"')
        if result[1] ~= nil then
            --print(json.encode(result[1]))
            return {job=result[1].jobname, grade=result[1].jobgrade}
        else
            return nil
        end
    else
        return nil
    end
end

function getGrade(jobname, grade)
    for _, ijob in pairs(Config.Jobs) do
        if ijob.name == jobname then
            --print(json.encode(ijob))
            for i, igrade in pairs(ijob.grades) do
                if igrade.grade == grade then
                    --print(json.encode(igrade))
                    return igrade
                end
            end
        end
    end
    return nil
end

function db_setJob(source, jobname, jobgrade)
    local steamhex = getSteamHex(source)
    --print(steamhex)
    if steamhex ~= nil then
        local result = MySQL.Sync.fetchAll('SELECT * FROM pitu_multijob_users WHERE identifier = "'..steamhex..'"')
        if result[1] ~= nil then
            --print(json.encode(result[1]))
            --print("Updating HEX: "..steamhex.." ID: "..source.." To: "..jobname.." with Grade: "..jobgrade)
            MySQL.Sync.execute('UPDATE pitu_multijob_users SET jobname = @jobname, jobgrade = @jobgrade WHERE identifier = "'..steamhex..'"', { ['jobname'] = jobname, ['jobgrade'] = jobgrade })
            return "Updating HEX: "..steamhex.." ID: "..source.." To: "..jobname.." with Grade: "..jobgrade
        else
            --print("Setting HEX: "..steamhex.." ID: "..source.." To: "..jobname.." with Grade: "..jobgrade)
            MySQL.Sync.execute('INSERT INTO pitu_multijob_users (jobname, jobgrade, identifier) VALUES (@jobname, @jobgrade, @identifier)', { ['jobname'] = jobname, ['jobgrade'] = jobgrade, ['identifier'] = steamhex}, function(affectedRows)
                --print(affectedRows)
            end)
            return "Setting HEX: "..steamhex.." ID: "..source.." To: "..jobname.." with Grade: "..jobgrade
        end
    else
        return nil
    end
end

function db_insertToStorage(jobname, item, amount)
    local result = MySQL.Sync.fetchAll('SELECT * FROM pitu_multijob_storage WHERE jobname = "'..jobname..'"')
    local existflag = false
    local l_item = nil
    for i, iitem in pairs(result) do 
        --print(json.encode(iitem))
        if iitem.item == item then existflag = true l_item = iitem break end
    end
    if existflag == false then
        if amount < 0 then return end
        MySQL.Async.execute('INSERT INTO pitu_multijob_storage (jobname, item, amount) VALUES (@jobname, @item, @amount)', { ['jobname'] = jobname, ['item'] = item, ['amount'] = amount}, function(affectedRows)
            --print(affectedRows)
        end)
    elseif existflag == true then
        local l_amount = l_item.amount + amount
        if l_amount < 0 then l_amount = 0 end
        MySQL.Async.execute('UPDATE pitu_multijob_storage SET item = @item, amount = @amount WHERE jobname = @jobname AND item = @item', { ['jobname'] = jobname, ['item'] = item, ['amount'] = l_amount}, function(affectedRows)
            --print(affectedRows)
        end)
    end
end

function db_getFromStorage(jobname, item, amount)
    local result = MySQL.Sync.fetchAll('SELECT * FROM pitu_multijob_storage WHERE jobname = "'..jobname..'"')
    local existflag = false
    local amount = math.abs(amount)*-1
    local l_item = nil
    for i, iitem in pairs(result) do 
        --print(json.encode(iitem))
        if iitem.item == item then existflag = true l_item = iitem break end
    end
    if existflag == false then
        return false
    elseif existflag == true then
        local l_amount = l_item.amount + amount
        if l_amount < 0 then return false end
        MySQL.Async.execute('UPDATE pitu_multijob_storage SET item = @item, amount = @amount WHERE jobname = @jobname AND item = @item', { ['jobname'] = jobname, ['item'] = item, ['amount'] = l_amount}, function(affectedRows)
            print(affectedRows)
        end)
        return amount
    end
end

function db_getAllFromStorage(jobname)
    dprint("searching items with jobname: "..jobname)
    local result = MySQL.Sync.fetchAll('SELECT * FROM pitu_multijob_storage WHERE jobname = "'..jobname..'"')
    local items = {}
    if result[1] ~= nil then
        for i, iitem in pairs(result) do
            --print(json.encode(iitem))
            local label = ESX_DB.GetItemLabel(iitem.item)
            if label == nil then label = iitem.item end
            table.insert(items, {item=iitem.item, amount = iitem.amount, label = label})
        end
        return items
    end
    return true
end

function db_cleanup()
    local result = MySQL.Sync.fetchAll('SELECT * FROM pitu_multijob_storage')
    local existflag = false
    local l_item = nil
    for i, iitem in pairs(result) do 
        if iitem.amount <= 0 then
            --print("Cleaning up: "..json.encode(iitem))
            MySQL.Async.execute('DELETE FROM pitu_multijob_storage WHERE jobname = @jobname AND item = @item AND amount = @amount', { ['jobname'] = iitem.jobname, ['item'] = iitem.item, ['amount'] = iitem.amount}, function(affectedRows)
            end)
        end
    end
end