--[[ edited ("insert date here") by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]

-- settings --
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
            print(json.encode(jobData))
            playerJob = jobData
        end, GetPlayerServerId(PlayerId()))
        Wait(Config.clientSyncTime*1000)
    end
end)

Citizen.CreateThread(function() -- register jobs from config
    while ESX == nil or playerJob == nil do Wait(0) end
    for _, configjob in pairs(Config.Jobs) do
        print(playerJob.job)
        if playerJob.job == configjob.name then
            Citizen.CreateThread(function() -- draw job main blip
                for _,blip in pairs(configjob.blips) do
                    print(tostring(blip))
                    print(json.encode(blip))
                    print("drawing blip")
                    print(blip.label)
                    addBlip(blip.label, blip.id, blip.color, blip.pos.x, blip.pos.y, blip.pos.z)
                end
            end)
            Citizen.CreateThread(function() -- marker thread

            end)
        end
    end
end)

RegisterCommand('openmenuxd', function()
    openMenu()
end, false)

function openMenu()
    local elements = {
        {label = 'Item Deposit', value = 'deposit'},
        {label = 'Item Withdraw', value = 'withdraw'},
        {label = 'Wardrobe', value = 'dressup'},
        {label = 'Remove Outfit', value = 'rmoutf'}
	}
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pitutm1ext_actions', {
		title    = 'pitu_tm1ext-inv-a',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'deposit' then
            depositMenu()
        elseif data.current.value == 'withdraw' then
            withdrawMenu()
        elseif data.current.value == 'dressup' then
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
    ESX.TriggerServerCallback('pitu_tm1ext:getPlayerItems', function(cbs, items)
        if cbs == true then dpmen_elements = items dprint(items) end
    end, 'test')
    while dpmen_elements == nil do Wait(10) dprint('waiting') end
    for _, item in pairs(dpmen_elements) do
        if item.count > 0 then
            local label = item.itemlabel.." x"..item.count
            table.insert(elements, {label = label, value = item.item})
        end
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
            TriggerServerEvent('pitu_tm1ext:storeItems', data.current.value, data2.value)
            Wait(500)
            menu2.close()
            dpmen_elements = nil
            elements = {}
            menu.close()
            depositMenu()
        end, function(data2, menu2)
            menu2.close()
        end)
        --print(data.current.value)
        --TriggerServerEvent('pitu_tm1ext:storeItems', data.current.value, data.current.count)
        --Wait(100)
        --depositMenu()
	end, function(data, menu)
		menu.close()
	end)
end

wtm_elements = nil
function withdrawMenu()
    local elements = {}
    wtm_elements = nil
    ESX.TriggerServerCallback('pitu_tm1ext:getItems', function(cbs, items)
        if cbs == true then wtm_elements = items dprint(items) end
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
            TriggerServerEvent('pitu_tm1ext:withdrawItems', data.current.value, data2.value)
            Wait(100)
            menu2.close()
            withdrawMenu()
        end, function(data2, menu2)
            menu2.close()
        end)
        --Wait(100)
        --withdrawMenu()
	end, function(data, menu)
		menu.close()
	end)
end
-- debug functions:



--[[ edited ("insert date here") by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]