--[[ edited (22.04.2021) by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]

-- settings --


function ShowNotification( text )
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local debug_enable = false
playerJob = nil
-- code here :

print("Loaded")
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    
end)



Citizen.CreateThread(function() -- sync thread
    while ESX == nil do Wait(0) end
    while true do
        ESX.TriggerServerCallback('pitu_multijob:db:getPlayerJob', function(jobData)
            dprint(json.encode(jobData))
            playerJob = jobData
        end, GetPlayerServerId(PlayerId()))
        Wait(Config.clientSyncTime*1000)
    end
end)

Citizen.CreateThread(function()--command help show
    TriggerEvent('chat:addSuggestion', '/pmj_setjob', trs['setjob_tooltip'], {
        { name="ID", help=trs['setjob_helptext1'] },
        { name="Jobname", help=trs['setjob_helptext2'] },
        { name="Jobgrade", help=trs['setjob_helptext3'] },
    })
    TriggerEvent('chat:addSuggestion', '/pmj_unsetjob', trs['unsetjob_tooltip'], {
        { name="ID", help=trs['unsetjob_helptext1'] },
    })
    TriggerEvent('chat:addSuggestion', '/pmj_checkjob', trs['checkjob_tooltip'], {
        { name="ID", help=trs['checkjob_helptext1'] }
    })
    TriggerEvent('chat:addSuggestion', '/pmjinfo', trs['pmjinfo_tooltip'])
end)

