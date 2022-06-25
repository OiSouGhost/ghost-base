--[[
    #####################################################################
    #                _____           __          _                      #
    #               |  __ \         / _|        | |                     #
    #               | |__) | __ ___| |_ ___  ___| |__                   #
    #               |  ___/ '__/ _ \  _/ _ \/ __| '_ \                  #
    #               | |   | | |  __/ ||  __/ (__| | | |                 #
    #               |_|   |_|  \___|_| \___|\___|_| |_|                 #
    #                                                                   #
    #                 JD_logs By Prefech 01-11-2021                     #
    #                         www.prefech.com                           #
    #                                                                   #
    #####################################################################
]]

local JD_Debug = false -- Enable when you have issues or when asked by Prefech Staff
local configFile = LoadResourceFile(GetCurrentResourceName(), "./config/config.json")
local cfgFile = json.decode(configFile)

local localsFile = LoadResourceFile(GetCurrentResourceName(), "locals/"..cfgFile['locals']..".json")
local lang = json.decode(localsFile)

RegisterNetEvent('Prefech:JD_logs:Debug')
AddEventHandler('Prefech:JD_logs:Debug', log)

RegisterNetEvent('Prefech:JD_logs:errorLog')
AddEventHandler('Prefech:JD_logs:errorLog', errorLog)

function debugLog(x)
	if JD_Debug then
		print("^5[JD_logs]^0 " .. x)
	end
end

function errorLog(x)
	print("^5[JD_logs]^1 " .. x .."^0")
end

RegisterNetEvent("Prefech:discordLogs")
AddEventHandler("Prefech:discordLogs", function(message, color, channel)
    discordLog(message, color, channel)
end)

RegisterNetEvent("Prefech:ClientUploadScreenshot")
AddEventHandler("Prefech:ClientUploadScreenshot", function(args)
	ServerFunc.CreateLog(args)
end)

exports('discord', function(msg, player_1, player_2, color, channel)
	args ={
		['EmbedMessage'] = msg,
		['color'] = color,
		['channel'] = channel
	}
	if player_1 ~= 0 then
		args['player_id'] = player_1
	end
	if player_2 ~= 0 then
		args['player_2_id'] = player_2
	end
	ServerFunc.CreateLog(args)
	local resource = GetInvokingResource()
	debugLog('Server Old Export from '.. resource)
end)

exports('createLog', function(args)
	if args.screenshot then
		if GetResourceState('screenshot-basic') == "started" then
			local webhooksLaodFile = LoadResourceFile(GetCurrentResourceName(), "./config/webhooks.json")
			local webhooksFile = json.decode(webhooksLaodFile)
			args['url'] = webhooksFile['imageStore'].webhook
			TriggerClientEvent('Prefech:ClientCreateScreenshot', args.player_id, args)
		else
			errorLog('You need to have screenshot-basic to use screenshot logs.')
		end
	else
		ServerFunc.CreateLog(args)
	end
	local resource = GetInvokingResource()
	debugLog('Server New Export from: '..resource)
end)

AddEventHandler("playerConnecting", function(name, setReason, deferrals)
	local ids = ExtractIdentifiers(source)
	local globalBansLoadFile = LoadResourceFile(GetCurrentResourceName(), "./json/bans.json")
	local globalBansFile = json.decode(globalBansLoadFile)	
	if cfgFile['PrefechGlobalBans'] then
		bypass = false
		for k,v in pairs(cfgFile['GlobalBanBypass']) do
			if has_val(ids, v) then
				bypass = true
			end
		end
		if not bypass then
			for k,v in pairs(globalBansFile) do
				for a,b in pairs(ids) do
					if has_val(v.Identifiers, b) then
						if not v.Lifted then
							setReason('\nPrefech | Global Banned.\nReason: '..v.BanReason..'\nUUID: '..k..'\nTo appeal this ban please join our discord: https://discord.gg/prefech')
							CancelEvent()
							return ServerFunc.CreateLog({ description = lang['DefaultLogs'].GlobalBan:format(GetPlayerName(source), k, v.BanReason), isBanned = true, channel = 'system'})
						end
					end
				end
			end
		end
	end	
	ServerFunc.CreateLog({EmbedMessage = lang['DefaultLogs'].Join:format(GetPlayerName(source)), player_id = source, channel = 'joins'})
end)

