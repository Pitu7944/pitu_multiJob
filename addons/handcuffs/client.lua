if Config.Enable_Handcuffs then
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
    local cuffed = false

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
                DisableControlAction(0, 1, true) -- Disable pan
                DisableControlAction(0, 2, true) -- Disable tilt
                DisableControlAction(0, 24, true) -- Attack
                DisableControlAction(0, 257, true) -- Attack 2
                DisableControlAction(0, 25, true) -- Aim
                DisableControlAction(0, 263, true) -- Melee Attack 1
                DisableControlAction(0, 32, true) -- W
                DisableControlAction(0, 34, true) -- A
                DisableControlAction(0, 31, true) -- S
                DisableControlAction(0, 30, true) -- D
                DisableControlAction(0, 45, true) -- Reload
                DisableControlAction(0, 22, true) -- Jump
                DisableControlAction(0, 44, true) -- Cover
                DisableControlAction(0, 37, true) -- Select Weapon
                DisableControlAction(0, 23, true) -- Also 'enter'?
                DisableControlAction(0, 288,  true) -- Disable phone
                DisableControlAction(0, 289, true) -- Inventory
                DisableControlAction(0, 170, true) -- Animations
                DisableControlAction(0, 167, true) -- Job
                DisableControlAction(0, 0, true) -- Disable changing view
                DisableControlAction(0, 26, true) -- Disable looking behind
                DisableControlAction(0, 73, true) -- Disable clearing animation
                DisableControlAction(2, 199, true) -- Disable pause screen
                DisableControlAction(0, 59, true) -- Disable steering in vehicle
                DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
                DisableControlAction(0, 72, true) -- Disable reversing in vehicle
                DisableControlAction(2, 36, true) -- Disable going stealth
                DisableControlAction(0, 47, true)  -- Disable weapon
                DisableControlAction(0, 264, true) -- Disable melee
                DisableControlAction(0, 257, true) -- Disable melee
                DisableControlAction(0, 140, true) -- Disable melee
                DisableControlAction(0, 141, true) -- Disable melee
                DisableControlAction(0, 142, true) -- Disable melee
                DisableControlAction(0, 143, true) -- Disable melee
                DisableControlAction(0, 75, true)  -- Disable exit vehicle
                DisableControlAction(27, 75, true) -- Disable exit vehicle
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
                        {label = 'Przeszukaj Gracza', value = 'search'},
                        {label = 'Przenieś Gracza', value = 'drag'},
                        {label = 'Włóż do Pojazdu', value = 'put_in_vehicle'},
                        {label = 'Wyjmij z Pojazdu', value = 'out_the_vehicle'},
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
                        elseif data.current.value == 'drag' then
                            local closestPlayer, closestPlayerDistance = ESX_CF.Game.GetClosestPlayer()
                            print("trying to drag: "..GetPlayerServerId(closestPlayer))
                            TriggerServerEvent('pitu_multijob:addons:drag', GetPlayerServerId(closestPlayer))
                        elseif data.current.value == 'put_in_vehicle' then
                            local closestPlayer, closestPlayerDistance = ESX_CF.Game.GetClosestPlayer()
                            TriggerServerEvent('pitu_multijob:addons:putInVehicle', GetPlayerServerId(closestPlayer))
                        elseif data.current.value == 'out_the_vehicle' then
                            local closestPlayer, closestPlayerDistance = ESX_CF.Game.GetClosestPlayer()
                            TriggerServerEvent('pitu_multijob:addons:OutVehicle', GetPlayerServerId(closestPlayer))
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
    dragStatus = {}
    dragStatus.isDragged, isInShopMenu = false, false

    RegisterNetEvent('pitu_multijob:addons:drag')
    AddEventHandler('pitu_multijob:addons:drag', function(copId)
        print("yoooos")
        if cuffed then
            print("dragging")
            dragStatus.isDragged = not dragStatus.isDragged
            dragStatus.CopId = copId
        end
    end)

    Citizen.CreateThread(function()
        local wasDragged

        while true do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()

            if cuffed and dragStatus.isDragged then
                local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

                if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
                    if not wasDragged then
                        AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                        wasDragged = true
                    else
                        Citizen.Wait(1000)
                    end
                else
                    wasDragged = false
                    dragStatus.isDragged = false
                    DetachEntity(playerPed, true, false)
                end
            elseif wasDragged then
                wasDragged = false
                DetachEntity(playerPed, true, false)
            else
                Citizen.Wait(500)
            end
        end
    end)

    RegisterNetEvent('pitu_multijob:addons:putInVehicle')
    AddEventHandler('pitu_multijob:addons:putInVehicle', function()
        if cuffed then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)

            if IsAnyVehicleNearPoint(coords, 5.0) then
                local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

                if DoesEntityExist(vehicle) then
                    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

                    for i=maxSeats - 1, 0, -1 do
                        if IsVehicleSeatFree(vehicle, i) then
                            freeSeat = i
                            break
                        end
                    end

                    if freeSeat then
                        TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
                        dragStatus.isDragged = false
                    end
                end
            end
        end
    end)

    RegisterNetEvent('pitu_multijob:addons:OutVehicle')
    AddEventHandler('pitu_multijob:addons:OutVehicle', function()
        local playerPed = PlayerPedId()

        if IsPedSittingInAnyVehicle(playerPed) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            TaskLeaveVehicle(playerPed, vehicle, 64)
        end
    end)
end