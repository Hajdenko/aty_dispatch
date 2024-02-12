ESX = exports["es_extended"]:getSharedObject()

Framework = Config.Framework == "esx" and exports['es_extended']:getSharedObject() or exports['qb-core']:GetCoreObject()
PlayerData = {}
blips = {}
PlayerJob = ""
latestDispatch = nil
WaitTimes = {
    Shooting = 0,
    Speeding = 0,
}

CreateThread(function()
    while true do
        if Config.Framework == "esx" then
            PlayerData = Framework.GetPlayerData()
            if table_size(PlayerData) > 6 then
                PlayerJob = PlayerData.job.name
            end
        else
            PlayerData = Framework.Functions.GetPlayerData()
            if table_size(PlayerData) > 6 then
                PlayerJob = PlayerData.job.name
            end
        end

        for key, time in pairs(WaitTimes) do
            if WaitTimes[key] > 0 then
                WaitTimes[key] = WaitTimes[key] - 1
            end
        end

        for i, blip in pairs(blips) do
            if blip[2] > 0 then
                blip[2] = blip[2] - 1
            elseif blip[2] == 0 then
                RemoveBlip(blip[1])
                table.remove(blips, i)
            end
        end

        Wait(1000)
    end
end)

CreateThread(function()
    while true do
        local sleep = 50
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local streetHash, roadHash = GetStreetNameAtCoord(table.unpack(coords))
        local location = {
            street = GetStreetNameFromHashKey(streetHash),
            road = GetStreetNameFromHashKey(roadHash)
        }
        local weaponHash = GetSelectedPedWeapon(ped)
        local weapon = Weapons[weaponHash]
        if weapon == nil or weapon == '?' then
            weapon = "ERROR"
        else
            weapon = tostring(weapon.label) or "ERROR"
        end

        local vehicle = GetVehiclePedIsIn(ped, 0)
        local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        local vehicleSpeed = GetEntitySpeed(vehicle)
        local gender

        if Config.Framework == "esx" then
            if PlayerData.sex == 1 then gender = "Female" else gender = "Male" end
        else
            if PlayerData.charinfo.gender == 1 then gender = "Female" else gender = "Male" end
        end

        if IsPedShooting(GetPlayerPed(-1)) then
            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), 0)

            if IsPedArmed(GetPlayerPed(-1), 7) and not IsWeaponBlackListed(GetPlayerPed(-1)) then
                if Config.Enable.UseSuppressorControl and IsWeaponHasSuppressor(GetPlayerPed(-1)) then
                    return
                end
                if not IsAnyPedShootingInArea(-427.8570, 4885.9829, 190.0370, -830.1350, 5292.0303, 81.4562) then
                    ShootingDispatch(location, coords, gender, weapon, vehicleName, vehicleSpeed, vehicle, {"police", "sheriff"})
                    end
                end
            end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 50
        local ped = GetPlayerPed(-1)

        --[[if Config.Enable.Shooting then
            if IsPedArmed(ped, 4) then
                sleep = 5
                
                if IsPedShooting(ped) and not IsWeaponBlackListed(ped) then

                    if Config.Enable.UseSuppressorControl and IsWeaponHasSuppressor(ped) then
                        return
                    end

                    for k, jobs in pairs(Config.WhitelistedJobs) do
                        if jobs == PlayerJob then
                            return
                        end
                    end
                                        
                    local coords = GetEntityCoords(ped)
                    local streetHash, roadHash = GetStreetNameAtCoord(table.unpack(coords))
                    local location = {
                        street = GetStreetNameFromHashKey(streetHash),
                        road = GetStreetNameFromHashKey(roadHash)
                    }
                    local weaponHash = GetSelectedPedWeapon(ped)
                    local weapon = Weapons[weaponHash].label
                    if weapon == nil or '?' then
                        weapon = "ERROR"
                    end
                    local vehicle = GetVehiclePedIsIn(ped, 0)
                    local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                    local vehicleSpeed = GetEntitySpeed(vehicle)
                    local gender

                    if Config.Framework == "esx" then
                        if PlayerData.sex == 1 then gender = "Female" else gender = "Male" end
                    else
                        if PlayerData.charinfo.gender == 1 then gender = "Female" else gender = "Male" end
                    end

                    ShootingDispatch(location, coords, gender, weapon, vehicleName, vehicleSpeed, vehicle, {"police", "sheriff"})
                    WaitTimes.Shooting = Config.WaitTimes.Shooting
                end
            end
        end--]]

        if IsPedTryingToEnterALockedVehicle(GetPlayerPed(-1)) or IsPedJacking(GetPlayerPed(-1)) then
            Wait(1750)
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                local vehicle = GetVehiclePedIsIn(ped, 0)
                local ped = GetPlayerPed(-1)
                local coords = GetEntityCoords(ped)
                local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                local playerName = GetPlayerName(PlayerId())
                -- TriggerServerEvent("aty_dispatch:server:printtheft")
                TriggerServerEvent("aty_dispatch:server:kradez", vehicle, coords, vehicleName, playerName, ped)

                SendDispatch("Car Thief!", "10-16", 227, {"police", "sheriff"})
            else
                local ped = GetPlayerPed(-1)
                local coords = GetEntityCoords(ped)
                local playerName = GetPlayerName(PlayerId())
                -- TriggerServerEvent("aty_dispatch:server:printtheft")
                TriggerServerEvent("aty_dispatch:server:pokud_kradez", nil, coords, "vozidlo", playerName, ped)

                SendDispatch("Someone tried to steal a car!", "10-16", 227, {"police", "sheriff"})
            end
            Wait(2000)
        end

        Wait(sleep)

        if Config.Enable.Speeding then
            local insideCity = exports["fivestar"]:IsInsideCity(ped)
            if IsPedInAnyVehicle(ped, 0) and not IsPedInAnyHeli(ped) and not IsPedInAnyPlane(ped) and not IsPedInAnyBoat(ped) and insideCity then
                local vehicle = GetVehiclePedIsIn(ped, 0)

                Wait(100)

                local speed = GetEntitySpeed(vehicle)
                if (speed * 3.6) >= 150 and WaitTimes.Speeding == 0 then
                    local sendDispatch = true
                    for k, jobs in pairs(Config.WhitelistedJobs) do
                        if jobs == PlayerJob then
                            sendDispatch = false
                            break
                        end
                    end

                    if sendDispatch == true then
                        SendDispatch("Speed Limit reached!", "10-66", 227, {"police", "sheriff"})
                    end
                    WaitTimes.Speeding = Config.WaitTimes.Speeding
                end
            end
        end

        Wait(2000)
    end