AddEventHandler("playerJoining", function(source, oldID)
	local loadFile = LoadResourceFile(GetCurrentResourceName(), "./json/names.json")
	local loadedFile = json.decode(loadFile)
    local ids = ExtractIdentifiers(source)

	if ids.steam then
		if loadedFile[ids.steam] ~= nil then 
			if loadedFile[ids.steam] ~= GetPlayerName(source) then 
				for _, i in ipairs(GetPlayers()) do
					if IsPlayerAceAllowed(i, cfgFile.nameChangePerms) then 
						TriggerClientEvent('chat:addMessage', i, {
							template = '<div style="background-color: rgba(90, 90, 90, 0.9); text-align: center; border-radius: 0.5vh; padding: 0.7vh; font-size: 1.7vh;"><b>Player ^1{0} ^0{1} ^1{2}</b></div>',
							args = { lang['DefaultLogs'].NameChangeChat:format(GetPlayerName(source), loadedFile[ids.steam]) }
						})
					end
				end
				ServerFunc.CreateLog({EmbedMessage = lang['DefaultLogs'].NameChange, player_id = source, channel = 'nameChange'})
			end
		end
		loadedFile[ids.steam] = GetPlayerName(source)
		SaveResourceFile(GetCurrentResourceName(), "./json/names.json", json.encode(loadedFile), -1)
	else
		if cfgFile.forceSteam then
			ServerFunc.CreateLog({EmbedMessage = lang['Other'].ForceSteamLog, player_id = source, channel = 'nameChange'})
			DropPlayer(source, lang['Other'].ForceSteam)
		else
			for _, i in ipairs(GetPlayers()) do
				if IsPlayerAceAllowed(i, cfgFile.nameChangePerms) then 
					TriggerClientEvent('chat:addMessage', i, {
						template = '<div style="background-color: rgba(90, 90, 90, 0.9); text-align: center; border-radius: 0.5vh; padding: 0.7vh; font-size: 1.7vh;"><b>Player ^1{0} ^0{1}</b></div>',
						args = { GetPlayerName(source), lang['Other'].NoSteam }
					})
				end
			end
			ServerFunc.CreateLog({EmbedMessage = lang['Other'].NoSteamLog:format(GetPlayerName(source)), player_id = source, channel = 'nameChange'})
		end
	end

	if IsPlayerAceAllowed(source, cfgFile['logHistoryPerms']) then
		TriggerClientEvent("chat:addSuggestion", source, "/logs", "See the recent 5 logs of a player.", {
			{ name="id", help="The id of the player." }
		});
	end
	
	if IsPlayerAceAllowed(source, cfgFile['screenshotPerms']) then
		TriggerClientEvent("chat:addSuggestion", source, "/screenshot", "Screenshot the clients game.", {
			{ name="id", help="The id of the player." }
		});
	end

end)

AddEventHandler('playerDropped', function(reason)
	ServerFunc.CreateLog({EmbedMessage = lang['DefaultLogs'].Left:format(GetPlayerName(source), reason), player_id = source, channel = 'leaving'})
end)

AddEventHandler('chatMessage', function(source, name, msg)
	ServerFunc.CreateLog({EmbedMessage = '**'..GetPlayerName(source) .. '**: `' .. msg..'`', player_id = source, channel = 'chat'})
end)

RegisterServerEvent('Prefech:playerDied')
AddEventHandler('Prefech:playerDied',function(args)
	if args.weapon == nil then _Weapon = "" else _Weapon = ""..args.weapon.."" end
	if args.type == 1 then  -- Suicide/died
		ServerFunc.CreateLog({
			EmbedMessage = '**'..GetPlayerName(source) .. '** `'..args.death_reason..'` '.._Weapon, 
			player_id = source,
			channel = 'deaths'
		})
	elseif args.type == 2 then -- Killed by other player
		ServerFunc.CreateLog({
			EmbedMessage = '**' .. GetPlayerName(args.player_2_id) .. '** '..args.death_reason..' **' .. GetPlayerName(source).. '** `('.._Weapon..')`', 
			player_id = source,
			player_2_id = args.player_2_id,
			channel = 'deaths'
		})
	else -- When gets killed by something else
		ServerFunc.CreateLog({
			EmbedMessage = '**'..GetPlayerName(source) .. '** `'..args.death_reason..'` '.._Weapon, 
			player_id = source,
			channel = 'deaths'
		})
	end
end)