Citizen.CreateThread(function() -- register jobs from config
    while ESX == nil or playerJob == nil do Wait(0) end
    for _, configjob in pairs(Config.Jobs) do
        dprint(playerJob.job)
        if playerJob.job == configjob.name then
            Citizen.CreateThread(function() -- draw job main blip
                for _,blip in pairs(configjob.blips) do
                    dprint(tostring(blip))
                    dprint(json.encode(blip))
                    dprint("drawing blip")
                    dprint(blip.label)
                    addBlip(blip.label, blip.id, blip.color, blip.pos.x, blip.pos.y, blip.pos.z)
                end
            end)
            Citizen.CreateThread(function() -- marker thread
                dprint('pitu_multijob:zones:'..playerJob.job..':hasEnteredMarker')
                RegisterNetEvent('pitu_multijob:zones:'..playerJob.job..':hasEnteredMarker')
                AddEventHandler('pitu_multijob:zones:'..playerJob.job..':hasEnteredMarker', function(zone)
                    dprint(zone)
                    if zone == 'storage' then
                        CurrentAction     = 'inStorageZone' -- current action
                        CurrentActionMsg  = configjob.zones.storage.label --  message displayed in marker
                        CurrentActionData = {}
                        isInZone = true
                    elseif zone == 'changerooms' then
                        CurrentAction     = 'inWardrobeZone' -- current action
                        CurrentActionMsg  = configjob.zones.changerooms.label  --  message displayed in marker
                        CurrentActionData = {}
                        isInZone = true
                    elseif zone == 'armory' then
                        CurrentAction     = 'inArmoryZone' -- current action
                        CurrentActionMsg  = configjob.zones.armory.label  --  message displayed in marker
                        CurrentActionData = {}
                        isInZone = true
                    elseif zone == 'garage' then
                        CurrentAction     = 'inGarageZone' -- current action
                        CurrentActionMsg  = configjob.zones.garage.label  --  message displayed in marker
                        CurrentActionData = {}
                        isInZone = true
                    elseif zone == 'deleter' then
                        CurrentAction     = 'inDeleterZone' -- current action
                        CurrentActionMsg  = configjob.zones.deleter.label --  message displayed in marker
                        CurrentActionData = {}
                        isInZone = true
                    elseif zone == 'boss' and playerJob.grade >= configjob.zones.boss.rq_grade then
                        CurrentAction     = 'inBossActionsZone' -- current action
                        CurrentActionMsg  = configjob.zones.boss.label --  message displayed in marker
                        CurrentActionData = {}
                        isInZone = true
                    end
                end)
                RegisterNetEvent('pitu_multijob:zones:'..playerJob.job..':hasExitedMarker')
                AddEventHandler('pitu_multijob:zones:'..playerJob.job..':hasExitedMarker', function(zone)
                    CurrentAction = nil
                    isInZone = false
                end)
                Citizen.CreateThread(function()
                    while true do
                        Wait(0)
                        local MarkerType   = 27
                        local DrawDistance = 100.0
                        local MarkerColor  = {r = 100, g = 204, b = 100}
                        local ZoneSize     = {x = 3.0, y = 3.0, z = 3.0}
                        local coords      = GetEntityCoords(GetPlayerPed(-1))
                        local isInMarker  = false
                        local currentZone = nil
                        for k,v in pairs(configjob.zones) do
                            if(GetDistanceBetweenCoords(coords, v.pos.x, v.pos.y, v.pos.z, true) < ZoneSize.x / 2) then
                                isInMarker  = true
                                currentZone = k
                            end
                        end
            
                        if isInMarker and not hasAlreadyEnteredMarker then
                            hasAlreadyEnteredMarker = true
                            lastZone                = currentZone
                            dprint('pitu_multijob:zones:'..playerJob.job..':hasEnteredMarker')
                            dprint(currentZone)
                            TriggerEvent('pitu_multijob:zones:'..playerJob.job..':hasEnteredMarker', currentZone)
                        end
            
                        if not isInMarker and hasAlreadyEnteredMarker then
                            hasAlreadyEnteredMarker = false
                            dprint('pitu_multijob:zones:'..playerJob.job..':hasEnteredMarker')
                            dprint(currentZone)
                            TriggerEvent('pitu_multijob:zones:'..playerJob.job..':hasExitedMarker', lastZone)
                        end
                        local coords = GetEntityCoords(GetPlayerPed(-1))
                        dprint(coords)
                        for k,v in pairs(configjob.zones) do
                            dprint(json.encode(v))
                            dprint("test")
                            if(GetDistanceBetweenCoords(coords, v.pos.x, v.pos.y, v.pos.z, true) < DrawDistance) and k ~= 'boss' then
                                dprint("marker")
                                DrawMarker(MarkerType, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ZoneSize.x, ZoneSize.y, ZoneSize.z, MarkerColor.r, MarkerColor.g, MarkerColor.b, 100, false, true, 2, false, false, false, false)
                            elseif(GetDistanceBetweenCoords(coords, v.pos.x, v.pos.y, v.pos.z, true) < DrawDistance) and k == 'boss' and playerJob.grade >= configjob.zones.boss.rq_grade then
                                dprint("marker_boss")
                                DrawMarker(MarkerType, v.pos.x, v.pos.y, v.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, ZoneSize.x, ZoneSize.y, ZoneSize.z, MarkerColor.r, MarkerColor.g, MarkerColor.b, 100, false, true, 2, false, false, false, false)
                            end
                        end
                        if CurrentAction ~= nil then
                            SetTextComponentFormat('STRING')
                            AddTextComponentString(CurrentActionMsg)
                            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                        end
                    end
                end)
                Citizen.CreateThread(function()
                    while true do
                        Citizen.Wait(0)
                        if CurrentAction ~= nil then
                            ESX.ShowHelpNotification(CurrentActionMsg)
                            if IsControlJustReleased(0, Keys['E']) then
                                dprint(CurrentAction)
                                if CurrentAction == 'inWardrobeZone' then openMenu2() end
                                if CurrentAction == 'inStorageZone' then openMenu() end
                                if CurrentAction == 'inGarageZone' then carSpawnerMenu(configjob.zones.garage) end
                                if CurrentAction == 'inDeleterZone' then deletevehiclein() end
                                if CurrentAction == 'inArmoryZone' then openArmoryMenu() end
                                if CurrentAction == 'inBossActionsZone' then OpenbossMenu() end
                                CurrentAction = nil
                            end
                        else
                            Citizen.Wait(500)
                        end
                    end
                end)
            end)
        end
    end
end)

