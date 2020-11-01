-- ESX_CF
ESX_CF               = nil

Citizen.CreateThread(function()
	while ESX_CF == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX_CF = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

local cuffed = false
local dict = "mp_arresting"
local anim = "idle"
local flags = 49
local ped = PlayerPedId()
local changed = false
local prevMaleVariation = 0
local prevFemaleVariation = 0
local femaleHash = GetHashKey("mp_f_freemode_01")
local maleHash = GetHashKey("mp_m_freemode_01")
local IsLockpicking    = false

RegisterNetEvent('pitu_multijob:addons:cuff')
AddEventHandler('pitu_multijob:addons:cuff', function()
    ped = GetPlayerPed(-1)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

        if GetEntityModel(ped) == femaleHash then
            prevFemaleVariation = GetPedDrawableVariation(ped, 7)
            SetPedComponentVariation(ped, 7, 25, 0, 0)
        elseif GetEntityModel(ped) == maleHash then
            prevMaleVariation = GetPedDrawableVariation(ped, 7)
            SetPedComponentVariation(ped, 7, 41, 0, 0)
        end

        SetEnableHandcuffs(ped, true)
        TaskPlayAnim(ped, dict, anim, 8.0, -8, -1, flags, 0, 0, 0, 0)

    cuffed = not cuffed
    changed = true
end)

RegisterNetEvent('pitu_multijob:addons:uncuff')
AddEventHandler('pitu_multijob:addons:uncuff', function()
    ped = GetPlayerPed(-1)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

        ClearPedTasks(ped)
        SetEnableHandcuffs(ped, false)
        UncuffPed(ped)

        if GetEntityModel(ped) == femaleHash then -- mp female
            SetPedComponentVariation(ped, 7, prevFemaleVariation, 0, 0)
        elseif GetEntityModel(ped) == maleHash then -- mp male
            SetPedComponentVariation(ped, 7, prevMaleVariation, 0, 0)
        end

    cuffed = not cuffed

    changed = true
end)

RegisterNetEvent('pitu_multijob:addons:cuffcheck')
AddEventHandler('pitu_multijob:addons:cuffcheck', function()
  local player, distance = ESX_CF.Game.GetClosestPlayer()
  if distance ~= -1 and distance <= 3.0 then
    TriggerServerEvent('pitu_multijob:addons:cuffing', GetPlayerServerId(player))
  else
    ESX_CF.ShowNotification('No players nearby')
	end
end)

RegisterNetEvent('pitu_multijob:addons:nyckelcheck')
AddEventHandler('pitu_multijob:addons:nyckelcheck', function()
	local player, distance = ESX_CF.Game.GetClosestPlayer()
  if distance ~= -1 and distance <= 3.0 then
      TriggerServerEvent('pitu_multijob:addons:unlocking', GetPlayerServerId(player))
  else
    ESX_CF.ShowNotification('No players nearby')
	end
end)

RegisterNetEvent('pitu_multijob:addons:unlockingcuffs')
AddEventHandler('pitu_multijob:addons:unlockingcuffs', function()
  local player, distance = ESX_CF.Game.GetClosestPlayer()
	local ped = GetPlayerPed(-1)

	if IsLockpicking == false then
		ESX_CF.UI.Menu.CloseAll()
		FreezeEntityPosition(player,  true)
		FreezeEntityPosition(ped,  true)

		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)

		IsLockpicking = true

		Wait(30000)

		IsLockpicking = false

		FreezeEntityPosition(player,  false)
		FreezeEntityPosition(ped,  false)

		ClearPedTasksImmediately(ped)

		TriggerServerEvent('pitu_multijob:addons:search:unhandcuff', GetPlayerServerId(player))
		ESX_CF.ShowNotification('Handcuffs unlocked')
	else
		ESX_CF.ShowNotification('Your are already lockpicking handcuffs')
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not changed then
            ped = PlayerPedId()
            local IsCuffed = IsPedCuffed(ped)
            if IsCuffed and not IsEntityPlayingAnim(PlayerPedId(), dict, anim, 3) then
                Citizen.Wait(0)
                TaskPlayAnim(ped, dict, anim, 8.0, -8, -1, flags, 0, 0, 0, 0)
            end
        else
            changed = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        ped = PlayerPedId()
        if cuffed then
            DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
            DisableControlAction(0, 92, true) -- INPUT_VEH_PASSENGER_ATTACK
            DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK
            DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
            DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
            DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
            DisableControlAction(0, 257, true) -- INPUT_ATTACK2
            DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
            DisableControlAction(0, 264, true) -- INPUT_MELEE_ATTACK2
            DisableControlAction(0, 24, true) -- INPUT_ATTACK
            DisableControlAction(0, 25, true) -- INPUT_AIM
			DisableControlAction(0, 21, true) -- SHIFT
			DisableControlAction(0, 22, true) -- SPACE
			DisableControlAction(0, 288, true) -- F1
			DisableControlAction(0, 289, true) -- F2
			DisableControlAction(0, 170, true) -- F3
			DisableControlAction(0, 167, true) -- F6
			DisableControlAction(0, 168, true) -- F7
			DisableControlAction(0, 57, true) -- F10
			DisableControlAction(0, 73, true) -- X
        end
    end
end)
player_job = nil
f6menu_allowed = false
Citizen.CreateThread(function() -- job sync thread
    while ESX_CF == nil do Wait(10) end
    while true do
        ESX_CF.TriggerServerCallback('pitu_multijob:db:getPlayerJob', function(jobname)
            player_job = jobname
        end, 'jd')
        Wait(5000)
        while player_job == nil do Wait(0) end
        if player_job.job ~= nil then f6menu_allowed = true else f6menu_allowed = false end
    end
end)

