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

function dprint(txt)
    print("^4[^2"..GetCurrentResourceName().."^4] ^3"..tostring(txt)..'^0')
end







dprint('[Functions] Loaded')