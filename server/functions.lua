--[[ edited ("insert date here") by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]

ESX_FN = nil
Citizen.CreateThread(function()
    while ESX_FN == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX_FN = obj end)
        Citizen.Wait(0)
    end
end)

function conf_GetJobData(jobname)
    for i, ijob in pairs(Config.Jobs) do
        if ijob.name == jobname then
            return ijob
        end
    end
    return nil
end

function conf_getWeapon(jobdata, weapon)
    print(json.encode(jobdata))
    for i, iweapon in pairs(jobdata.zones.armory.weapons) do
        if iweapon.weaponName == weapon then
            return iweapon
        end
    end
    return nil
end

function dprint(txt)
    if Config.DebugEnabled == true then
        print("^4[^2"..GetCurrentResourceName().."^4] ^3"..tostring(txt)..'^0')
    end
end







dprint('[Functions] Loaded')