Citizen.CreateThread(function()
    while ESX_CF == nil do Wait(10) end
    while true do
        if f6menu_allowed then
            if IsControlJustReleased(1,  167) then
                local elements = {
                    {label = 'Skuj Gracza', value = 'cuff'},
                    {label = 'Rozkuj Gracza', value = 'uncuff'},
                    {label = 'Przeszukaj Gracza', value = 'search'}
                }
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pitu_multijob_gang_actions', {
                    title    = 'Akcje Gangu',
                    align    = 'bottom-right',
                    elements = elements
                }, function(data, menu)
                    if data.current.value == 'cuff' then
                        local closestPlayer, closestPlayerDistance = ESX_CF.Game.GetClosestPlayer()
                        if closestPlayer == -1 or closestPlayerDistance > 3.0 then
                            ESX.ShowNotification('Nie ma nikogo w pobliżu')
                        else
                            TriggerServerEvent('pitu_multijob:addons:cuffing', GetPlayerServerId(closestPlayer))
                        end
                    elseif data.current.value == 'uncuff' then
                        local closestPlayer, closestPlayerDistance = ESX_CF.Game.GetClosestPlayer()
                        if closestPlayer == -1 or closestPlayerDistance > 3.0 then
                            ESX.ShowNotification('Nie ma nikogo w pobliżu')
                        else
                            TriggerServerEvent('pitu_multijob:addons:uncuff', GetPlayerServerId(closestPlayer))
                        end
                    elseif data.current.value == 'search' then
                        local closestPlayer, closestPlayerDistance = ESX_CF.Game.GetClosestPlayer()
                        if closestPlayer == -1 or closestPlayerDistance > 3.0 then
                            ESX.ShowNotification('Nie ma nikogo w pobliżu')
                        else
                            ESX.TriggerServerCallback('pitu_multijob:addons:getcuffStatus', function(iscuffed)
                                if iscuffed then
                                    print("can search")
                                    TriggerServerEvent('pitu_multijob:functions_s:notify', GetPlayerServerId(closestPlayer), 'Jesteś ~r~Przeszukiwany~w~ Przez ID: '..GetPlayerServerId(PlayerId()))
                                    ESX.ShowNotification('~r~Przeszukujesz~w~ ID: '..GetPlayerServerId(closestPlayer))
                                    if handcuff_config.enableInventoryHud then
                                        TriggerEvent("esx_inventoryhud:openPlayerInventory", GetPlayerServerId(closestPlayer), GetPlayerName(closestPlayer))
                                    else
                                        OpenBodySearchMenu(closestPlayer)
                                    end
                                else
                                    ESX.ShowNotification('Nie ma nikogo ~r~Skutego~w~ w pobliżu')
                                end
                            end, GetPlayerServerId(closestPlayer))
                            TriggerServerEvent('pitu_multijob:addons:search', GetPlayerServerId(closestPlayer))
                        end
                    end
                    menu.close()
                end, function(data, menu)
                    menu.close()
                end)
            end
        end
        Wait(0)
    end
end)

function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback('pitu_multijob:addons:search:getOtherPlayerData', function(data)
		local elements = {}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				table.insert(elements, {
					label    = "Brudne Pieniądze: "..ESX.Math.Round(data.accounts[i].money),
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})
				break
			end
		end

		table.insert(elements, {label = 'Broń'})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    =  ESX.GetWeaponLabel(data.weapons[i].name).. " | Amunicja: "..data.weapons[i].ammo,
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = 'Ekwipunek'})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = data.inventory[i].count.."x "..data.inventory[i].label,
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			title    = 'Przeszukiwanie',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				TriggerServerEvent('pitu_multijob:addons:search:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
				OpenBodySearchMenu(player)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end