RegisterServerEvent('Prefech:playerShotWeapon')
AddEventHandler('Prefech:playerShotWeapon', function(weapon)
	if cfgFile['weaponLog'] then
		ServerFunc.CreateLog({EmbedMessage = lang['DefaultLogs'].Shooting:format(GetPlayerName(source), weapon), player_id = source, channel = 'shooting'})
    end
end)

local explosionTypes = {'GRENADE', 'GRENADELAUNCHER', 'STICKYBOMB', 'MOLOTOV', 'ROCKET', 'TANKSHELL', 'HI_OCTANE', 'CAR', 'PLANE', 'PETROL_PUMP', 'BIKE', 'DIR_STEAM', 'DIR_FLAME', 'DIR_WATER_HYDRANT', 'DIR_GAS_CANISTER', 'BOAT', 'SHIP_DESTROY', 'TRUCK', 'BULLET', 'SMOKEGRENADELAUNCHER', 'SMOKEGRENADE', 'BZGAS', 'FLARE', 'GAS_CANISTER', 'EXTINGUISHER', 'PROGRAMMABLEAR', 'TRAIN', 'BARREL', 'PROPANE', 'BLIMP', 'DIR_FLAME_EXPLODE', 'TANKER', 'PLANE_ROCKET', 'VEHICLE_BULLET', 'GAS_TANK', 'BIRD_CRAP', 'RAILGUN', 'BLIMP2', 'FIREWORK', 'SNOWBALL', 'PROXMINE', 'VALKYRIE_CANNON', 'AIR_DEFENCE', 'PIPEBOMB', 'VEHICLEMINE', 'EXPLOSIVEAMMO', 'APCSHELL', 'BOMB_CLUSTER', 'BOMB_GAS', 'BOMB_INCENDIARY', 'BOMB_STANDARD', 'TORPEDO', 'TORPEDO_UNDERWATER', 'BOMBUSHKA_CANNON', 'BOMB_CLUSTER_SECONDARY', 'HUNTER_BARRAGE', 'HUNTER_CANNON', 'ROGUE_CANNON', 'MINE_UNDERWATER', 'ORBITAL_CANNON', 'BOMB_STANDARD_WIDE', 'EXPLOSIVEAMMO_SHOTGUN', 'OPPRESSOR2_CANNON', 'MORTAR_KINETIC', 'VEHICLEMINE_KINETIC', 'VEHICLEMINE_EMP', 'VEHICLEMINE_SPIKE', 'VEHICLEMINE_SLICK', 'VEHICLEMINE_TAR', 'SCRIPT_DRONE', 'RAYGUN', 'BURIEDMINE', 'SCRIPT_MISSIL'}
AddEventHandler('explosionEvent', function(source, ev)
    if ev.explosionType < -1 or ev.explosionType > 77 then
        ev.explosionType = 'UNKNOWN'
    else
        ev.explosionType = explosionTypes[ev.explosionType + 1]
    end
    ServerFunc.CreateLog({EmbedMessage = lang['DefaultLogs'].Explosion:format(GetPlayerName(source), ev.explosionType), player_id = source, channel = 'explosion'})
end)

RegisterServerEvent('Prefech:ClientDiscord')
AddEventHandler('Prefech:ClientDiscord', function(args)
	if args.screenshot then
		if GetResourceState('screenshot-basic') == "started" then
			local webhooksLaodFile = LoadResourceFile(GetCurrentResourceName(), "./config/webhooks.json")
			local webhooksFile = json.decode(webhooksLaodFile)
			args['url'] = webhooksFile['imageStore'].webhook
			TriggerClientEvent('Prefech:ClientCreateScreenshot', args.player_id, args)
		else
			errorLog('You need to have screenshot-basic to use screenshot logs.')
		end
	else
		ServerFunc.CreateLog(args)
	end
end)

AddEventHandler('onResourceStop', function (resourceName)
	ServerFunc.CreateLog({EmbedMessage = lang['DefaultLogs'].ResourceStop:format(resourceName), channel = 'resources'})
end)

