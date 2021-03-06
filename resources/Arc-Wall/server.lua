local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vRPclient = Tunnel.getInterface("vRP")
arc = {}
Tunnel.bindInterface("Arc-Wall",arc)
Proxy.addInterface("Arc-Wall",arc)
vRP = Proxy.getInterface("vRP")

Config = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- GET USER ID AND STEAMHEX
-----------------------------------------------------------------------------------------------------------------------------------------	
function arc.getId(sourceplayer)
    local sourceplayer = sourceplayer
	if sourceplayer ~= nil and sourceplayer ~= 0 then
		local user_id = vRP.getUserId(sourceplayer)
		if user_id then
			return user_id
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- USER PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------	

function arc.getPermissao(toogle)
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"Admin") or vRP.hasPermission(user_id,"Owner") or vRP.hasPermission(user_id,"Moderador") or vRP.hasPermission(user_id,"Suporte") then
        return true
    else
        return false
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
--Webhook (LINES)
-----------------------------------------------------------------------------------------------------------------------------------------
function arc.reportlinesLog(toggle)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local x,y,z = vRPclient.getPosition(source)
	if user_id then
        local imageurl = "https://media.discordapp.net/attachments/892259951479775244/901918200927768606/novo.png"
        PerformHttpRequest(Config.webhooklines, function(err, text, headers) end, 'POST', json.encode({username = ' SKZ Anticheat - Sistema de ESP ', avatar_url = imageurl, embeds = {
                { 	------------------------------------------------------------
                    title = "**Um administrador ``ativou`` o /lines**",
                    fields = {
                        { 
                            name = "**ID do Administrador:\n**",
                            value = "**"..identity.name.." "..identity.firstname.." ["..user_id.."]**"
                        },
                        {
							name = "**LOCALIZA????O:**\n",
							value = "**"..x..", "..y..", "..z.."**"
                        }, 
                        {                        
							name = "``Sistema.``\n",
							value = "``SKZ Roleplay.``"
						}
                    }, 
                    footer = { 
                        text = "SKZ Anticheat - ESP - "..os.date("%d/%m/%Y | %H:%M:%S"),
                        icon_url = "https://media.discordapp.net/attachments/892259951479775244/901918200927768606/novo.png"
                    },
                    color = 15158332 
                }
            }
        }), { ['Content-Type'] = 'application/json' })
    end
end

function arc.reportunlinesLog(toggle)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local x,y,z = vRPclient.getPosition(source)
	if user_id then
        local imageurl = "https://media.discordapp.net/attachments/892259951479775244/901918200927768606/novo.png"
        PerformHttpRequest(Config.webhooklines, function(err, text, headers) end, 'POST', json.encode({username = ' SKZ Anticheat - Sistema de ESP ', avatar_url = imageurl, embeds = {
                { 	------------------------------------------------------------
                    title = "**Um administrador ``desativou`` o /lines**",
                    fields = {
                        { 
                            name = "**ID do Administrador:\n**",
                            value = "**"..identity.name.." "..identity.firstname.." ["..user_id.."]**"
                        },
                        {
							name = "**LOCALIZA????O:**\n",
							value = "**"..x..", "..y..", "..z.."**"
                        },
                        {                        
							name = "``Sistema.``\n",
							value = "``SKZ Roleplay.``"
						}
                    }, 
                    footer = { 
                        text = "SKZ Anticheat - ESP - "..os.date("%d/%m/%Y | %H:%M:%S"),
                        icon_url = "https://media.discordapp.net/attachments/892259951479775244/901918200927768606/novo.png"
                    },
                    color = 15158332 
                }
            }
        }), { ['Content-Type'] = 'application/json' })
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
--Webhook (WALL)
-----------------------------------------------------------------------------------------------------------------------------------------
function arc.reportwallLog(toggle)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local x,y,z = vRPclient.getPosition(source)
	if user_id then
        local imageurl = "https://media.discordapp.net/attachments/892259951479775244/901918200927768606/novo.png"
        PerformHttpRequest(Config.webhookwall, function(err, text, headers) end, 'POST', json.encode({username = ' SKZ Anticheat - Sistema de ESP ', avatar_url = imageurl, embeds = {
                { 	------------------------------------------------------------
                    title = "**Um administrador ``ativou`` o /Wall**",
                    fields = {
                        { 
                            name = "**ID do Administrador:\n**",
                            value = "**"..identity.name.." "..identity.firstname.." ["..user_id.."]**"
                        },
                        {
							name = "**LOCALIZA????O:**\n",
							value = "**"..x..", "..y..", "..z.."**"
                        },
                        {                        
							name = "``Sistema.``\n",
							value = "``SKZ Roleplay.``"
						}
                    }, 
                    footer = { 
                        text = "SKZ Anticheat - ESP - "..os.date("%d/%m/%Y | %H:%M:%S"),
                        icon_url = "https://media.discordapp.net/attachments/892259951479775244/901918200927768606/novo.png"
                    },
                    color = 15158332 
                }
            }
        }), { ['Content-Type'] = 'application/json' })
    end
end

function arc.reportunwallLog(toggle)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local x,y,z = vRPclient.getPosition(source)
	if user_id then
        local imageurl = "https://media.discordapp.net/attachments/892259951479775244/901918200927768606/novo.png"
        PerformHttpRequest(Config.webhookwall, function(err, text, headers) end, 'POST', json.encode({username = ' SKZ Anticheat - Sistema de ESP ', avatar_url = imageurl, embeds = {
                { 	------------------------------------------------------------
                    title = "**Um administrador ``desativou`` o /Wall**",
                    fields = {
                        { 
                            name = "**ID do Administrador:\n**",
                            value = "**"..identity.name.." "..identity.firstname.." ["..user_id.."]**"
                        },
                        {
							name = "**LOCALIZA????O:**\n",
							value = "**"..x..", "..y..", "..z.."**"
                        },
                        {                        
							name = "``Sistema.``\n",
							value = "``SKZ Roleplay.``"
						}
                    }, 
                    footer = { 
                        text = "SKZ Anticheat - ESP - "..os.date("%d/%m/%Y | %H:%M:%S"),
                        icon_url = "https://media.discordapp.net/attachments/892259951479775244/901918200927768606/novo.png"
                    },
                    color = 15158332 
                }
            }
        }), { ['Content-Type'] = 'application/json' })
    end
end


print("^2 WALL INICIADO COM SUCESSO")