end)

AddEventHandler('gameEventTriggered', function(event, data)
    if event == "CEventNetworkEntityDamage" then
        local victim, attacker, victimDied, weapon = data[1], data[2], data[4], data[7]
        local plrData = ESX.GetPlayerData()
        src = source
        local playerName = ""
        if plrData ~= nil then
            playerName = plrData.firstName .. " " .. plrData.lastName
        end
        if playerName == nil then
            playerName = ''
        end
        if playerName == '**Invalid**' then
            playerName = ''
        end
        if not IsEntityAPed(victim) then return end
        if victimDied and NetworkGetPlayerIndexFromPed(victim) == PlayerId() and IsEntityDead(PlayerPedId()) then
            if not isDead then
                Wait(3000)
                
                for _, jobs in pairs(Config.WhitelistedJobs) do
                    if PlayerJob == 'police' or PlayerJob == 'sheriff' and PlayerJob ~= "ambulance" then
                        SendDispatch("Officer ".. playerName .." DOWN!", "10-100", 480, {"police", "sheriff", "ambulance"}, "panic.wav", true)
                        return
                    else
                        SendDispatch("Someone is in big danger!", "10-10B", 61, {"police", "sheriff", "ambulance"})
                        return
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("aty_dispatch:client:shootingDispatch", function(title, code, location, coords, gender, weapon, vehicleName, vehicleSpeed, vehicle, sound, panic_effect)
    local distance = GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId()), false)
    local paint, primaryId, secondaryId, primary, secondary

    if vehicle ~= 0 then
        plate = GetVehicleNumberPlateText(vehicle)
        primaryId, secondaryId = GetVehicleColours(vehicle)
        primary = Colours[tostring(primaryId)]
        secondary = Colours[tostring(secondaryId)]
    end
    
    if vehicleName == "CARNOTFOUND" then
        vehicleName = nil
        plate = nil
    end

    table.insert(blips, {createBlip(coords.x, coords.y, coords.z, 110, 1, title, 1.0, code), Config.BlipRemoveTime})

    latestDispatch = coords

    SendNUIMessage({
        action = "dispatch",
        title = title,
        code = code,
        location = location,
        distance = distance,
        gender = gender,
        vehicle = vehicleName,
        speed = vehicleSpeed,
        plate = plate,
        primary = primary,
        secondary = secondary,
        weapon = weapon,
        sound = sound, 
        panic_effect = panic_effect
    })
