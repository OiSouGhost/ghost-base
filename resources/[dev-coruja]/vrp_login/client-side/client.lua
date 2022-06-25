-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local cam = nil
local new = false
local weight = 270.0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
local config = {
	["praca"] = { 205.86,-917.3,214.44 },
	["aeroporto"] = { -1038.01,-2737.0,13.78 },
	["sandy"] = { 316.08,2627.61,44.48 },
	["paleto"] = { -769.39,5594.83,33.49 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_login:Spawn")
AddEventHandler("vrp_login:Spawn",function(status)
	local ped = PlayerPedId()
	if status then
		local x,y,z = table.unpack(GetEntityCoords(ped))

		cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA",x,y,z+200.0,270.00,0.0,0.0,80.0,0,0)
		SetCamActive(cam,true)

		RenderScriptCams(true,false,1,true,true)

		SetNuiFocus(true,true)
		SendNUIMessage({ display = true })
	else
		--SetEntityVisible(ped,true,false)
		FreezeEntityPosition(ped,false)
		---SetEntityInvincible(ped,false)

		RenderScriptCams(false,false,0,true,true)
		SetCamActive(cam,false)
		DestroyCam(cam,true)
		cam = nil
	end

	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEHOMES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_login:updateHomes")
AddEventHandler("vrp_login:updateHomes",function(status)
	for k,v in pairs(status) do
		config[k] = v
		config[k][4] = GetStreetNameFromHashKey(GetStreetNameAtCoord(config[k][1],config[k][2],config[k][3]))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("spawn",function(data,cb)
	local ped = PlayerPedId()
	if data.choice == "spawn" then
		SetNuiFocus(false)
		SendNUIMessage({ display = false })

		DoScreenFadeOut(1000)
		Citizen.Wait(1000)

		--SetEntityVisible(ped,true,false)
		FreezeEntityPosition(ped,false)
		---SetEntityInvincible(ped,false)

		RenderScriptCams(false,false,0,true,true)
		SetCamActive(cam,false)
		DestroyCam(cam,true)
		cam = nil

		Citizen.Wait(1000)
		DoScreenFadeIn(1000)
	else
    	new = false
		local speed = 0.7

		DoScreenFadeOut(500)
		Citizen.Wait(500)

		SetCamRot(cam,270.0)
		SetCamActive(cam,true)
		new = true
		weight = 270.0

		DoScreenFadeIn(500)

		SetEntityCoords(ped,config[data.choice][1],config[data.choice][2],config[data.choice][3]+0.5)
		local x,y,z = table.unpack(GetEntityCoords(ped))

		SetCamCoord(cam,x,y,z+200.0)
		local i = z + 200.0

		while i > config[data.choice][3] + 1.5 do
			Citizen.Wait(5)
			i = i - speed
			SetCamCoord(cam,x,y,i)

			if i <= config[data.choice][3] + 35.0 and weight < 360.0 then
				if speed - 0.0078 >= 0.05 then
					speed = speed - 0.0078
				end

				weight = weight + 0.75
				SetCamRot(cam,weight)
			end

			if not new then
				break
			end
		end
	end

	cb("ok")
end)