local can, vehicle, speed, anim, playing = false, false, false, true

local dict = 'rcmextreme2atv'

RegisterKeyMapping('stunt', 'Stunt', 'keyboard', 'J')

local tricks = {
	'idle_a',
	'idle_b',
	'idle_c',
	'idle_d',
	'idle_e'
}

Citizen.CreateThread(function()
    while true do
	    local sleep = 1000
		if IsPedInAnyVehicle(PlayerPedId()) then
			if not vehicle then
				for k, v in pairs(Config.Bikes) do
					if GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId()))) == v then
						vehicle = true
						break
					end
				end
			else
				sleep = 5
				local bike = GetVehiclePedIsIn(PlayerPedId())

				if Config.KMH then
				    speed = GetEntitySpeed(bike) * 3.6

					if speed >= Config.KMHspeed then
						can = true
					else
						can = false
					end
				else
					speed = GetEntitySpeed(bike) * 2.236936

					if speed >= Config.MPHspeed then
						can = true
					else
						can = false
					end
				end
			end
		else
			can = false
			vehicle = false
		end

		Citizen.Wait(sleep)
    end
end)

hasAnimation = function()
    if not IsEntityPlayingAnim(PlayerPedId(), dict, anim, 3) then
		return true
	end
end


doTrick = function()
	if hasAnimation() then
		local random = math.random(1, 5)
		anim = tricks[random]

		while not HasAnimDictLoaded(dict) do 
			Wait(0)
			RequestAnimDict(dict)
		end

		TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	else
		ClearPedTasks(PlayerPedId())
	end
end

RegisterCommand('stunt', function()
	if can then
	    doTrick()
	end
end)
