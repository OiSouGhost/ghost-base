-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_driversul",cRP)
vSERVER = Tunnel.getInterface("vrp_driversul")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local blip = nil
local inService = false
local startX = -73.3
local startY = -2004.73
local startZ = 18.28
local driverPosition = 1
local timeSeconds = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- COORDS
-----------------------------------------------------------------------------------------------------------------------------------------
local coords = {
	[1] = { 501.25,-732.89,24.13 }, --
	[2] = { 455.34,-950.57,27.66 }, --
	[3] = { 346.19,-1127.35,28.66 }, --
	[4] = { 284.92,-899.14,28.26 }, --
	[5] = { 273.96,-586.31,42.53 }, --
	[6] = { 565.79,-368.39,42.81 }, --
	[7] = { 897.68,-334.01,63.77 }, --
	[8] = { 1027.55,-428.96,64.68 }, --
	[9] = { 972.98,-663.0,56.71 }, --
	[10] = { 1206.07,-711.43,58.94 }, --
	[11] = { 1217.42,-305.13,68.36 }, --
	[12] = { 856.67,-84.87,79.37 }, --
	[13] = { 424.96,127.92,100.0 }, --
	[14] = { -446.17,254.58,82.3 }, --
	[15] = { -608.18,5.49,41.76 }, --
	[16] = { -919.05,-33.23,40.16 }, --
	[17] = { -1301.81,230.47,58.23 }, --
	[18] = { -1271.35,-84.34,44.59 }, --
	[19] = { -766.09,-342.49,35.46 }, --
	[20] = { -652.9,-605.54,32.67 }, --
	[21] = { -778.84,-1078.95,10.19 }, --
	[22] = { -1026.08,-790.34,16.78 }, --
	[23] = { -1162.43,-820.37,13.71 }, --
	[24] = { -1072.36,-1012.74,1.45 }, --
	[25] = { -999.39,-1235.58,4.88 }, --
	[26] = { -1172.27,-1463.58,3.7 }, --
	[27] = { -1003.16,-1587.33,4.41 }, --
	[28] = { -838.53,-1171.13,5.7 }, --
	[29] = { -657.36,-1384.44,9.89 }, --
	[30] = { -312.94,-1842.8,24.01 }, --
	[31] = { -8.45,-1709.37,28.55 }, --
	[32] = { 484.69,-1446.44,28.59 }, --
	[33] = { 1151.28,-1445.46,33.99 }, --
	[34] = { 1181.06,-1049.71,41.94 }, --
	[35] = { 777.22,-842.66,42.65 }, -- 
	[36] = { 324.91,-784.88,28.61 } --
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.toggleService()
	local ped = PlayerPedId()

	if not inService then
		startthreadservice()
		startthreadtimeseconds()
		inService = true
		makeBlipsPosition()
		TriggerEvent("Notify","sucesso","Você iniciou o emprego de <b>Motorista</b>.",5000)
	else
		inService = false
		TriggerEvent("Notify","sucesso","Você terminou o emprego de <b>Motorista</b>.",5000)
		if DoesBlipExist(blip) then
			RemoveBlip(blip)
			blip = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function startthreadservice()
	Citizen.CreateThread(function()
		while true do
			local timeDistance = 500
			if inService then
				local ped = PlayerPedId()
				if IsPedInAnyVehicle(ped) then
					local veh = GetVehiclePedIsUsing(ped)
					local coordsPed = GetEntityCoords(ped)
					local distance = #(coordsPed - vector3(coords[driverPosition][1],coords[driverPosition][2],coords[driverPosition][3]))
					if distance <= 300 and IsVehicleModel(veh,GetHashKey("bus")) then
						timeDistance = 4
						DrawMarker(21,coords[driverPosition][1],coords[driverPosition][2],coords[driverPosition][3]+0.60,0,0,0,0,180.0,130.0,2.0,2.0,1.0,121,206,121,100,1,0,0,1)
						if distance <= 15 then
							local speed = GetEntitySpeed(veh) * 2.236936
							if IsControlJustPressed(1,38) and speed <= 40 and timeSeconds <= 0 then
								timeSeconds = 2
								if driverPosition == #coords then
									driverPosition = 1
									vSERVER.paymentMethod(true)
								else
									driverPosition = driverPosition + 1
									vSERVER.paymentMethod(false)
								end
								makeBlipsPosition()
							end
						end
					end
				end
			end
			Citizen.Wait(timeDistance)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMESECONDS
-----------------------------------------------------------------------------------------------------------------------------------------
function startthreadtimeseconds()
	Citizen.CreateThread(function()
		while true do
			if timeSeconds > 0 then
				timeSeconds = timeSeconds - 1
			end
			Citizen.Wait(1000)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPSPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function makeBlipsPosition()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
		blip = nil
	end

	if not DoesBlipExist(blip) then
		blip = AddBlipForRadius(coords[driverPosition][1],coords[driverPosition][2],coords[driverPosition][3],50.0)
		SetBlipHighDetail(blip,true)
		SetBlipColour(blip,69)
		SetBlipAlpha(blip,150)
		SetBlipAsShortRange(blip,true)
	end
end