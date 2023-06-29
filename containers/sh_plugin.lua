PLUGIN.name = "Placeable Containers"
PLUGIN.author = ""
PLUGIN.desc = ""

nut.util.include("sv_plugin.lua")

nut.command.add("getlock", {
	onRun = function(client, arguments)
		local trace = client:GetEyeTraceNoCursor()
		local target = trace.Entity
		if target and IsValid(target) and (target:isDoor() or target:GetClass() == "nut_container") then
			if target:isDoor() then
				local data = target:getNetVar("doorData")
				if not data["locked"] then
					if data["lockedid"] then
						local data1 = {}
						data1["id"] = data["lockedid"]
						client:getChar():getInv():add("lock", 1, data)
						data["lockedid"] = nil
						target:setNetVar("doorData", data)
						client:notify("The lock has been removed")		
					else
						client:notify("There is no lock on this container")
					end
				else
					client:notify("The container must be unlocked to remove the lock")
				end
			else
				if not target:getNetVar("locked", false) then
					if (target:getNetVar("lockedid")) then
						client:getChar():getInv():add("lock", 1, data)
						target:setNetVar("lockedid", nil)
						client:notify("The lock has been removed")
					else
						client:notify("There is no lock on this container")
					end
				else
					client:notify("The container must be unlocked to remove the lock")
				end
			end
		else
			client:notify("You must be looking at a door or container")
		end
	end
})

function PLUGIN:OnContainerSpawned(container, item, load)	
	container:SetModel(item.model)
	container:PhysicsInit(SOLID_VPHYSICS)
	container:SetMoveType(MOVETYPE_VPHYSICS)
	container:SetUseType(SIMPLE_USE)
	local physicsObject = container:GetPhysicsObject()
	if (IsValid(physicsObject)) then
		physicsObject:EnableMotion(true)
		physicsObject:Wake()
	end

	container.owner = item.player:getChar():getID()
	container.selfMat = container:GetMaterial()
	if (!load == true) then
		container:SetMaterial("models/wireframe")
	end
	container.item = item
	local invData = {
		name = item.name,
		desc = item.desc,
		width = item.invW,
		height = item.invH,
		locksound = item.locksound,
		opensound = item.opensound
	}
	container.invData = invData
	container.money = 0
	container:setNetVar("uid", item.uniqueID)
end

function PLUGIN:LoadData()
	local savedTable = self:getData() or {}
	for k, v in ipairs(savedTable) do
		local container = ents.Create("nut_container")
		
		container:SetPos(v.pos)
		container:SetAngles(v.ang)
		container:Spawn()
		container:SetModel(v.model)
		container:PhysicsInit(SOLID_VPHYSICS)
		container:SetMoveType(MOVETYPE_VPHYSICS)
		container:SetUseType(SIMPLE_USE)
		local physicsObject = container:GetPhysicsObject()
		if (IsValid(physicsObject)) then
			physicsObject:EnableMotion(false)
			physicsObject:Sleep()
		end
		container.owner = v.owner
		container.selfMat = v.selfMat
		container.item = v.item
		container.invData = v.invData
		container.money = v.money
		container.placed = true
		container.lockedid = v.lockedid
		container:setNetVar("uid", v.uid)
		container:setNetVar("locked", v.locked)
		
		nut.item.restoreInv(v.id, v.invData.width, v.invData.height, function(inventory)
			if (IsValid(container)) then
				container:setInventory(inventory)
			end
		end)
	end
end

function PLUGIN:SaveData()
	self:saveContainer()
end

function PLUGIN:saveContainer()
	local saveTable = {}
	for k, v in ipairs(ents.FindByClass("nut_container")) do
		if v.placed == true then
			table.insert(saveTable, {
			model = v:GetModel(), 
			pos = v:GetPos(), 
			ang = v:GetAngles(), 
			item = v.item, 
			owner = v.owner, 
			invData = v.invData,
			selfMat = v.selfMat,	
			id = v:getNetVar("id"),
			money = v:getMoney(),
			lockedid = v.lockedid,
			locked = v:getNetVar("locked", false),
			uid = v:getNetVar("uid")
			})
		end
	end
	
	self:setData(saveTable)
end

