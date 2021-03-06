-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local localPeds = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEDLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local pedList = {
	{ -- Premium Store
		distance = 20,
		coords = { -1083.15,-245.88,37.76,209.77 },
		model = { 0x2F8845A3,"ig_barry" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Fishing Sell
		distance = 20,
		coords = { -1037.58,-1397.14,5.56,75.74 },
		model = { 0xD1FEB884,"a_m_y_beach_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Mercado Central-1
		distance = 30,
		coords = { 92.57,-1775.02,29.29,54.4 },
		model = { 0x47E4EEA0,"ig_andreas" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Mercado Central-2
		distance = 30,
		coords = { 94.16,-1773.23,29.29,55.17 },
		model = { 0x2799EFD8,"a_f_y_business_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Mercado Central-3
		distance = 30,
		coords = { 89.33,-1779.05,29.29,55.18 },
		model = { 0x2799EFD8,"a_f_y_business_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Recycling Sell
		distance = 15,
		coords = { -428.54,-1728.29,19.78,70.87 },
		model = { 0xEE75A00F,"s_m_y_garbage" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Entregador
		distance = 8,
		coords = { -428.83,-2788.45,6.54,226.78 },
		model = { 0x9FC37F22,"s_m_m_ups_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Lenhador
		distance = 30,
		coords = { -840.64,5398.94,34.61,303.31 },
		model = { 0x1536D95A,"a_m_o_ktown_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Ca??ador
		distance = 30,
		coords = { 636.51,2785.34,42.02,185.18 },
		model = { 0x98F9E770,"cs_old_man2" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Colheita
		distance = 30,
		coords = { 406.08,6526.17,27.75,87.88 },
		model = { 0x94562DD7,"a_m_m_farmer_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Motorista - Sul
		distance = 30,
		coords = { -73.3,-2004.73,18.28,355.31 },
		model = { 0x2A797197,"u_m_m_edtoh" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Lixeiro
		distance = 50,
		coords = { 84.25,-1552.12,29.6,54.71 },
		model = { 0xEE75A00F,"s_m_y_garbage" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Gangs
		distance = 50,
		coords = { 700.58,-303.63,59.25,13.44 },
		model = { 0x9D0087A8,"ig_claypain" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Check-in
		distance = 50,
		coords = { 308.25,-595.55,43.29,68.97 },
		model = { 0xD47303AC,"s_m_m_doctor_01" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Mechanic
		distance = 50,
		coords = { 485.89,-1296.03,29.6,266.74 },
		model = { 0xC4B715D2,"ig_benny" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	},
	{ -- Reds
		distance = 50,
		coords = { 416.41,-1902.86,25.62,42.75 },
		model = { 0x9D0087A8,"ig_claypain" },
		anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADPEDLIST
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for k,v in pairs(pedList) do
			local distance = #(coords - vector3(v["coords"][1],v["coords"][2],v["coords"][3]))
			if distance <= v["distance"] then
				if not IsPedInAnyVehicle(ped) then
					if localPeds[k] == nil then
						local mHash = GetHashKey(v["model"][2])

						RequestModel(mHash)
						while not HasModelLoaded(mHash) do
							Citizen.Wait(1)
						end

						localPeds[k] = CreatePed(4,v["model"][1],v["coords"][1],v["coords"][2],v["coords"][3] - 1,v["coords"][4],false,false)
						---SetEntityInvincible(localPeds[k],true)
						FreezeEntityPosition(localPeds[k],true)
						SetBlockingOfNonTemporaryEvents(localPeds[k],true)

						if v["anim"][1] ~= nil then
							RequestAnimDict(v["anim"][1])
							while not HasAnimDictLoaded(v["anim"][1]) do
								Citizen.Wait(1)
							end

							TaskPlayAnim(localPeds[k],v["anim"][1],v["anim"][2],8.0,0.0,-1,1,0,0,0,0)
						end
					end
				end
			else
				if localPeds[k] then
					DeleteEntity(localPeds[k])
					localPeds[k] = nil
				end
			end
		end

		Citizen.Wait(1000)
	end
end)