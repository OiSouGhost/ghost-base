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
Tunnel.bindInterface("vrp_tablet",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local twitter = {}
local policia = {}
local paramedico = {}
local anonimo = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTTWITTER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestMedia(media)
	if media == "Twitter" then
		return twitter
	end
end

function cRP.requestAbout()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inv = vRP.getInventory(user_id)
		if inv then
			local inventory = {}
			for k,v in pairs(inv) do
					inventory[k] = v
				end

			local identity = vRP.getUserIdentity(user_id)
			return inventory,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),{ identity.name.." "..identity.name2,parseInt(user_id),parseInt(identity.bank),parseInt(vRP.getGmsId(user_id)),identity.phone,identity.registration }
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTTWITTER
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.messageMedia(message,page)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local text = ""
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			text = "[ <i>"..os.date("%H")..":"..os.date("%M").."</i> ] <b>"..identity.name.." "..identity.name2..":</b> "..message
		end

			if page == "Twitter" then
				if vRP.getPremium(user_id) then
				table.insert(twitter,{ text = text, back = true })
				TriggerClientEvent("vrp_tablet:updateMedia", -1, page, text, true )
			else
				table.insert(twitter,{ text = text })
				TriggerClientEvent("vrp_tablet:updateMedia", -1, page, text, false )
			end
			TriggerClientEvent("Notify",-1,"importante","Novo tweet de <b>"..identity.name.." "..identity.name2.."</b>.",3000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local twitterFile = LoadResourceFile("logsystem","twitter.json")
	twitter = json.decode(twitterFile)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_ADMIN:KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_admin:KickAll")
AddEventHandler("vrp_admin:KickAll",function()
	SaveResourceFile("logsystem","twitter.json",json.encode(twitter),-1)
end)