if (CLIENT) then
	local PLUGIN = PLUGIN
	
	netstream.Hook("ContainerMoney", function(value, index)
		if (!IsValid(nut.gui["inv"..index])) then
			return
		end
		nut.gui["inv"..index].money = value
	end)
	
	netstream.Hook("invOpen2", function(entity, index, lave)
		netstream.Start("EntGiveMoney", entity, 0)
		local char = LocalPlayer():getChar() 

		if (IsValid(nut.gui.inv1)) or (IsValid(inventory_info))  or (IsValid(equipment)) then return false end

		if (char) then
			nut.gui.inv1 = vgui.Create("nutInventory")
			nut.gui.inv1:ShowCloseButton(false)
			local inventory2 = char:getInv()
			if (inventory2) then nut.gui.inv1:setInventory(inventory2) end
			nut.gui.inv1:SetSize(nut.gui.inv1:GetWide(), nut.gui.inv1:GetTall())
			nut.gui.inv1:SetPos(ScrW()*0.65, ScrH()*0.1)

			inventory_info = vgui.Create("inventory_info")
			inventory_info:SetPos(ScrW() * -0.01, ScrH()*0.09)
			inventory_info:SetSize(inventory_info:GetSize())

			safebox_menuINV = vgui.Create("nutInventory")
			safebox_menuINV:ShowCloseButton(false)
			safebox_menuINV:SetTitle("")
			safebox_menuINV:setInventory(nut.item.inventories[index])
			safebox_menuINV:SetPos(ScrW()*0.33, ScrH()*0.1)

			function safebox_menuINV:Paint(w, h)
				draw.DrawText("Storage Container", "MySuperFont", ScrW() * 0.016, ScrH() * 0.0001, Color(182, 182, 182, 220), TEXT_ALIGN_LEFT )
				draw.DrawText("Money: " .. (nut.gui["inv"..entity:getInv():getID()].money or 0), "NameFactionFactionFont", ScrW() * 0.016, ScrH() * 0.056, Color(182, 182, 182, 220), TEXT_ALIGN_LEFT )
			end





			safebox_menuINV.OnClose = function(this)
				if (IsValid(nut.gui.inv1) and !IsValid(nut.gui.menu)) then
					nut.gui.inv1:Remove()
					inventory_info:Remove()
					inventoryframe:Remove()
				end
			end
		
			local oldClose = nut.gui.inv1.OnClose
			nut.gui.inv1.OnClose = function()
				if (IsValid(safebox_menuINV) and !IsValid(nut.gui.menu)) then
					safebox_menuINV:Remove()
					inventory_info:Remove()
					inventoryframe:Remove()
				end
				nut.gui.inv1.OnClose = oldClose
			end
		end

		nut.gui["inv"..index] = safebox_menuINV

		local function paintDtextEntry(s, w, h)
		surface.SetDrawColor(0, 0, 14, 100)
		surface.DrawRect(0, 0, w, h)

		s:DrawTextEntryText(color_white, color_white, color_white)
		end

		local entry = nut.gui.inv1:Add("DTextEntry")
		entry:SetSize(ScrW() * 0.2, ScrH() * 0.0325)
		entry:SetPos(ScrW() * 0.017, ScrH() * 0.78)
		entry:SetValue(0)
		entry:SetNumeric(true)
		entry.Paint = paintDtextEntry
		entry:SetFont("Roh20")
		entry:SetTextColor(Color(255, 255, 255, 210))

		entry.OnEnter = function()
			local value = tonumber(entry:GetValue()) or 0
			if LocalPlayer():getChar():hasMoney(value) and value > 0 then
				surface.PlaySound("interface/inv_ruck.ogg")
				netstream.Start("TakeMoney", value)
				netstream.Start("EntGiveMoney", entity, value)
				entry:SetValue(0)
			elseif value <= 0 then
				nut.util.notify("You have entered an invalid valua")
				entry:SetValue(0)
			else
				nut.util.notify("You cannot afford this")
				entry:SetValue(0)
			end		
		end
		
		local transfer = nut.gui.inv1:Add("DButton")
		transfer:SetSize( ScrW() * 0.1, ScrH() * 0.0325)
		transfer:SetPos(ScrW() * 0.221, ScrH() * 0.78)
		transfer:SetText("Transfer")
		transfer:SetFont("Roh20")
		transfer:SetTextColor(Color(211, 211, 211)) 
		function transfer:Paint( w, h )
			if self:IsDown() then 
				surface.SetDrawColor(Color( 255, 186, 0, 12))
				surface.SetMaterial(nut.util.getMaterial("gui/center_gradient"))
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(Color( 255, 186, 0, 24))
				surface.DrawOutlinedRect(0, 0, w, h) 
			elseif self:IsHovered() then 
				surface.SetDrawColor(Color( 30, 30, 30, 150))
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(Color( 0, 0, 0, 235))
				surface.DrawOutlinedRect(0, 0, w, h)
			else
				surface.SetDrawColor(Color( 30, 30, 30, 160))
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(Color( 0, 0, 0, 235))
				surface.DrawOutlinedRect(0, 0, w, h)
			end
		end

		transfer.DoClick = function()
			local value = tonumber(entry:GetValue()) or 0
			if LocalPlayer():getChar():hasMoney(value) and value > 0 then
				surface.PlaySound("interface/inv_ruck.ogg")
				netstream.Start("TakeMoney", value)
				netstream.Start("EntGiveMoney", entity, value)
				entry:SetValue(0)
			elseif value <= 0 then
				nut.util.notify("You have entered an invalid value")
				entry:SetValue(0)
			else
				nut.util.notify("You cannot afford this")
				entry:SetValue(0)
			end						
		end
		
		safebox_menuINV:SetSize(safebox_menuINV:GetWide(), safebox_menuINV:GetTall())
		
		local entry1 = safebox_menuINV:Add("DTextEntry")
		entry1:SetSize(ScrW() * 0.173, ScrH() * 0.0325)
		entry1:SetPos(ScrW() * 0.017, ScrH() * 0.608)
		entry1:SetValue(0)
		entry1.Paint = paintDtextEntry
		entry1:SetFont("Roh20")
		entry1:SetTextColor(Color(255, 255, 255, 210))
		entry1:SetNumeric(true)

		entry1.OnEnter = function()
			local value = tonumber(entry1:GetValue()) or 0
			if nut.gui["inv"..index].money >= value and value > 0 then
				surface.PlaySound("interface/inv_take_7.ogg")
				netstream.Start("EntTakeMoney", entity, value)
				netstream.Start("GiveMoney", value)
				entry1:SetValue(0)
			elseif value <= 0 then
				nut.util.notify("You have entered an invalid value")
				entry1:SetValue(0)
			else
				nut.util.notify("You cannot request more than what is available")
				entry1:SetValue(0)
			end			
		end
		
		local transfer1 = safebox_menuINV:Add("DButton")
		transfer1:SetSize( ScrW() * 0.095, ScrH() * 0.0325)
		transfer1:SetPos(ScrW() * 0.1937, ScrH() * 0.608)
		transfer1:SetFont("Roh20")
		transfer1:SetTextColor(Color(211, 211, 211)) 
		function transfer1:Paint( w, h )
			if self:IsDown() then 
				surface.SetDrawColor(Color( 255, 186, 0, 12))
				surface.SetMaterial(nut.util.getMaterial("gui/center_gradient"))
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(Color( 255, 186, 0, 24))
				surface.DrawOutlinedRect(0, 0, w, h) 
			elseif self:IsHovered() then 
				surface.SetDrawColor(Color( 30, 30, 30, 150))
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(Color( 0, 0, 0, 235))
				surface.DrawOutlinedRect(0, 0, w, h)
			else
				surface.SetDrawColor(Color( 30, 30, 30, 160))
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(Color( 0, 0, 0, 235))
				surface.DrawOutlinedRect(0, 0, w, h)
			end
		end
		transfer1:SetText("Take")

		transfer1.DoClick = function()
			local value = tonumber(entry1:GetValue()) or 0
			if nut.gui["inv"..index].money >= value and value > 0 then
				surface.PlaySound("interface/inv_take_7.ogg")
				netstream.Start("EntTakeMoney", entity, value)
				netstream.Start("GiveMoney", value)
				entry1:SetValue(0)
			elseif value <= 0 then
				nut.util.notify("You have entered an invalid value")
				entry1:SetValue(0)
			else
				nut.util.notify("You cannot request more than what is available")
				entry1:SetValue(0)
			end						
			print("Fuck you")
		end
	end)
end

