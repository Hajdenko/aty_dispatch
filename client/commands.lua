ESX = exports["es_extended"]:getSharedObject()

-- I don't think this still works so just add your own commands.
--[[local xPlayer = nil
Citizen.CreateThread(function()
    while true do
        xPlayer = ESX.GetPlayerData()
        if xPlayer ~= nil then
            playerName  = xPlayer.firstName.. " " .. xPlayer.lastName
        end

        Wait(100)
    end
end)]]

RegisterCommand("911", function(source)
    SendDispatch("Citizen needs help!", "911", 682, {"police", "sheriff"})
end)

--[[RegisterCommand("panic", function()
    if xPlayer == nil then xPlayer = ESX.GetPlayerData() Wait(250) end
    if xPlayer == nil then Notification("Notification", "Error in loading data", 'error', 5000) return end

    if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'ambulance' then
        SendDispatch("Officer ".. playerName .." is in danger!", "10-99", 480, {"police", "sheriff", "ambulance"}, "panic.wav", true)
    end
end)

RegisterCommand("panicb", function(source)
    if xPlayer == nil then xPlayer = ESX.GetPlayerData() Wait(250) end
    if xPlayer == nil then Notification("Notification", "Error in loading data", 'error', 5000) return end

    if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'ambulance' then
        SendDispatch("Officer ".. playerName .." is in car crash!", "10-99B", 480, {"police", "sheriff", "ambulance"}, "panic.wav", true)
    end
end)

RegisterCommand("panicc", function(source)
    if xPlayer == nil then xPlayer = ESX.GetPlayerData() Wait(250) end
    if xPlayer == nil then Notification("Notification", "Error in loading data", 'error', 5000) return end

    if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'ambulance' then
        SendDispatch("Officer ".. playerName .." DOWN!", "10-100", 480, {"police", "sheriff", "ambulance"}, "panic.wav", true)
    end
end)

RegisterCommand("loc", function(source)
    if xPlayer == nil then xPlayer = ESX.GetPlayerData() Wait(250) end
    if xPlayer == nil then Notification("Notification", "Error in loading data", 'error', 5000) return end

    if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' or xPlayer.job.name == 'ambulance' then
        LocSendDispatch("Location of Officer ".. playerName .."", "10-20", 480, {"police", "sheriff", "ambulance"}, false)
    end
end)--]]

RegisterCommand("showDispatch", function(source)
    for k, jobs in pairs(Config.WhitelistedJobs) do
        if PlayerJob == jobs then
            SendNUIMessage({
                action = "showDispatch"
            })

            SetNuiFocus(1, 1)
            return
        end
    end
end)