AddEventHandler('onResourceStart', function (resourceName)
    Citizen.Wait(100)
	ServerFunc.CreateLog({EmbedMessage = lang['DefaultLogs'].ResourceStart:format(resourceName), channel = 'resources'})
end)  

local storage = nil
RegisterNetEvent('Prefech:sendClientLogStorage')
AddEventHandler('Prefech:sendClientLogStorage', function(_storage)
	storage = _storage
end)

Commands= {}

Commands.LogHistoryCommand = function(source, args, RawCommand)
	if GetResourceState('Prefech_Notify') == "started" then
		if IsPlayerAceAllowed(source, cfgFile.logHistoryPerms) then
			if tonumber(args[1]) then
				TriggerClientEvent('Prefech:getClientLogStorage', args[1])
				Citizen.Wait(500)
				if tablelength(storage) == 0 then
					exports.Prefech_Notify:Notify({
						title = "Recent logs for: "..GetPlayerName(args[1]).." (0)",
						message = lang['Commands']['LogHistory'].NoLogs,
						color = "#93CAED",
						target = source,
						timeout = 15
					})
				else
					for k,v in pairs(storage) do
						exports.Prefech_Notify:Notify({
							title = lang['Commands']['LogHistory'].Success:format(GetPlayerName(args[1]), k),
							message = "Channel: "..v.Channel.."\nMessage: "..v.Message:gsub("**",""):gsub("`","").."\nTimeStamp: "..v.TimeStamp,
							color = "#93CAED",
							target = source,
							timeout = 15
						})
					end
				end
			else
				exports.Prefech_Notify:Notify({
					title = "Error!",
					message = lang['Commands']['LogHistory'].InvalidId,
					color = "#93CAED",
					target = source,
					timeout = 15
				})
			end
		else
			exports.Prefech_Notify:Notify({
				title = "Error!",
				message = lang['Commands']['LogHistory'].InvalidPerms,
				color = "#93CAED",
				target = source,
				timeout = 15
			})
		end
	else
		errorLog('Prefech_Notify is not installed.')
	end
end

Commands.ScreenshotCommand = function(source, args, RawCommand)
	if GetResourceState('Prefech_Notify') == "started" then
		if IsPlayerAceAllowed(source, cfgFile.screenshotPerms) then
			if args[1] and has_val(GetPlayers(), args[1]) then
				if GetResourceState('screenshot-basic') == "started" then
					local webhooksLaodFile = LoadResourceFile(GetCurrentResourceName(), "./config/webhooks.json")
					local webhooksFile = json.decode(webhooksLaodFile)
					args['url'] = webhooksFile['imageStore'].webhook
					args['EmbedMessage'] = lang['Commands']['Screenshot'].Log:format(GetPlayerName(args[1]), args[1], GetPlayerName(source), source)
					args['channel'] = "screenshot"
					TriggerClientEvent('Prefech:ClientCreateScreenshot', args[1], args)
					exports.Prefech_Notify:Notify({
						title = "Success!",
						message = lang['Commands']['Screenshot'].Success:format(GetPlayerName(args[1])),
						color = "#93CAED",
						target = source,
						timeout = 15
					})
				else
					errorLog('You need to have screenshot-basic to use screenshot logs.')
				end
			else
				exports.Prefech_Notify:Notify({
					title = "Error!",
					message = lang['Commands']['Screenshot'].InvalidId,
					color = "#93CAED",
					target = source,
					timeout = 15
				})

			end
		else
			exports.Prefech_Notify:Notify({
				title = "Error!",
				message = lang['Commands']['Screenshot'].InvalidPerms,
				color = "#93CAED",
				target = source,
				timeout = 15
			})
		end
	else
		errorLog('Prefech_Notify is not installed.')
	end
end

for k,v in pairs(cfgFile['Commands']) do
	RegisterCommand(k, Commands[v])
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

function has_val(tab, val)
	for k,v in pairs(tab) do
	   if v == val then
		return true
	   end
	end
	return false
end

local eventsLoadFile = LoadResourceFile(GetCurrentResourceName(), "./config/eventLogs.json")
local eventsFile = json.decode(eventsLoadFile)
if type(eventsFile) == "table" then
	for k,v in pairs(eventsFile) do
		if v.Server then
			debugLog('Added Server Event Log: '..v.Event)
			AddEventHandler(v.Event, function()
				ServerFunc.CreateLog({EmbedMessage = '**EventLogger:** '..v.Message, channel = v.Channel})
			end)
		end
	end
