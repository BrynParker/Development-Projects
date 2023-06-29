util.AddNetworkString("nutTradeInvite")
util.AddNetworkString("nutTradeMenu")
util.AddNetworkString("nutTradeMenuAbort")
util.AddNetworkString("nutTradeSendItem")
util.AddNetworkString("nutTradeTakeItem")
util.AddNetworkString("nutTradeSyncItems")
util.AddNetworkString("nutTradeCancel")
util.AddNetworkString("nutTradeConfirm")
util.AddNetworkString("nutTradeMoneyGive")
util.AddNetworkString("nutTradeMoneyTake")
util.AddNetworkString("nutTradeMoneySync")

//
util.AddNetworkString("nutInventorySync")
local META = nut.meta.inventory
function META:HalfSync(receiver)
	local slots = {}

	for x, items in pairs(self.slots) do
		for y, item in pairs(items) do
			if (istable(item) and item.gridX == x and item.gridY == y) then
				slots[#slots + 1] = {x, y, item.uniqueID, item.id, item.data}
			end
		end
	end

	net.Start("nutInventorySync")
		net.WriteTable(slots)
		net.WriteUInt(self:GetID(), 32)
		net.WriteUInt(self.w, 6)
		net.WriteUInt(self.h, 6)
		net.WriteType(self.owner)
		net.WriteTable(self.vars or {})
	net.Send(receiver)
end
nut.meta.inventory = META
//
-- micro-op

local pairs, net, timer, math = pairs, net, timer, math

function nut.trade.ClearVars(client)
	client.tradingWith = nil
	client.isTrading = nil
	client.tradingItems = nil
	client.tradingMoney = nil
	client.tradeConfirmed = nil
end

function nut.trade.MenuAbort(client)
	net.Start("nutTradeMenuAbort")
		net.WriteBool(true)
	net.Send(client)

	nut.trade.ClearVars(client)
end

function nut.trade.Complete(client, clientCharacter, otherCharacter, bMoneyOther)

	client.tradingItems = client.tradingItems or {}

	if (!table.IsEmpty(client.tradingItems)) then
		local inventory

		if (bMoneyOther) then

			inventory = otherCharacter:getInv()
		else

			inventory = clientCharacter:getInv()
		end


		if (inventory) then

			for _, slot in pairs(inventory.slots) do
				
				for _, item in pairs(slot) do

					if (client.tradingItems[item.id]) then


						if (item:getData("equip")) then
							if (item.Unequip) then
								item:unequip(client)
							elseif (item.RemoveOutfit) then
								item:removeOutfit(client)
							elseif (item.RemovePart) then
								item:removePart(client)
							end
						end

						if(inventory == otherCharacter:getInv()) then
							item:transfer(clientCharacter:getInv():getID())
						else
							item:transfer(otherCharacter:getInv():getID())
						end	
						
					end
				end
			end
		end
	end

	local money = client.tradingMoney or 0

	if (money != 0) then
		if (bMoneyOther) then
			
			clientCharacter:giveMoney(money)
			otherCharacter:takeMoney(money)
		else
			
			clientCharacter:takeMoney(money)
			otherCharacter:giveMoney(money)
		end
	end

	nut.trade.ClearVars(client)
	client:EmitSound("items/ammo_pickup.wav", 75, 100, 0.5)
	
end

net.Receive("nutTradeConfirm", function(len, client)
	local other = client.tradingWith

	if (!IsValid(other)) then
		nut.trade.MenuAbort(client)
		return
	end

	client.tradeConfirmed = true

	if (client.tradeConfirmed and other.tradeConfirmed) then
		client.tradeConfirmed = nil
		other.tradeConfirmed = nil

		local otherCharacter = other:getChar()
		local clientCharacter = client:getChar()

		if (!otherCharacter or !clientCharacter) then
			nut.trade.MenuAbort(client)
			nut.trade.MenuAbort(other)

			return
		end

		timer.Simple(0, function()
			ProtectedCall(function()
				nut.trade.Complete(client, clientCharacter, otherCharacter, false)
			end)
		end)

		timer.Simple(0, function()
			ProtectedCall(function()
				nut.trade.Complete(other, clientCharacter, otherCharacter, true)
			end)
		end)

		net.Start("nutTradeMenuAbort")
			net.WriteBool(false)
		net.Send({client, other})
	else
		net.Start("nutTradeConfirm")
		net.Send(other)
	end
end)

net.Receive("nutTradeInvite", function(len, client)
	local other = client.invitedBy

	if (!IsValid(other) or !client:Alive() or other.isTrading) then return end

	local clientInv = nut.item.getInventory(client:getLocalVar("TradeInvID"))
	local otherInv = nut.item.getInventory(other:getLocalVar("TradeInvID"))

	if (net.ReadBool() and otherInv and clientInv) then
		other.isTrading = true
		client.isTrading = true

        client.tradingWith = other
        other.tradingWith = client

		-- Inventory --
		otherInv.slots = {}
		clientInv.slots = {}

		client:getChar():getInv():sync(other)
		other:getChar():getInv():sync(client)

		net.Start("nutTradeMenu")
			
			net.WriteEntity(other)
		net.Send(client)

		net.Start("nutTradeMenu")
			net.WriteEntity(client)
		net.Send(other)

        client.invitedBy = nil
        other.invitedBy = nil
	else
		other.tradeInvites[client:EntIndex()] = CurTime() + 60
		client.invitedBy = nil
	end
end)

net.Receive("nutTradeSendItem", function(len, client)
	local id = net.ReadUInt(32)

	if (!isnumber(id) or !client.isTrading) then
		if (!client.isTrading) then
			nut.util.DebugLog(Format("Exploit isTrading: %s (%s)", client:Name(), client:SteamID()))
		elseif (!isnumber(id)) then
			nut.util.DebugLog(Format("Exploit isnumber: %s (%s)", client:Name(), client:SteamID()))
		end

		return
	end

	local other = client.tradingWith
	if (!IsValid(other)) then
		nut.trade.MenuAbort(client)
		return
	end

	client.tradingItems = client.tradingItems or {}
	if (client.tradingItems[id]) then return end

	local item = nut.item.instances[id]
	if (!item) then return end

	client.tradingItems[id] = {item.width, item.height}

	client.tradeConfirmed = nil

	net.Start("nutTradeSyncItems")
		net.WriteTable(client.tradingItems)
		net.WriteBool(false)
	net.Send(other)

	net.Start("nutTradeSyncItems")
		net.WriteTable(client.tradingItems)
		net.WriteBool(true)
	net.Send(client)


end)

net.Receive("nutTradeTakeItem", function(len, client)
	local id = net.ReadUInt(32)

	if (!isnumber(id) or !client.isTrading) then
		if (!client.isTrading) then
			nut.util.DebugLog(Format("Exploit isTrading: %s (%s)", client:Name(), client:SteamID()))
		elseif (!isnumber(id)) then
			nut.util.DebugLog(Format("Exploit isnumber: %s (%s)", client:Name(), client:SteamID()))
		end

		return
	end

	local other = client.tradingWith

	if (!IsValid(other)) then
		nut.trade.MenuAbort(client)
		return
	end

	client.tradingItems = client.tradingItems or {}
	if (!client.tradingItems[id]) then return end

	client.tradingItems[id] = nil
	client.tradeConfirmed = nil

	net.Start("nutTradeSyncItems")
		net.WriteTable(client.tradingItems)
		net.WriteBool(false)
	net.Send(other)

	net.Start("nutTradeSyncItems")
		net.WriteTable(client.tradingItems)
		net.WriteBool(true)
	net.Send(client)
end)

net.Receive("nutTradeCancel", function(len, client)
	local other = client.tradingWith

	if (IsValid(other)) then
		nut.trade.MenuAbort(other)
	end

	nut.trade.ClearVars(client)
end)

net.Receive("nutTradeMoneyGive", function(len, client)

	if (!client.isTrading or CurTime() < (client.nutTradeMoneyTimer or 0)) then
		return
	end

	if (!IsValid(client.tradingWith)) then
		nut.trade.MenuAbort(client)
		return
	end

	local character = client:getChar()

	if (!character) then
		return
	end

	local amount = net.ReadUInt(32)

	amount = math.Clamp((amount or 0), 0, character:getMoney())

	if (amount == 0) then
		return
	end

	client.tradingMoney = math.min(character:getMoney(),amount)

	net.Start("nutTradeMoneySync")
		net.WriteUInt(client.tradingMoney, 32)
		net.WriteBool(false)
		net.WriteBool(false)
	net.Send(client.tradingWith)

	net.Start("nutTradeMoneySync")
		net.WriteUInt(client.tradingMoney, 32)
		net.WriteBool(false)
		net.WriteBool(true)
	net.Send(client)

	client.nutTradeMoneyTimer = CurTime() + 0.5
end)

net.Receive("nutTradeMoneyTake", function(len, client)
	if (!client.isTrading or CurTime() < (client.nutTradeMoneyTimer or 0)) then
		return
	end

	if (!IsValid(client.tradingWith)) then
		nut.trade.MenuAbort(client)
		return
	end

	local amount = net.ReadUInt(32)
	
	amount = math.min(client:getChar():getMoney(),amount)

	if (amount == 0) then
		return
	end

	client.tradingMoney = amount

	net.Start("nutTradeMoneySync")
		net.WriteUInt(client.tradingMoney, 32)
		net.WriteBool(false)
		net.WriteBool(false)
	net.Send(client.tradingWith)

	net.Start("nutTradeMoneySync")
		net.WriteUInt(client.tradingMoney, 32)
		net.WriteBool(false)
		net.WriteBool(true)
	net.Send(client)

	client.nutTradeMoneyTimer = CurTime() + 0.5
end)

do
	local function PlayerDeath(client)
		if (client.isTrading) then
			local other = client.tradingWith

			if (IsValid(other)) then
				nut.trade.MenuAbort(other)
			end

			nut.trade.MenuAbort(client)
		end
	end

	hook.Add("PlayerDeath", "nut.trade.PlayerDeath", PlayerDeath)
	hook.Add("PlayerSilentDeath", "nut.trade.PlayerDeath", PlayerDeath)
end

function PLUGIN:OnCharacterDisconnect(client)
	local tradeInvID = client:getLocalVar("TradeInvID")

	if (tradeInvID and nut.item.getInventory(tradeInvID)) then
		nut.item.inventories[tradeInvID] = nil
		tradeInvID = nil
	end

	if (client.isTrading) then
		local other = client.tradingWith

		if (IsValid(other)) then
			nut.trade.MenuAbort(other)
		end

		nut.trade.ClearVars(client)
	end
end

nut.item.registerInv("tradeInv",nut.config.get("invW"), nut.config.get("invH"))

function PLUGIN:PlayerLoadedChar(client, character)
	if (character) then
		local tradeInvID = client:getLocalVar("TradeInvID")
		
		if (!tradeInvID) then
			local invID = os.time() + client:EntIndex() + character:getID()
			local inventory = nut.item.createInv(nut.config.get("invW"), nut.config.get("invH"), invID)
			inventory.owner = invID
			inventory.noSave = true
			inventory.vars.isTrading = true
			inventory:sync(client)
			client:setLocalVar("TradeInvID", inventory:getID())			
		end
	end
end

function PLUGIN:CanItemBeTransferd(item, curInv, newInventory)
	if (curInv and newInventory) then
		if (newInventory.vars and newInventory.vars.isTrading) or (curInv.vars and curInv.vars.isTrading) then
			return false
		end
	end
end

function PLUGIN:PlayerInteractItem(client, action, item)
	if (client.isTrading and action == "drop" and client.tradingItems and client.tradingItems[item.id]) then
		local other = client.tradingWith

		if (!IsValid(other)) then
			nut.trade.MenuAbort(client)
			return
		end

		client.tradingItems[item.id] = nil
		client.tradeConfirmed = nil

		net.Start("nutTradeSyncItems")
			net.WriteTable(client.tradingItems)
			net.WriteBool(false)
		net.Send(other)

		net.Start("nutTradeSyncItems")
			net.WriteTable(client.tradingItems)
			net.WriteBool(true)
		net.Send(client)
	end
end

function PLUGIN:CanPlayerInteractItem(client, action)
	if (action == "combine" and client.isTrading) then
		return false
	end
end
