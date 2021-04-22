if Config.Enable_DoorLock then
	al_ESX = nil
	player_job = nil

	Citizen.CreateThread(function()
		while al_ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) al_ESX = obj end)
			Citizen.Wait(0)
		end
		-- Update the door list
		al_ESX.TriggerServerCallback('pitu_multijob:addons:doorlock:getDoorState', function(doorState)
			for index,state in pairs(doorState) do
				lock_Config.DoorList[index].locked = state
			end
		end)
	end)

	Citizen.CreateThread(function() -- job sync thread
		while al_ESX == nil do Wait(10) end
		while true do
			al_ESX.TriggerServerCallback('pitu_multijob:db:getPlayerJob', function(jobname)
				player_job = jobname
			end, 'jd')
			Wait(20000)
		end
	end)


	RegisterNetEvent('pitu_multijob:addons:doorlock:setDoorState')
	AddEventHandler('pitu_multijob:addons:doorlock:setDoorState', function(index, state) lock_Config.DoorList[index].locked = state end)

	Citizen.CreateThread(function()
		while true do
			local playerCoords = GetEntityCoords(PlayerPedId())

			for k,v in ipairs(lock_Config.DoorList) do
				v.isAuthorized = isAuthorized(v)

				if v.doors then
					for k2,v2 in ipairs(v.doors) do
						if v2.object and DoesEntityExist(v2.object) then
							if k2 == 1 then
								v.distanceToPlayer = #(playerCoords - GetEntityCoords(v2.object))
							end

							if v.locked and v2.objHeading and al_ESX.Math.Round(GetEntityHeading(v2.object)) ~= v2.objHeading then
								SetEntityHeading(v2.object, v2.objHeading)
							end
						else
							v.distanceToPlayer = nil
							v2.object = GetClosestObjectOfType(v2.objCoords, 1.0, v2.objHash, false, false, false)
						end
					end
				else
					if v.object and DoesEntityExist(v.object) then
						v.distanceToPlayer = #(playerCoords - GetEntityCoords(v.object))

						if v.locked and v.objHeading and al_ESX.Math.Round(GetEntityHeading(v.object)) ~= v.objHeading then
							SetEntityHeading(v.object, v.objHeading)
						end
					else
						v.distanceToPlayer = nil
						v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objHash, false, false, false)
					end
				end
			end

			Citizen.Wait(500)
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			local letSleep = true

			for k,v in ipairs(lock_Config.DoorList) do
				if v.distanceToPlayer and v.distanceToPlayer < 50 then
					letSleep = false

					if v.doors then
						for k2,v2 in ipairs(v.doors) do
							FreezeEntityPosition(v2.object, v.locked)
						end
					else
						FreezeEntityPosition(v.object, v.locked)
					end
				end

				if v.distanceToPlayer and v.distanceToPlayer < v.maxDistance then
					local size, displayText = 1, "🔓"

					if v.size then size = v.size end
					if v.locked then displayText = "🔒" end
					if v.isAuthorized then displayText = ""..getEmoji(v.locked) end

					al_ESX.Game.Utils.DrawText3D(v.textCoords, displayText, size)

					if IsControlJustReleased(0, 38) then
						if v.isAuthorized then
							v.locked = not v.locked
							TriggerServerEvent('pitu_multijob:addons:doorlock:updateState', k, v.locked) -- broadcast new state of the door to everyone
						end
					end
				end
			end

			if letSleep then
				Citizen.Wait(500)
			end
		end
	end)

	function isAuthorized(door)
		if not al_ESX or player_job == nil then
			return false
		end

		for k,job in pairs(door.authorizedJobs) do
			if job == player_job.job then
				return true
			end
		end

		return false
	end

	function getEmoji(state)
		if state then
			return '~g~[E]~w~ 🔒'
		else
			return "~g~[E]~w~ 🔓"
		end
	end
end