end

RegisterServerEvent('Prefech:eventLoggerClient')
AddEventHandler('Prefech:eventLoggerClient', function(args)
	ServerFunc.CreateLog(args)
end)

if GetCurrentResourceName() ~= "JD_logs" then
    errorLog('This recource should be named "JD_logs" for the exports to work properly.')
end

function SyncBans()
	PerformHttpRequest('https://prefech.com/jd_logs/globalbans.json', function(code, res, headers)
		if code == 200 then
			SaveResourceFile(GetCurrentResourceName(), "./json/bans.json", res, res.length)
			debugLog('Bans synced')
		else
			errorLog('JD_logs unable to sync global bans')
		end
	end, 'GET')
end

Citizen.CreateThread(function()
	SyncBans()
	while true do
		Citizen.Wait(15 * 60 * 1000)
		SyncBans()
	end
end)

RegisterNetEvent('Prefech:DropPlayer')
AddEventHandler('Prefech:DropPlayer', function(reason)
	local configFile = LoadResourceFile(GetCurrentResourceName(), "./config/config.json")
	local cfgFile = json.decode(configFile)
	if not IsPlayerAceAllowed(source, cfgFile['AntiCheatBypass']) then
		DropPlayer(source, 'Automated kick: '..reason)
	end
end)

RegisterNetEvent('Prefech:getACConfig')
AddEventHandler('Prefech:getACConfig', function()
	local configFile = LoadResourceFile(GetCurrentResourceName(), "./config/ac_config.json")
	local cfgFile = json.decode(configFile)
	TriggerClientEvent('Prefech:SendACConfig', source, cfgFile)
end)

-- version check
Citizen.CreateThread( function()
	local version = GetResourceMetadata(GetCurrentResourceName(), 'version')
	SetConvarServerInfo("JD_logs", "V"..version)	
	if not GetResourceMetadata(GetCurrentResourceName(), 'isbeta') then
		if version then
			PerformHttpRequest(
				'https://raw.githubusercontent.com/Prefech/JD_logs/master/json/version.json',
				function(code, res, headers)
					if code == 200 then
						local rv = json.decode(res)
						if rv.version ~= version then
							print(
								([[^1-------------------------------------------------------
JD_logs
UPDATE: %s AVAILABLE
CHANGELOG: %s
-------------------------------------------------------^0]]):format(
									rv.version,
									rv.changelog
								)
							)
							if cfgFile['DiscordUpdateNotify'] then
								ServerFunc.CreateLog({ description = "**JD_logs Update V"..rv.version.."**\nDownload the latest update of JD_logs here:\nhttps://github.com/prefech/JD_logs/releases/latest\n\n**Changelog:**\n"..rv.changelog, ping = true, channel = 'system'})
							end
						end
					else
						errorLog('JD_logs unable to check version')
					end
				end,
				'GET'
			)
			
		else
			errorLog('JD_logs unable to check version')
		end
	else
		errorLog('Using the JD_logs beta version. (you might experience some issues using the beta version.)')
		if version then
			PerformHttpRequest(
				'https://raw.githubusercontent.com/prefech/JD_logs/beta/json/version.json',
				function(code, res, headers)
					if code == 200 then
						local rv = json.decode(res)
						if rv.version ~= version then
							print(
								([[^1-------------------------------------------------------
JD_logs
UPDATE: %s AVAILABLE
CHANGELOG: %s
-------------------------------------------------------^0]]):format(
									rv.version,
									rv.changelog
								)
							)
							if cfgFile['DiscordUpdateNotify'] then
								ServerFunc.CreateLog({ description = "**JD_logs Update V"..rv.version.."**\nDownload the latest update of JD_logs here:\nhttps://github.com/prefech/JD_logs/archive/refs/heads/beta.zip\n\n**Changelog:**\n"..rv.changelog, ping = true, channel = 'system'})
							end
						end
					else
						errorLog('JD_logs unable to check version')
					end
				end,
				'GET'
			)
			
		else
			errorLog('JD_logs unable to check version')
		end
	end
end)
