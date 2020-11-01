local cuffedPlayers = {}

ESX_cp = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX_cp = obj end)


function isInList(id)
    for i, iid in pairs(cuffedPlayers) do
        if iid == id then
            return true
        end
    end
    return false
end   

function canCarry(xPlayer, item, addedAmount)
    local item_limit = xPlayer.getInventoryItem(item).limit
    local item_count = xPlayer.getInventoryItem(item).count
    local new_item_count = item_count + addedAmount
    if item_limit == -1 then return true end
    if item_limit >= new_item_count then return true else return false end
    return false
end

function popItem(id)
    for i, iid in pairs(cuffedPlayers) do
        if iid == id then
            table.remove(cuffedPlayers, i)
            return iid
        end
    end
    return nil
end
        

RegisterServerEvent('pitu_multijob:addons:cuffing')
AddEventHandler('pitu_multijob:addons:cuffing', function(target)
    if not isInList(target) then
        TriggerClientEvent('pitu_multijob:functions:notify', source, '~r~Zakułeś~w~ ID: '..target)
        TriggerClientEvent('pitu_multijob:functions:notify', target, 'Zostałeś ~r~Zakuty~w~ przez ID: '..source)
        TriggerClientEvent('pitu_multijob:addons:cuff', target)
        if not isInList(target) then table.insert(cuffedPlayers, target) end
    end
end)

---

RegisterServerEvent('pitu_multijob:addons:uncuff')
AddEventHandler('pitu_multijob:addons:uncuff', function(target)
    if isInList(target) then
        TriggerClientEvent('pitu_multijob:functions:notify', source, '~r~Rozkułeś~w~ ID: '..target)
        TriggerClientEvent('pitu_multijob:functions:notify', target, 'Zostałeś ~r~Rozkuty~w~ przez ID: '..source)
        TriggerClientEvent('pitu_multijob:addons:uncuff', target)
        popItem(target)
        return
    else
        TriggerClientEvent('pitu_multijob:functions:notify', source, '~r~Błąd~w~, ID: '..target.." jest już rozkuty!")
        return
    end
    TriggerClientEvent('pitu_multijob:functions:notify', source, '~r~Błąd~w~, ID: '..target.." jest już rozkuty!")
end)

RegisterNetEvent('pitu_multijob:addons:search:confiscatePlayerItem')
AddEventHandler('pitu_multijob:addons:search:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		if targetItem.count > 0 and targetItem.count <= amount then
			if canCarry(sourceXPlayer, itemName, sourceItem.count) then
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem(itemName, amount)
				sourceXPlayer.showNotification('Zabrałeś: '.. amount.."x ".. sourceItem.label.." | ".. targetXPlayer.name)
				targetXPlayer.showNotification('Zabrano Ci: '.. amount.."x ".. sourceItem.label.. " | ".. sourceXPlayer.name)
			else
				sourceXPlayer.showNotification('Niepoprawna Ilość')
			end
		else
			sourceXPlayer.showNotification('Niepoprawna Ilość')
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney   (itemName, amount)

		sourceXPlayer.showNotification('Zabrałeś Pieniądze: '.. amount.. "| ".. itemName, targetXPlayer.name)
		targetXPlayer.showNotification('Zabrano ci Pieniądze: '.. amount.. " | ".. itemName, sourceXPlayer.name)

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, amount)

		sourceXPlayer.showNotification('Zabrałeś Broń: '.. ESX.GetWeaponLabel(itemName).. " | ".. targetXPlayer.name, amount)
		targetXPlayer.showNotification('Zabrano ci Broń: '.. ESX.GetWeaponLabel(itemName).." x".. amount.." | ".. sourceXPlayer.name)
	end
end)

ESX_cp.RegisterServerCallback('pitu_multijob:addons:search:getOtherPlayerData', function(source, cb, target, notify)
	local xPlayer = ESX.GetPlayerFromId(target)
	if xPlayer then
		local data = {
			name = xPlayer.getName(),
			job = xPlayer.job.label,
			grade = xPlayer.job.grade_label,
			inventory = xPlayer.getInventory(),
			accounts = xPlayer.getAccounts(),
			weapons = xPlayer.getLoadout()
		}

		if 1 == 1 then
			data.dob = xPlayer.get('dateofbirth')
			data.height = xPlayer.get('height')

			if xPlayer.get('sex') == 'm' then data.sex = 'male' else data.sex = 'female' end
		end

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status then
				data.drunk = ESX.Math.Round(status.percent)
			end
		end)

		if Config.EnableLicenses then
			TriggerEvent('esx_license:getLicenses', target, function(licenses)
				data.licenses = licenses
				cb(data)
			end)
		else
			cb(data)
		end
	end
end)

ESX_cp.RegisterServerCallback('pitu_multijob:addons:getcuffStatus', function(source, cb, target)
    cb(isInList(target))
end)

--[[
RegisterCommand('testcuff', function(source, args)
    TriggerClientEvent('pitu_multijob:addons:cuff', args[1])
end, false)

RegisterCommand('testuncuff', function(source, args)
    TriggerClientEvent('pitu_multijob:addons:uncuff', args[1])
end, false)
]]