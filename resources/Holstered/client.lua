local armas = {
	"WEAPON_KNIFE",
	"WEAPON_HATCHET",
	"WEAPON_PISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_PISTOL50",
	"WEAPON_REVOLVER",
	"WEAPON_COMBATPISTOL",
	"WEAPON_FLASHLIGHT",
	"WEAPON_NIGHTSTICK",
	"WEAPON_STUNGUN",
	"WEAPON_COMPACTRIFLE",
	"WEAPON_APPISTOL",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_MICROSMG",
	"WEAPON_MINISMG",
	"WEAPON_SNSPISTOL",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_SPECIALCARBINE_MK2",
	"WEAPON_CARBINERIFLE",
	"WEAPON_CARBINERIFLE_MK2",
	"WEAPON_SMG",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_ASSAULTRIFLE_MK2",
	"WEAPON_ASSAULTSMG",
	"WEAPON_GUSENBERG"
}
 
 Citizen.CreateThread(function()
  while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(PlayerPedId(), true) then
				loadAnimDict( "reaction@intimidation@1h" )
				if CheckWeapon(ped) then
						if holstered then
								TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 8.0, 1.0, -1, 48, 0, 0, 0, 0 )
								Citizen.Wait(1700)
								ClearPedTasks(ped)
								holstered = false
						end
						SetPedComponentVariation(ped, 0, 0, 0, 0)
				elseif not CheckWeapon(ped) then
						if not holstered then
								TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 1.0, -1, 48, 0, 0, 0, 0 )
								Citizen.Wait(1500)
								ClearPedTasks(ped)
								holstered = true
						end
						SetPedComponentVariation(ped, 0, 0, 0, 0)
				end
		end
end
end)


function CheckWeapon(ped)
	for i = 1, #armas do
		if GetHashKey(armas[i]) == GetSelectedPedWeapon(ped) then
			return true
		end
	end
	return false
end
function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end