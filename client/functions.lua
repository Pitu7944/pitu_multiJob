--[[ edited ("insert date here") by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]


function addBlip(label, id, color, x, y, z)
    blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, id)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
end



function dprint(txt)
    if Config.DebugEnabled == true then
        print("^4[^2"..GetCurrentResourceName().."^4] ^3"..tostring(txt)..'^0')
    end
end