function Notify( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end

function DeleteGivenVehicle( veh, timeoutMax )
    local timeout = 0 
    SetEntityAsMissionEntity( veh, true, true )
    DeleteVehicle( veh )
    if ( DoesEntityExist( veh ) ) then
        Notify(trs['delete_vehicle_failed'])
        while ( DoesEntityExist( veh ) and timeout < timeoutMax ) do 
            DeleteVehicle( veh )
            if ( not DoesEntityExist( veh ) ) then 
                Notify(trs['delete_vehicle_succes'])
            end 
            timeout = timeout + 1 
            Citizen.Wait( 500 )
            if ( DoesEntityExist( veh ) and ( timeout == timeoutMax - 1 ) ) then
                Notify(string.format(trs['delete_vehicle_failed_try_amount'], timeoutMax))
            end 
        end 
    else 
        Notify(trs['delete_vehicle_succes'])
    end 
end 

function deletevehiclein()
    local ped = GetPlayerPed( -1 )
    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
        local pos = GetEntityCoords( ped )
        if ( IsPedSittingInAnyVehicle( ped ) ) then 
            local vehicle = GetVehiclePedIsIn( ped, false )
            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then 
                DeleteGivenVehicle( vehicle, numRetries )
            else 
                Notify(trs['delete_vehicle_not_driver'])
            end
        end 
    end
end

function OpenbossMenu()
    ESX.UI.Menu.CloseAll()
    local elements = {
        {label = trs['boss_menu_promote_fire'], value = 'awans/zwolnij'},
        {label = trs['boss_menu_hire'], value = 'zatrudnij'}
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pitu_multijob_boss_actions', {
        title    = trs['boss_menu_title'],
        align    = 'bottom-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'awans/zwolnij' then
            OpenEmployeeList()
        elseif data.current.value == 'zatrudnij' then
            OpenHireMenu()
        end
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

function OpenHireMenu()
    ESX.TriggerServerCallback('pitu_multijob:utils:getPlayers', function(players)
        local elements = {
			head = {"Gracz", 'Czynności'},
			rows = {}
        }
        for i, player in pairs(players) do
			table.insert(elements.rows, {
				data = player,
				cols = {
					player.name,
					'{{' .. trs['boss_menu_hire'] .. '|hire}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'hire_list', elements, function(data, menu)
            local player = data.data
            if data.value == 'hire' then
                ESX.ShowNotification(string.format(trs['boss_menu_hire_notification'], player.name))
                dprint("zatrudnianie....")
                ESX.TriggerServerCallback('pitu_mulitjob:db:setjobSteamID', function(status)
                    dprint(tostring(status))
                    menu.close()
                    OpenHireMenu()
                end, {steamID = player.identifier, job = playerJob.job, grade = 1})
                dprint("zatrudniono?")
			end
		end, function(data, menu)
			menu.close()
		end)
    end, '')
end

function OpenEmployeeList()
    ESX.TriggerServerCallback('pitu_multijob:bmenu:getjobMembers', function(cbs, jobMembers)
        local steamIDS = {}

        for i, ijob in pairs(jobMembers) do
            table.insert(steamIDS, ijob.identifier)
        end
        local employees = getEmployeeData(jobMembers, getRP_Names(steamIDS))
        local elements = {
			head = {trs['boss_menu_member'], trs['boss_menu_grade'], trs['boss_menu_actions']},
			rows = {}
        }
        for i=1, #employees, 1 do
			local gradeLabel = employees[i].gradelabel

			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					gradeLabel,
					'{{' .. trs['boss_menu_promote'] .. '|promote}} {{' .. trs['boss_menu_fire'] .. '|fire}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list', elements, function(data, menu)
			local employee = data.data
            if data.value == 'promote' then
                print(json.encode(employee))
                local newgrade = employee.grade + 1
                if newgrade > 5 then ESX.ShowNotification(string.format(trs['boss_menu_cant_promote'], employee.name)) return end
                ESX.ShowNotification(string.format(trs['boss_menu_promote_succes'], employee.name, getJobGradeLabel(employee.job, newgrade)))
                ESX.TriggerServerCallback('pitu_mulitjob:db:setjobSteamID', function(status)
                    dprint(tostring(status))
                    menu.close()
                    OpenEmployeeList()
                end, {steamID = employee.identifier, job = employee.job, grade = newgrade})
			elseif data.value == 'fire' then
                ESX.ShowNotification(string.format(trs['boss_menu_fire_succes'], employee.name))
                ESX.TriggerServerCallback('pitu_multijob:db:firePlayer', function(status)
                    dprint(tostring(status))
                    menu.close()
                    OpenEmployeeList()
                end, {steamHex = employee.identifier})
			end
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

function OpenGetBMStocksMenu()
	blackmoney = 0
	ESX.TriggerServerCallback('pitu_multijob:db:getBlackMoneyStock', function(cb, blackmoneyamount)
		dprint(cb)
		dprint(tostring(blackmoneyamount))
		blackmoney = blackmoneyamount
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'bmstockget', {
			title    = string.format(trs['black_money_dialog'], tostring(blackmoney)),
			align    = 'bottom-right',
		}, function(data2, menu2)
			dprint(data2.value)
			TriggerServerEvent('pitu_multijob:db:setBlackMoneyStock', tonumber(data2.value)*-1, false)
			Wait(100)
			menu2.close()
			--OpenArmoryMenu()
		end, function(data2, menu2)
			menu2.close()
		end)
	end)
	
end

function OpenPutBMStocksMenu()
	blackmoney = 0
    ESX.TriggerServerCallback('pitu_multijob:db:getPlayerBlackMoney', function(cb, blackmoneyamount)
		blackmoney = blackmoneyamount
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'bmstockget', {
			title    = string.format(trs['black_money_dialog'], tostring(blackmoney)),
			align    = 'bottom-right',
		}, function(data2, menu2)
			dprint(data2.value)
			TriggerServerEvent('pitu_multijob:db:setBlackMoneyStock', tonumber(data2.value), true)
			Wait(100)
			menu2.close()
			--OpenArmoryMenu()
		end, function(data2, menu2)
			menu2.close()
		end)
	end)
end

function OpenGetCashStocksMenu()
	money = 0
	ESX.TriggerServerCallback('pitu_multijob:db:getMoneyStock', function(cb, moneyamount)
		dprint(cb)
		dprint(tostring(moneyamount))
		money = moneyamount
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'mstockget', {
			title    = string.format(trs['black_money_dialog'], tostring(moneyamount)),
			align    = 'bottom-right',
		}, function(data2, menu2)
			dprint(data2.value)
			TriggerServerEvent('pitu_multijob:db:setMoneyStock', tonumber(data2.value)*-1, false)
			Wait(100)
			menu2.close()
			--OpenArmoryMenu()
		end, function(data2, menu2)
			menu2.close()
		end)
	end)
	
end

function openArmoryMenu()
    --pitu_multijob:shop:buyWeapon
    ESX.TriggerServerCallback('pitu_multijob:conf:getJobWeaponStore', function(cb, conf_weapons)
        local elements = {}
        for i, iweapon in pairs(conf_weapons) do 
            dprint(json.encode(iweapon))
            local l_label = iweapon.label.." - "..iweapon.price.. "$"
            table.insert(elements, {label = l_label, value = iweapon.weaponName})
        end
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pitu_multijob_actions', {
            title    = 'Zbrojownia',
            align    = 'bottom-right',
            elements = elements
        }, function(data, menu)
            TriggerServerEvent('pitu_multijob:shop:buyWeapon', data.current.value)
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
    end)
end
function OpenPutCashStocksMenu()
	money = 0
	ESX.TriggerServerCallback('pitu_multijob:db:getPlayerMoney', function(cb, moneyamount)
		money = moneyamount
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'mstockget', {
			title    = string.format(trs['black_money_dialog'], tostring(moneyamount)),
			align    = 'bottom-right',
		}, function(data2, menu2)
			print(data2.value)
			TriggerServerEvent('pitu_multijob:db:setMoneyStock', tonumber(data2.value), true)
			Wait(100)
			menu2.close()
			--OpenArmoryMenu()
		end, function(data2, menu2)
			menu2.close()
		end)
	end)