end)

RegisterNetEvent("aty_dispatch:client:customDispatch", function(title, code, location, coords, gender, vehicleName, vehicleSpeed, vehicle, weapon, blipSprite, sound, panic_effect)
    local distance = GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId()), false)
    local vehicleSpeed = GetEntitySpeed(vehicle)
    local paint, primaryId, secondaryId, primary, secondary

    if vehicle ~= 0 then
        plate = GetVehicleNumberPlateText(vehicle)
        primaryId, secondaryId = GetVehicleColours(vehicle)
        primary = Colours[tostring(primaryId)]
        secondary = Colours[tostring(secondaryId)]
    end
    
    if vehicleName == "CARNOTFOUND" then
        vehicleName = nil
        plate = nil
    end

    table.insert(blips, {createBlip(coords.x, coords.y, coords.z, blipSprite, 1, title, 1.0, code), Config.BlipRemoveTime})

    latestDispatch = coords

    SendNUIMessage({
        action = "dispatch",
        title = title,
        code = code,
        location = location,
        distance = distance,
        gender = gender,
        vehicle = vehicleName,
        speed = vehicleSpeed,
        plate = plate,
        primary = primary,
        secondary = secondary,
        weapon = weapon,
        sound = sound,
        panic_effect = panic_effect
    })
end)

RegisterNetEvent("aty_dispatch:client:locationDispatch", function(title, code, location, coords, blipSprite, sound, panic_effect)
    local distance = GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId()), false)
    table.insert(blips, {createBlip(coords.x, coords.y, coords.z, blipSprite, 1, title, 1.0, code), Config.BlipRemoveTime})

    latestDispatch = coords

    SendNUIMessage({
        action = "dispatch",
        title = title,
        code = code,
        location = location,
        distance = distance,
        sound = sound,
        panic_effect = panic_effect
    })
end)

RegisterNUICallback("close", function()
    SetNuiFocus(0, 0)
end)

RegisterCommand('respondDispatch', function()
	if latestDispatch then 
		SetWaypointOff() 
		SetNewWaypoint(latestDispatch.x, latestDispatch.y)
        Config.Notification("GPS", "GPS Nastavena.", "success", 5000)
        latestDispatch = nil
	end
end)

RegisterKeyMapping('respondDispatch', 'Respondovat na nejnovější dispatch', 'keyboard', Config.SetWaypoingKey)

local Explosions = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72}

AddEventHandler("explosionEvent", function(sender, ev)
    for _, v in ipairs(Explosions) do
      if ev.explosionType == v then
        SendDispatch("Explosion!", "Signal 8", 227, {"police", "sheriff"}, "beep.mp3", true)
        return
      end
    end
  end
)
