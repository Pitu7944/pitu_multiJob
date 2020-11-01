--[[ edited ("insert date here") by :
 ___  _    _        ___  ___   __    __          ___  ___  _  _ 
| . \<_> _| |_ _ _ |_  || . | /. |  /. |  _|_|_ <_  >|_  |/ |/ |
|  _/| |  | | | | | / / `_  //_  .|/_  .| _|_|_  / /  / / | || |
|_|  |_|  |_| `___|/_/   /_/   |_|   |_|   | |  <___>/_/  |_||_|
any issues? Dm me on discord (Pitu7944#2711)
]]
ESX_FN = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX_FN = obj end)
        Citizen.Wait(0)
    end
end)

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

function getJobGradeLabel(job, grade)
    for i, ijob in pairs(Config.Jobs) do
        if ijob.name == job then
            for ii, igrade in pairs(ijob.grades) do
                if igrade.grade == grade then return igrade.label end
            end
        end
    end
    return nil
end

playernames = nil
function getRP_Names(Steamids)
    playernames = nil
    ESX.TriggerServerCallback('pitu_multijob:functions:getPlayerRPName', function(cbs, l_playernames)
        playernames = l_playernames
    end, Steamids)
    while playernames == nil do Wait(0) end
    return playernames
end

function getEmployeeData(jobMembers, JobMember_Data)
    print('------------------------')
    print(json.encode(jobMembers))
    print(json.encode(JobMember_Data))
    local employees_data = {}
    for i, ijobMember in pairs(jobMembers) do
        for ii, ijobMemberData in pairs(JobMember_Data) do
            if ijobMember.identifier == ijobMemberData.identifier then
                table.insert(employees_data, {identifier = ijobMember.identifier, name = ijobMemberData.name, grade = ijobMember.jobgrade, job = ijobMember.jobname, gradelabel = getJobGradeLabel(ijobMember.jobname, ijobMember.jobgrade)})
            end
        end
    end
    print('=========================')
    print(json.encode(employees_data))
    return employees_data
end


function dprint(txt)
    if Config.DebugEnabled == true then
        print("^4[^2"..GetCurrentResourceName().."^4] ^3"..tostring(txt)..'^0')
    end
end