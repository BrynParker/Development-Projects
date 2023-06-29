PLUGIN.name = "Trading"
PLUGIN.author = "STEAM_0:1:29606990 and Lechu2375(Porting)"
PLUGIN.description = "Trading of items between players."

local maxTargetDistance = math.pow(400, 2)

nut.trade = nut.trade or {}
function nut.item.getInventory(id) 
	print("getinv",id)
	return (nut.item.inventories[id] or nil)
end

nut.util.include("sv_plugin.lua")

nut.command.add("offer", {
	description = "Offer a trade.",
	syntax = "<string target>",
	onRun = function(client, arguments)
		local target = nut.command.findPlayer(client, arguments[1])
		if (!target) then return end

		if (client.isTrading) then
			return "You cannot start a new trade when one is already active"
		end
		local targetPlayer = target
		local target = target:getChar()
		if (!targetPlayer or targetPlayer == client) then return end

		local targetIndex = targetPlayer:EntIndex()
		local targetName = targetPlayer:Nick()

		if (targetPlayer.isTrading) then
			return Format("%s is already trading", targetName)
		end

		if (client:GetPos():DistToSqr(targetPlayer:GetPos()) > maxTargetDistance) then
			return Format("%s is too far away, unable to trade.", targetName)
		end

		if (IsValid(client.tradingWith)) then
			return Format("You are currently trading with %s!", client.tradingWith:Nick())
		end

		client.tradeInvites = client.tradeInvites or {}

		if ((client.tradeInvites[targetIndex] or 0) > CurTime()) then
			local time = math.Round(client.tradeInvites[targetIndex] - CurTime())
			return Format("Wait %d's before trade inviting %s again!", time, targetName)
		end

		client.tradeInvites[targetIndex] = CurTime() + 7

		targetPlayer.invitedBy = client

		net.Start("nutTradeInvite")
			net.WriteString(client:Nick())
			net.WriteFloat(CurTime() + 30)
		net.Send(targetPlayer)

		return Format("Trade invite sent to %s!", targetName)
	end
})

