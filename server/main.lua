ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('laot-chopshop:AddItem')
AddEventHandler('laot-chopshop:AddItem', function(item, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.canCarryItem(item, count) then
        xPlayer.addInventoryItem(item, count)
    else
        TriggerClientEvent("laot-chopshop:Notification", src, "error", "Bu kadar ağırlığı kaldıramıyorsun!")
    end
end)

RegisterNetEvent('laot-chopshop:SellNPC')
AddEventHandler('laot-chopshop:SellNPC', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	for k, v in pairs(C.Items) do
		local count = xPlayer.getInventoryItem(v["name"]).count
		if count > 0 then
			xPlayer.removeInventoryItem(v["name"], count)
			xPlayer.addInventoryItem('cash', count * v["price"])
		end
	end
end)

ESX.RegisterServerCallback('laot-chopshop:GetPolice', function(source, cb)
	policecount = 0
	count = 0
	Wait(1)
	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		count = count + 1
		if xPlayer.job.name == 'police' then
			policecount = policecount + 1
		end		
	end	
	if count >= C.policeCount then
		if policecount >= C.policeCount then
			cb(1)
		else
			cb(0)
		end
	else
		cb(0)
	end
end)