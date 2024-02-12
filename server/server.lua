Framework = Config.Framework == "esx" and exports['es_extended']:getSharedObject() or exports['qb-core']:GetCoreObject()

--[[RegisterNetEvent("aty_dispatch:server:printtheft")
AddEventHandler("aty_dispatch:server:printtheft", function(source, vehicle_, coords_, vehicleName_, playerName_)
	local src = source
	--local vehicle = GetVehiclePedIsIn(src, 0)
	--local coords = GetEntityCoords(src)
	--local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
	--local playerName = GetPlayerName(src)
	print(playerName_.. ' právě ukradl ' ..vehicleName_..' na souřadnicích '.. coords_)
end)--]]
RegisterNetEvent("aty_dispatch:server:kradez")
AddEventHandler("aty_dispatch:server:kradez", function(vehicle_, coords_, vehicleName_, playerName_)
	local src = source
	--local vehicle = GetVehiclePedIsIn(src, 0)
	--local coords = GetEntityCoords(src)
	--local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
	--local playerName = GetPlayerName(src)
    print(playerName_.. ' stole ' ..vehicleName_..'. Coords: '.. coords_)
end)

RegisterNetEvent("aty_dispatch:server:pokus_kradez")
AddEventHandler("aty_dispatch:server:pokus_kradez", function(vehicle_, coords_, vehicleName_, playerName_) -- vehicleName_ se muze pouzit jako co chtel ukradnout
	local src = source
	--local vehicle = GetVehiclePedIsIn(src, 0)
	--local coords = GetEntityCoords(src)
	--local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
	--local playerName = GetPlayerName(src)
    print(playerName_.. ' tried to steal a vehicle named ' ..vehicleName_..'. Coords: '.. coords_)
end)

