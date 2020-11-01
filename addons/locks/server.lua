if Config.Enable_DoorLock then
	al_ESX = nil
	local doorState = {}

	TriggerEvent('esx:getSharedObject', function(obj) al_ESX = obj end)


	RegisterServerEvent('pitu_multijob:addons:doorlock:updateState')
	AddEventHandler('pitu_multijob:addons:doorlock:updateState', function(doorIndex, state)
		local xPlayer = al_ESX.GetPlayerFromId(source)

		if xPlayer and type(doorIndex) == 'number' and type(state) == 'boolean' and lock_Config.DoorList[doorIndex] and isAuthorized(db_getJob(source).job, lock_Config.DoorList[doorIndex]) then
			doorState[doorIndex] = state
			TriggerClientEvent('pitu_multijob:addons:doorlock:setDoorState', -1, doorIndex, state)
		end
	end)

	al_ESX.RegisterServerCallback('pitu_multijob:addons:doorlock:getDoorState', function(source, cb)
		cb(doorState)
	end)

	function isAuthorized(jobName, doorObject)
		for k,job in pairs(doorObject.authorizedJobs) do
			if job == jobName then
				return true
			end
		end

		return false
	end
end