if (CLIENT) then
	function PLUGIN:LoadFonts()
		surface.CreateFont( "TradeArial20", {
			font = "Arial",
			size = 20,
			weight = 700,
		})
		surface.CreateFont( "TradeArial25", {
			font = "Arial",
			size = 25,
			weight = 700,
		})
	end

	local InvitePanel
	local Col = {
		Main = Color(100,100,100,100),
		Text = color_white,
		Accept = Color(150,255,150),
		Decline = Color(255,150,150)
	}

	net.Receive("nutTradeInvite", function()
		local whoInvite = net.ReadString()
		local timeInvite = net.ReadFloat()

		if (!timeInvite or !whoInvite or IsValid(InvitePanel)) then
			return
		end

		surface.PlaySound("friends/message.wav")

		InvitePanel = vgui.Create('DPanel')
		InvitePanel:SetSize(300, 100)
		InvitePanel.whoInvite = whoInvite
		InvitePanel:SetPos((ScrW() / 2) - 150, ScrH() - 225)
		InvitePanel.Paint = function(this, w, h)
			local glow = math.abs(math.sin(CurTime() * 2) * 255)

			surface.SetDrawColor(Color(glow, 10, 10, 255))

			surface.DrawRect(0, 0, 2, h)
			surface.DrawRect(w - 2, 0, 2, h)
			surface.DrawRect(2, 0, w - 4, 2)
			surface.DrawRect(2, h - 2, w - 4, 2)

			surface.SetDrawColor(Col.Main)
			surface.DrawRect(2, 2, w - 4, h - 4)

			w = (w / 2)

			nut.util.drawText("You have been invited to trade with", w, 15, Col.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, "TradeArial20")
			nut.util.drawText(this.whoInvite, w, 40, team.GetColor(LocalPlayer():Team()), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, "TradeArial25")

			local str = Format("%s to accept", (input.LookupBinding("gm_showhelp") or "None"))
			nut.util.drawText(str, w - 5, 70, Col.Accept, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

			str = Format("%s to decline", (input.LookupBinding("gm_showteam") or "None"))
			nut.util.drawText(str, w + 5, 70, Col.Decline, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end

		hook.Add("PlayerBindPress", InvitePanel, function(self, _, bind, pressed)
			if (!IsValid(self)) then return end

			if (bind:find("gm_showhelp") and pressed) then -- accept
				net.Start("nutTradeInvite")
					net.WriteBool(true)
				net.SendToServer()

				self:Remove()
				return true
			elseif (bind:find("gm_showteam") and pressed) then -- decline
				net.Start("nutTradeInvite")
					net.WriteBool(false)
				net.SendToServer()

				self:Remove()
				return true
			end
		end)

		local panel = InvitePanel
		timer.Simple(math.min(math.abs(timeInvite - CurTime()), 30), function()
			if (IsValid(panel)) then
				panel:Remove()
			end
		end)
	end)

	net.Receive("nutTradeMenuAbort", function()
		if (IsValid(nut.gui.tradeMenu)) then
			nut.gui.tradeMenu:Remove()
			nut.gui.tradeMenu = nil
		end

		if (net.ReadBool()) then
			LocalPlayer():notify("The trade was cancelled")
		else
			LocalPlayer():notify("Trade with " .. LocalPlayer().tradingWith:Nick() .. " complete!")
		end

		LocalPlayer().tradingWith = nil
		LocalPlayer().tradingItems = nil
	end)
	
	net.Receive("nutTradeSyncItems", function()
		local panel = nut.gui.tradeMenu
		if (!IsValid(panel)) then return end

		panel.confirmPanel.confirmTrade = false
		panel.confirmButton:Reset()

		local items = net.ReadTable()
		local bLocal = net.ReadBool()

		if (bLocal) then
			LocalPlayer().tradingItems = items

			-- Hightlight slots --
			for id, v in pairs(nut.gui.inv1.panels) do
				if (!IsValid(v)) then goto SKIP end

				if (items[id]) then
					v.ExtraPaint = function(self, width, height)
						surface.SetDrawColor(50, 150, 50, 45)
						surface.DrawRect(2, 2, width - 4, height - 4)
					end
				else
					v.ExtraPaint = function() end
				end

				::SKIP::
			end
		else
			LocalPlayer().tradingItems = items

			-- Remove old items --
			for _, v in pairs(panel.storageInventory.panels) do
				v:Remove()
			end

			local inventory = nut.item.getInventory(LocalPlayer():getLocalVar("TradeInvID"))
			inventory.slots = {}

			local x, y, w, h

			for id, v in pairs(items) do
				w, h = v[1], v[2]
				x, y = inventory:findEmptySlot(w, h, true)

				if !(x and y) then goto SKIP end

				for x2 = 0, w - 1 do
					for y2 = 0, h - 1 do
						local index = x + x2
						inventory.slots[index] = inventory.slots[index] or {}
						inventory.slots[index][y + y2] = nut.item.instances[id]
					end
				end

				::SKIP::
			end

			panel.storageInventory:setInventory(inventory)
			panel.storageInventory:SetTall(panel.storageInventory:GetTall() + panel.storageMoney:GetTall() + panel.confirmPanel:GetTall() + 2) -- bruh
		end
	end)

	net.Receive("nutTradeMenu", function()
		local otherPlayer = net.ReadEntity()

        LocalPlayer().tradingWith = otherPlayer
		LocalPlayer().tradingItems = {}
		otherPlayer.tradingItems = {}

		-- Menu --
		local panel = vgui.Create("nutTradeView")
		local character = LocalPlayer():getChar()

		-- Local Player --
		panel:SetLocalInventory(character:getInv())
		panel:SetLocalMoney(character:getMoney())

		local tradeInventory = nut.item.getInventory(LocalPlayer():getLocalVar("TradeInvID"))
		tradeInventory.slots = {}

		panel:SetStorageTitle("Trading with " .. otherPlayer:Nick())
		panel:SetStorageInventory(tradeInventory)
		panel:SetStorageMoney(0)
	end)
	
	net.Receive("nutTradeConfirm", function()
		if (IsValid(nut.gui.tradeMenu)) then
			nut.gui.tradeMenu.confirmPanel.confirmTrade = true
		end
	end)
	
	net.Receive("nutTradeMoneySync", function()
		local panel = nut.gui.tradeMenu

		if (!IsValid(panel)) then
			return
		end

		local amount = net.ReadUInt(32)

		local take = net.ReadBool()
		local bLocal = net.ReadBool()

		if (bLocal) then
			local clientMoney = LocalPlayer():getChar():getMoney()

			if (take) then
				panel:SetLocalMoney(clientMoney + amount)
			else 
				panel:SetLocalMoney(clientMoney - amount)
			end

			local name = string.gsub(nut.currency.plural, "%s", "")

			if (amount > 0) then
				panel.localMoney.moneyLabel:SetText(Format("%s: %d (-%d)", name, panel.localMoney.money, amount))
			else
				panel.localMoney.moneyLabel:SetText(Format("%s: %d", name, panel.localMoney.money))
			end
		else
			panel:SetStorageMoney(amount)
		end
	end)

	function PLUGIN:OnCreateItemInteractionMenu(itemPanel, menu, item)
		if (IsValid(nut.gui.tradeMenu)) then
			PrintTable(itemPanel.itemTable)
			local inventory = nut.item.getInventory(itemPanel.itemTable.invID)
			if (inventory.vars.isTrading) then return true end

			menu = DermaMenu()

			if (LocalPlayer().tradingItems[item.id]) then
				menu:AddOption("Take Item", function()
					net.Start("nutTradeTakeItem")
						net.WriteUInt(item:getID(), 32)
					net.SendToServer()
				end):SetImage("icon16/basket_delete.png")
			else
				menu:AddOption("Give Item", function()
					net.Start("nutTradeSendItem")
						net.WriteUInt(item:getID(), 32)
					net.SendToServer()
				end):SetImage("icon16/basket_put.png")
			end

			menu:Open()
			return true
		end
	end
	
	function PLUGIN:CanItemBeTransfered(item, curInv, newInventory)
		if (curInv and newInventory) then
			print("transfer check",item)
			if (newInventory.vars.isTrading and !curInv.vars.isTrading) then
				if (LocalPlayer().tradingWith and !IsValid(LocalPlayer().tradingWith)) then -- abort trade
					if (IsValid(nut.gui.tradeMenu)) then
						nut.gui.tradeMenu:Remove()
						nut.gui.tradeMenu = nil
					end

					return false
				end

				net.Start("nutTradeSendItem")
					net.WriteUInt(item:getID(), 32)
				net.SendToServer()
				return false
			elseif (newInventory.vars.isTrading or curInv.vars.isTrading) then
				return false
			end
		end
	end
end