RegisterNetEvent("aty_dispatch:server:shootingDispatch", function(title, code, location, coords, gender, weapon, vehicleName, vehicleSpeed, vehicle, jobs, sound, panic_effect)
    local players = GetPlayers()

    for i, player in ipairs(players) do
        local player = tonumber(player)
        if Config.Framework == "qb" then
            local xPlayer = Framework.Functions.GetPlayer(player)
            
            if xPlayer ~= nil then
                if Config.Enable.UseGPS then
                    --for _, job in pairs(jobs) do
                    local item = xPlayer.Functions.GetItemByName(Config.GPSItem) and xPlayer.Functions.GetItemByName(Config.GPSItem).amount or 0
                    if item > 0 then
                        if xPlayer.PlayerData.job.name == 'sheriff' or xPlayer.PlayerData.job.name == 'police' then
                            TriggerClientEvent("aty_dispatch:client:shootingDispatch", player, title, code, location, coords, gender, weapon, vehicleName, vehicleSpeed, vehicle, sound, panic_effect)
                        end
                    end
                    --end
                else
                    --for _, job in pairs(jobs) do
                    if xPlayer.PlayerData.job.name == 'sheriff' or xPlayer.PlayerData.job.name == 'police' then
                        TriggerClientEvent("aty_dispatch:client:shootingDispatch", player, title, code, location, coords, gender, weapon, vehicleName, vehicleSpeed, vehicle, sound, panic_effect)
                    end
                    --end
                end
            end
        else
            local xPlayer = Framework.GetPlayerFromId(player)

            if xPlayer ~= nil then
                if Config.Enable.UseGPS then
                    if type(jobs) == "table" then
                        for _, job in pairs(jobs) do
                            local item = xPlayer.getInventoryItem(Config.GPSItem) and xPlayer.getInventoryItem(Config.GPSItem).count or 0
                            if item > 0 then
                                if xPlayer.job.name == job then
                                    TriggerClientEvent("aty_dispatch:client:shootingDispatch", player, title, code, location, coords, gender, weapon, vehicleName, vehicleSpeed, vehicle, sound, panic_effect)
                                end  
                            end
                        end
                    else
                        local item = xPlayer.getInventoryItem(Config.GPSItem) and xPlayer.getInventoryItem(Config.GPSItem).count or 0
                        if item > 0 then
                            if xPlayer.job.name == jobs then
                                TriggerClientEvent("aty_dispatch:client:shootingDispatch", player, title, code, location, coords, gender, weapon, vehicleName, vehicleSpeed, vehicle, sound, panic_effect)
                            end  
                        end
                    end
                else
                    if type(jobs) == "table" then
                        for _, job in pairs(jobs) do
                            if xPlayer.job.name == job then
                                TriggerClientEvent("aty_dispatch:client:shootingDispatch", player, title, code, location, coords, gender, weapon, vehicleName, vehicleSpeed, vehicle, sound, panic_effect)
                            end
                        end
                    else
                        if xPlayer.job.name == jobs then
                            TriggerClientEvent("aty_dispatch:client:shootingDispatch", player, title, code, location, coords, gender, weapon, vehicleName, vehicleSpeed, vehicle, sound, panic_effect)
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("aty_dispatch:server:customDispatch", function(title, code, location, coords, gender, vehicleName, vehicleSpeed, vehicle, weapon, blipSprite, jobs, sound, panic_effect)
    local players = GetPlayers()

    for i, player in ipairs(players) do
        player = tonumber(player)
        if Config.Framework == "qb" then
            local xPlayer = Framework.Functions.GetPlayer(player)
            
            if xPlayer ~= nil then
                if Config.Enable.UseGPS then
                    if type(jobs) == "table" then
                        for _, job in pairs(jobs) do
                            local item = xPlayer.Functions.GetItemByName(Config.GPSItem) and xPlayer.Functions.GetItemByName(Config.GPSItem).amount or 0
                            if item > 0 then
                                if xPlayer.PlayerData.job.name == job then
                                    TriggerClientEvent("aty_dispatch:client:customDispatch", player, title, code, location, coords, gender, vehicleName, vehicleSpeed, vehicle, weapon, blipSprite, sound, panic_effect)
                                end
                            end
                        end
                    else
                        local item = xPlayer.Functions.GetItemByName(Config.GPSItem) and xPlayer.Functions.GetItemByName(Config.GPSItem).amount or 0
                        if item > 0 then
                            if xPlayer.PlayerData.job.name == jobs then
                                TriggerClientEvent("aty_dispatch:client:customDispatch", player, title, code, location, coords, gender, vehicleName, vehicleSpeed, vehicle, weapon, blipSprite, sound, panic_effect)
                            end
                        end
                    end
                else
                    if type(jobs) == "table" then
                        for _, job in pairs(jobs) do
                            if xPlayer.PlayerData.job.name == job then
                                TriggerClientEvent("aty_dispatch:client:customDispatch", player, title, code, location, coords, gender, vehicleName, vehicleSpeed, vehicle, weapon, blipSprite, sound, panic_effect)
                            end
                        end
                    else
                        if xPlayer.PlayerData.job.name == jobs then
                            TriggerClientEvent("aty_dispatch:client:customDispatch", player, title, code, location, coords, gender, vehicleName, vehicleSpeed, vehicle, weapon, blipSprite, sound, panic_effect)
                        end
                    end
                end
            end
        else
            local xPlayer = Framework.GetPlayerFromId(player)

            if xPlayer ~= nil then
                if Config.Enable.UseGPS then
                    if type(jobs) == "table" then
                        for _, job in pairs(jobs) do
                            local item = xPlayer.getInventoryItem(Config.GPSItem) and xPlayer.getInventoryItem(Config.GPSItem).count or 0
                            if xPlayer.job.name == job and item > 0 then
                                TriggerClientEvent("aty_dispatch:client:customDispatch", player, title, code, location, coords, gender, vehicleName, vehicleSpeed, vehicle, weapon, blipSprite, sound, panic_effect)
                            end
                        end
                    else 
                        local item = xPlayer.getInventoryItem(Config.GPSItem) and xPlayer.getInventoryItem(Config.GPSItem).count or 0
                        if item > 0 then
                            if xPlayer.job.name == jobs then
                                TriggerClientEvent("aty_dispatch:client:customDispatch", player, title, code, location, coords, gender, vehicleName, vehicleSpeed, vehicle, weapon, blipSprite, sound, panic_effect)
                            end
                        end
                    end
                else
                    if type(jobs) == "table" then
                        for _, job in pairs(jobs) do
                            if xPlayer.job.name == job then
                                TriggerClientEvent("aty_dispatch:client:customDispatch", player, title, code, location, coords, gender, vehicleName, vehicleSpeed, vehicle, weapon, blipSprite, sound, panic_effect)
                            end
                        end
                    else
                        if xPlayer.job.name == jobs then
                            TriggerClientEvent("aty_dispatch:client:customDispatch", player, title, code, location, coords, gender, vehicleName, vehicleSpeed, vehicle, weapon, blipSprite, sound, panic_effect)
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("aty_dispatch:server:locationDispatch", function(title, code, location, coords, blipSprite, jobs, sound, panic_effect)
    local players = GetPlayers()

    for i, player in ipairs(players) do
        player = tonumber(player)
        if Config.Framework == "qb" then
            local xPlayer = Framework.Functions.GetPlayer(player)
            
            if xPlayer ~= nil then
                if Config.Enable.UseGPS then
                    if type(jobs) == "table" then
                        for _, job in pairs(jobs) do
                            local item = xPlayer.Functions.GetItemByName(Config.GPSItem) and xPlayer.Functions.GetItemByName(Config.GPSItem).amount or 0
                            if item > 0 then
                                if xPlayer.PlayerData.job.name == job then
                                    TriggerClientEvent("aty_dispatch:client:locationDispatch", player, title, code, location, coords, blipSprite, sound, panic_effect)
                                end
                            end
                        end
                    else
                        local item = xPlayer.Functions.GetItemByName(Config.GPSItem) and xPlayer.Functions.GetItemByName(Config.GPSItem).amount or 0
                        if item > 0 then
                            if xPlayer.PlayerData.job.name == jobs then
                                TriggerClientEvent("aty_dispatch:client:locationDispatch", player, title, code, location, coords, blipSprite, sound, panic_effect)
                            end
                        end
                    end
                else
                    if type(jobs) == "table" then
                        for _, job in pairs(jobs) do
                            if xPlayer.PlayerData.job.name == job then
                                TriggerClientEvent("aty_dispatch:client:locationDispatch", player, title, code, location, coords, blipSprite, sound, panic_effect)
                            end
                        end
                    else
                        if xPlayer.PlayerData.job.name == jobs then
                            TriggerClientEvent("aty_dispatch:client:locationDispatch", player, title, code, location, coords, blipSprite, sound, panic_effect)
                        end
                    end
                end
            end
        else
            local xPlayer = Framework.GetPlayerFromId(player)

            if xPlayer ~= nil then
                if Config.Enable.UseGPS then
                    if type(jobs) == "table" then
                        for _, job in pairs(jobs) do
                            local item = xPlayer.getInventoryItem(Config.GPSItem) and xPlayer.getInventoryItem(Config.GPSItem).count or 0
                            if xPlayer.job.name == job and item > 0 then
                                TriggerClientEvent("aty_dispatch:client:locationDispatch", player, title, code, location, coords, blipSprite, sound, panic_effect)
                            end
                        end
                    else 
                        local item = xPlayer.getInventoryItem(Config.GPSItem) and xPlayer.getInventoryItem(Config.GPSItem).count or 0
                        if item > 0 then
                            if xPlayer.job.name == jobs then
                                TriggerClientEvent("aty_dispatch:client:locationDispatch", player, title, code, location, coords, blipSprite, sound, panic_effect)
                            end
                        end
                    end
                else
                    if type(jobs) == "table" then
                        for _, job in pairs(jobs) do
                            if xPlayer.job.name == job then
                                TriggerClientEvent("aty_dispatch:client:locationDispatch", player, title, code, location, coords, blipSprite, sound, panic_effect)
                            end
                        end
                    else
                        if xPlayer.job.name == jobs then
                            TriggerClientEvent("aty_dispatch:client:locationDispatch", player, title, code, location, coords, blipSprite, sound, panic_effect)
                        end
                    end
                end
            end
        end
    end
end)
