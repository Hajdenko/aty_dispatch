function ShootingDispatch(location, coords, gender, weapon, vehicleName, vehicleSpeed, vehicle, jobs)
    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
        TriggerServerEvent("aty_dispatch:server:shootingDispatch", "Drive By in Progress", "10-13", location, coords, gender, weapon, vehicleName, vehicleSpeed, vehicle, jobs)
    else
        TriggerServerEvent("aty_dispatch:server:shootingDispatch", "Shooting in Progress", "10-13", location, coords, gender, weapon, vehicleName, vehicleSpeed, vehicle, jobs)
    end
end

function SendDispatch(title, code, blipSprite, jobs, sound, panic_effect)
    panic_effect = panic_effect or false
    sound = sound or "beep.mp3"
    
    local title = title or "Placeholder"
    local code = code or "10-11"
    local blipSprite = blipSprite or 1
    local ped = PlayerPedId()

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

    TriggerServerEvent("aty_dispatch:server:customDispatch", title, code, location, coords, gender, vehicleName, vehicleSpeed, vehicle, weapon, blipSprite, jobs, sound, panic_effect)
end

function LocSendDispatch(title, code, blipSprite, jobs, sound, panic_effect)
    panic_effect = panic_effect or false
    sound = sound or "beep.mp3"
    
    local title = title or "Placeholder"
    local code = code or "10-11"
    local blipSprite = blipSprite or 1
    local ped = PlayerPedId()

    local coords = GetEntityCoords(ped)
    local streetHash, roadHash = GetStreetNameAtCoord(table.unpack(coords))
    local location = {
        street = GetStreetNameFromHashKey(streetHash),
        road = GetStreetNameFromHashKey(roadHash)
    }

    TriggerServerEvent("aty_dispatch:server:locationDispatch", title, code, location, coords, blipSprite, jobs, sound, panic_effect)
end

RegisterNetEvent("aty_dispatch:SendDispatch", function(title, code, blipSprite, jobs)
    local title = title or "Placeholder"
    local code = code or "10-11"
    local blipSprite = blipSprite or 1
    local ped = PlayerPedId()

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
    local gender

    if Config.Framework == "esx" then
        if PlayerData.sex == 1 then gender = "Female" else gender = "Male" end
    else
        if PlayerData.charinfo.gender == 1 then gender = "Female" else gender = "Male" end
    end

    TriggerServerEvent("aty_dispatch:server:customDispatch", title, code, location, coords, gender, vehicleName, vehicleSpeed, vehicle, weapon, blipSprite, jobs)
end)

function createBlip(x, y, z, sprite, color, text, size, code)
    local size = size or 1.0
    local blip = AddBlipForCoord(x, y, z)
    local code = code or "10-11"
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 6)
    SetBlipScale(blip, size)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(code .." - ".. text)
    EndTextCommandSetBlipName(blip)

    return blip
end

function IsWeaponBlackListed(ped)
	for i, weapon in pairs(Config.BlackListedWeapons) do
		local weaponHash = GetHashKey(Config.BlackListedWeapons[i])

		if GetSelectedPedWeapon(ped) == weaponHash then
			return true 
		end
	end

    Wait(10)

	return false
end


function IsWeaponHasSuppressor(ped)
    for _, hash in pairs(Config.Suppressors) do
        print(HasPedGotWeaponComponent(ped, GetSelectedPedWeapon(ped), hash))
        if HasPedGotWeaponComponent(ped, GetSelectedPedWeapon(ped), hash) then
            return true
        end
    end

    Wait(10)

    return false
end

function table_size(tbl)
	local size = 0

	for k, v in pairs(tbl) do
		size = size + 1
	end

	return size
end
