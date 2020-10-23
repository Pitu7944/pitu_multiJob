--[[ edited ("insert date here") by :
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
            --print(json.encode(jobData))
            playerJob = jobData
        end, GetPlayerServerId(PlayerId()))
        Wait(Config.clientSyncTime*1000)
    end
end)

Citizen.CreateThread(function() -- register jobs from config
    while ESX == nil or playerJob == nil do Wait(0) end
    for _, configjob in pairs(Config.Jobs) do
        --print(playerJob.job)
        if playerJob.job == configjob.name then
            Citizen.CreateThread(function() -- draw job main blip
                for _,blip in pairs(configjob.blips) do
                    --print(tostring(blip))
                    --print(json.encode(blip))
                    --print("drawing blip")
                    --print(blip.label)
                    addBlip(blip.label, blip.id, blip.color, blip.pos.x, blip.pos.y, blip.pos.z)
                end
            end)
            Citizen.CreateThread(function() -- marker thread
                --print('pitu_multijob:zones:'..playerJob.job..':hasEnteredMarker')
                RegisterNetEvent('pitu_multijob:zones:'..playerJob.job..':hasEnteredMarker')
                AddEventHandler('pitu_multijob:zones:'..playerJob.job..':hasEnteredMarker', function(zone)
                    --print(zone)
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
                            --print('pitu_multijob:zones:'..playerJob.job..':hasEnteredMarker')
                            --print(currentZone)
                            TriggerEvent('pitu_multijob:zones:'..playerJob.job..':hasEnteredMarker', currentZone)
                        end
            
                        if not isInMarker and hasAlreadyEnteredMarker then
                            hasAlreadyEnteredMarker = false
                            --print('pitu_multijob:zones:'..playerJob.job..':hasEnteredMarker')
                            --print(currentZone)
                            TriggerEvent('pitu_multijob:zones:'..playerJob.job..':hasExitedMarker', lastZone)
                        end
                        local coords = GetEntityCoords(GetPlayerPed(-1))
                        --print(coords)
                        for k,v in pairs(configjob.zones) do
                            --print(json.encode(v))
                            --print("test")
                            if(GetDistanceBetweenCoords(coords, v.pos.x, v.pos.y, v.pos.z, true) < DrawDistance) then
                                --print("marker")
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
                                print(CurrentAction)
                                if CurrentAction == 'inWardrobeZone' then openMenu2() end
                                if CurrentAction == 'inStorageZone' then openMenu() end
                                if CurrentAction == 'inGarageZone' then carSpawnerMenu(configjob.zones.garage) end
                                if CurrentAction == 'inDeleterZone' then deletevehiclein() end
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
        Notify( "~r~Failed to delete vehicle, trying again..." )
        while ( DoesEntityExist( veh ) and timeout < timeoutMax ) do 
            DeleteVehicle( veh )
            if ( not DoesEntityExist( veh ) ) then 
                Notify( "~g~Vehicle Stored." )
            end 
            timeout = timeout + 1 
            Citizen.Wait( 500 )
            if ( DoesEntityExist( veh ) and ( timeout == timeoutMax - 1 ) ) then
                Notify( "~r~Failed to delete vehicle after " .. timeoutMax .. " retries." )
            end 
        end 
    else 
        Notify( "~g~Vehicle Stored." )
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
                Notify( "You must be in the driver's seat!" )
            end
        end 
    end
end

function openMenu()
    local elements = {
        {label = 'Item Deposit', value = 'deposit'},
        {label = 'Item Withdraw', value = 'withdraw'},
	}
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pitu_multijob_actions', {
		title    = 'Storage Room',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'deposit' then
            depositMenu()
        elseif data.current.value == 'withdraw' then
            withdrawMenu()
        end
	end, function(data, menu)
		menu.close()
	end)
end

function openMenu2()
    local elements = {
        {label = 'Select Outfit', value = 'dressup'},
        {label = 'Remove Outfit', value = 'rmoutf'}
	}
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pitu_multijob_clothin1', {
		title    = 'Wardrobe',
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
		title    = 'Item Deposit',
		align    = 'bottom-right',
		elements = elements
    }, function(data, menu)
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pitutm1ext_dep_am', {
            title    = 'Enter Amount',
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
		title    = 'Garage',
		align    = 'bottom-right',
		elements = elements
    }, function(data, menu)
        print("yoos")
        print(json.encode(garage))
        spawnCar(garage.spawner.x, garage.spawner.y, garage.spawner.z, garage.spawner.h, 'zentorno')
        menu.close()
        --print(x)
        --print(y)
        --print(z)
        --local veh = data.current.value
        --if veh ~= nil then
        --    print('xd')
        --end
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
            --print("waiting")
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
		title    = 'Item Withdraw',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
        dprint(data.current.value)
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pitutm1ext_withd_am', {
            title    = 'Enter Amount',
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
                title    = 'Select Outfit',
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
                title    = 'Remove Outfit',
                align    = 'bottom-right',
                elements = elements
            }, function(data3, menu3)
                menu3.close()
                TriggerServerEvent('esx_property:removeOutfit', data3.current.value)
                ESX.ShowNotification("Removed Outfit!")
            end, function(data3, menu3)
                menu3.close()
            end)
        end)
    end
end
-- debug functions:



--[[ edited ("insert date here") by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]