end


function openMenu()
    local elements = {
        {label = trs['storage_deposit_item'], value = 'deposit'},
        {label = trs['storage_withdraw_item'], value = 'withdraw'},
    }
    table.insert(elements, {label = trs['money_black_deposit_label'], value = "put_bmstock"})
    table.insert(elements, {label = trs['money_deposit_label'], value = "put_mstock"})
    table.insert(elements, {label = trs['money_black_withdraw_label'], value = "get_bmstock"})
	table.insert(elements, {label = trs['money_withdraw_label'], value = "get_mstock"})
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pitu_multijob_actions', {
		title    = trs['storage_label'],
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'deposit' then
            depositMenu()
        elseif data.current.value == 'withdraw' then
            withdrawMenu()
        elseif data.current.value == "get_bmstock" then
            OpenGetBMStocksMenu()
        elseif data.current.value == "put_bmstock" then
            OpenPutBMStocksMenu()
        elseif data.current.value == "get_mstock" then
            OpenGetCashStocksMenu()
        elseif data.current.value == "put_mstock" then
            OpenPutCashStocksMenu()
        end
	end, function(data, menu)
		menu.close()
	end)
end

function openMenu2()
    local elements = {
        {label = trs['outfit_select'], value = 'dressup'},
        {label = trs['outfit_remove'], value = 'rmoutf'}
	}
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pitu_multijob_clothin1', {
		title    = trs['outfit_label'],
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
        if data.current.value == 'dressup' then
            clothesMenu('dressup')
        elseif data.current.value == 'rmoutf' then
            clothesMenu('rmoutf')
        end
	end, function(data, menu)
		menu.close()
	end)
end

dpmen_elements = nil
function depositMenu()
    local elements = {}
    dpmen_elements = nil
    ESX.TriggerServerCallback('pitu_multijob:db:getPlayerStorage', function(cb, items)
        if cb == true then dpmen_elements = items print(json.encode(items)) end
    end, 'xd')
    while dpmen_elements == nil do Wait(10) dprint('waiting') end
    for _, item in pairs(dpmen_elements) do
        local label = item.label.." x"..item.amount
        table.insert(elements, {label = label, value = item.item})
    end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pitutm1ext_deposit', {
		title    = trs['item_deposit_label'],
		align    = 'bottom-right',
		elements = elements
    }, function(data, menu)
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pitutm1ext_dep_am', {
            title    = trs['item_amount_dialog'],
            align    = 'bottom-right',
        }, function(data2, menu2)
            if data2.value ~= nil then
                TriggerServerEvent('pitu_multijob:db:storeItem', data.current.value, data2.value)
                Wait(500)
                menu2.close()
                dpmen_elements = nil
                elements = {}
                menu.close()
                depositMenu()
            end
        end, function(data2, menu2)
            menu2.close()
        end)
	end, function(data, menu)
		menu.close()
	end)
end

function carSpawnerMenu(garage)
    local elements = {}
    for _, vehicle in pairs(garage.vehicles) do
        table.insert(elements, {label = vehicle.label, value = vehicle.spawnName})
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pitumultijob_garage', {
		title    = trs['garage_label'],
		align    = 'bottom-right',
		elements = elements
    }, function(data, menu)
        dprint("yoos")
        dprint(json.encode(garage))
        spawnCar(garage.spawner.x, garage.spawner.y, garage.spawner.z, garage.spawner.h, data.current.value)
        menu.close()
        dprint(x)
        dprint(y)
        dprint(z)
	end, function(data, menu)
		menu.close()
    end)
end

function spawnCar(x, y, z, h, model)
    print(x)
    print(y)
    print(z)
    print(h)
    print(model)
    vehiclehash = GetHashKey(model)
    RequestModel(vehiclehash)
    Citizen.CreateThread(function() 
        local waiting = 0
        while not HasModelLoaded(vehiclehash) do
            waiting = waiting + 100
            Citizen.Wait(100)
            dprint("waiting")
            if waiting > 5000 then
                break
            end
        end
        local spawnedveh = CreateVehicle(vehiclehash, x, y, z, h, 1, 0)
        SetPedIntoVehicle(GetPlayerPed(-1), spawnedveh, -1)
    end)
end

wtm_elements = nil
function withdrawMenu()
    local elements = {}
    wtm_elements = nil
    ESX.TriggerServerCallback('pitu_multijob:db:getJobStorage', function(cbs, items)
        wtm_elements = items
    end, 'test')
    while wtm_elements == nil do Wait(10) end
    for _, item in pairs(wtm_elements) do
        if item.amount > 0 then
            local label = item.label.." x"..item.amount
            table.insert(elements, {label = label, value = item.item})
        end
    end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pitutm1ext_withdraw', {
		title    = trs['storage_withdraw_item'],
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
        dprint(data.current.value)
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pitutm1ext_withd_am', {
            title    = trs['item_amount_dialog'],
            align    = 'bottom-right',
        }, function(data2, menu2)
            if data2.value ~= nil then
                TriggerServerEvent('pitu_multijob:db:getItem', data.current.value, data2.value)
                Wait(100)
                menu2.close()
                menu.close()
                withdrawMenu()
            end
        end, function(data2, menu2)
            menu2.close()
        end)
	end, function(data, menu)
		menu.close()
	end)
end

function clothesMenu(mode)
    if mode == 'dressup' then
        ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
            local elements = {}

            for i=1, #dressing, 1 do
                table.insert(elements, {
                    label = dressing[i],
                    value = i
                })
            end

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
                title    = trs['outfit_select'],
                align    = 'bottom-right',
                elements = elements
            }, function(data3, menu3)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
                        TriggerEvent('skinchanger:loadClothes', skin, clothes)
                        TriggerEvent('esx_skin:setLastSkin', skin)

                        TriggerEvent('skinchanger:getSkin', function(skin)
                            TriggerServerEvent('esx_skin:save', skin)
                        end)
                    end, data3.current.value)
                end)
            end, function(data3, menu3)
                menu3.close()
            end)
        end)

    else 
        ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
            local elements = {}
            for i=1, #dressing, 1 do
                table.insert(elements, {
                    label = dressing[i],
                    value = i
                })
            end

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
                title    = trs['outfit_remove'],
                align    = 'bottom-right',
                elements = elements
            }, function(data3, menu3)
                menu3.close()
                TriggerServerEvent('esx_property:removeOutfit', data3.current.value)
                ESX.ShowNotification(trs['outfit_remove_notification'])
            end, function(data3, menu3)
                menu3.close()
            end)
        end)
    end
end

RegisterNetEvent('pitu_multijob:functions:notify')
AddEventHandler('pitu_multijob:functions:notify', function(message)
    local msg = message 
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(false, false)
end)
-- debug functions:



--[[ edited (22.04.2021) by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]