local PANEL = {}

function PANEL:Init(uniqueID)

	self:SetAlpha(0)
	self:AlphaTo(255, 0.5, 0)
	
	self:SetSize(ScrW() * 0.5, ScrH() * 0.75)
	self:MakePopup()
	--self:Center()
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)

	self.model = self:Add("nutModelPanel")
	self.model:SetSize(ScrW() * 0.4, ScrH() * 0.7)
	self.model:SetPos(ScrW() * 0.01, ScrH() * 0.06)

	self.model:SetZPos(-999)
	local buttonsBgColor = Color(182, 182, 182, 100)
	local buttonsHoverColor = Color(200, 200, 200)



	

	 inventoryframe = vgui.Create("DFrame")
     inventoryframe:SetTitle("")
     inventoryframe:SetSize(ScrW(), ScrH())
     inventoryframe:SetPos(0, 0)
     inventoryframe:ShowCloseButton(false)
     inventoryframe:SetDraggable(false)
     inventoryframe.Paint = function(self, w, h)
		
		nut.util.drawBlur(self, 5)
		draw.DrawText("Press 'I' to close", "NameFactionPingFont", ScrW() * 0.004, ScrH() * 0.004, Color(182, 182, 182, 220), TEXT_ALIGN_LEFT)
		surface.SetDrawColor(45, 45, 45, 100)
		surface.SetMaterial( Material("vgui/gradient-r") )
		surface.DrawTexturedRect(ScrW() * 0.931, ScrH() * 0.186, 115, ScrH() * 0.67)
     end
		
		
		
		self.but_1 = inventoryframe:Add("DButton")
		self.but_1:SetPos( ScrW() * 0.949, ScrH() * 0.355 )
		self.but_1:SetSize( 64, 64 )
		self.but_1:SetText("")
		self.but_1:SetFont("Roh20")
		self.but_1:SetTextColor(color_white) 
		
		function self.but_1:Paint( w, h )
			surface.SetDrawColor(buttonsBgColor)
			surface.SetMaterial(Material("mafiarp/icons/user.png"))
			surface.DrawTexturedRect(0, 0, 64, 64)

			if self:IsDown() then 
			surface.SetDrawColor(buttonsHoverColor)
			surface.SetMaterial(Material("mafiarp/icons/user.png"))
			surface.DrawTexturedRect(0, 0, 64, 64)
			elseif self:IsHovered() then 
			surface.SetDrawColor(buttonsHoverColor)
			surface.SetMaterial(Material("mafiarp/icons/user.png"))
			surface.DrawTexturedRect(0, 0, 64, 64)
			end
		end
		self.but_1.DoClick = function(client)
			self:Remove()
			nut.gui.inv1:Remove()
			inventory_info:Remove()
			if IsValid(safebox_menuINV) then
				safebox_menuINV:Remove()
			else 
				return false
			end
		end
		
				
		self.but_2 = inventoryframe:Add("DButton")
		self.but_2:SetPos( ScrW() * 0.949, ScrH() * 0.28 )
		self.but_2:SetSize( 64, 64 )
		self.but_2:SetText("")
		self.but_2:SetFont("Roh20")
		self.but_2:SetTextColor(color_white) 
		
		function self.but_2:Paint( w, h )
			surface.SetDrawColor(buttonsBgColor)
			surface.SetMaterial(Material("mafiarp/icons/chat_large.png"))
			surface.DrawTexturedRect(0, 0, 64, 64)

			if self:IsDown() then 
			surface.SetDrawColor(buttonsHoverColor)
			surface.SetMaterial(Material("mafiarp/icons/chat.png"))
			surface.DrawTexturedRect(0, 0, 64, 64)
			elseif self:IsHovered() then 
			surface.SetDrawColor(buttonsHoverColor)
			surface.SetMaterial(Material("mafiarp/icons/chat.png"))
			surface.DrawTexturedRect(0, 0, 64, 64)
			end
		end
		self.but_2.DoClick = function(client)
			self:Remove()
			nut.gui.inv1:Remove()
			inventory_info:Remove()
			LocalPlayer():ConCommand("say /chardesc")
		end
		
		
		self.but_3 = inventoryframe:Add("DButton")
		self.but_3:SetPos( ScrW() * 0.949, ScrH() * 0.2 )
		self.but_3:SetSize( 64, 64 )
		self.but_3:SetText("")
		self.but_3:SetFont("Roh20")
		self.but_3:SetTextColor(color_white) 
		
		function self.but_3:Paint( w, h )
			surface.SetDrawColor(buttonsBgColor)
			surface.SetMaterial(Material("mafiarp/icons/skills.png"))
			surface.DrawTexturedRect(0, 0, 64, 64)

			if self:IsDown() then 
			surface.SetDrawColor(buttonsHoverColor)
			surface.SetMaterial(Material("mafiarp/icons/skills.png"))
			surface.DrawTexturedRect(0, 0, 64, 64)
			elseif self:IsHovered() then 
			surface.SetDrawColor(buttonsHoverColor)
			surface.SetMaterial(Material("mafiarp/icons/skills.png"))
			surface.DrawTexturedRect(0, 0, 64, 64)
			end
		end
		self.but_3.DoClick = function(client)
			self:Remove()
			nut.gui.inv1:Remove()
			inventory_info:Remove()
			if IsValid(safebox_menuINV) then
				safebox_menuINV:Remove()
			else 
				return false
			end
		end
		
		
		self.but_4 = inventoryframe:Add("DButton")
		self.but_4:SetPos( ScrW() * 0.949, ScrH() * 0.44 )
		self.but_4:SetSize( 64, 64 )
		self.but_4:SetText("")
		self.but_4:SetFont("Roh20")
		self.but_4:SetTextColor(color_white) 
		
		function self.but_4:Paint( w, h )
			surface.SetDrawColor(buttonsBgColor)
			surface.SetMaterial(Material("mafiarp/icons/settings.png"))
			surface.DrawTexturedRect(0, 0, 64, 64)

			if self:IsDown() then 
			surface.SetDrawColor(buttonsHoverColor)
			surface.SetMaterial(Material("mafiarp/icons/settings.png"))
			surface.DrawTexturedRect(0, 0, 64, 64)
			elseif self:IsHovered() then 
			surface.SetDrawColor(buttonsHoverColor)
			surface.SetMaterial(Material("mafiarp/icons/settings.png"))
			surface.DrawTexturedRect(0, 0, 64, 64)
			end
		end
		self.but_4.DoClick = function(client)
			self:Remove()
			nut.gui.inv1:Remove()
			inventory_info:Remove()
			if IsValid(safebox_menuINV) then
				safebox_menuINV:Remove()
			else 
				return false
			end
		end
				if LocalPlayer():IsSuperAdmin() then
					local transfer = inventoryframe:Add("DButton")
					transfer:SetSize( 32, 32)
					transfer:SetPos(ScrW() * 0.004, ScrH() * 0.963)
					transfer:SetText("")
					transfer:SetFont("Roh20")
					transfer:SetTextColor(Color(211, 211, 211)) 
					function transfer:Paint( w, h )
							surface.SetDrawColor(Color( 33, 46, 83, 230))
							surface.SetMaterial(nut.util.getMaterial("mafiarp/icons/settings.png"))
							surface.DrawTexturedRect(0, 0, w, h)
					end

					transfer.DoClick = function()
						nut.gui.inv1:Remove()
						inventory_info:Remove()
						configMenu = vgui.Create("configMenu")
						configMenu:SetSize(configMenu:GetWide(), configMenu:GetTall())
						if IsValid(safebox_menuINV) then
							safebox_menuINV:Remove()
						else 
							return false
						end
					end
				else 
					return false
				end
	
		local char = LocalPlayer():getChar()



		if (self.model) then
			self.model:SetModel(LocalPlayer():GetModel())
			self.model.Entity:SetSkin(LocalPlayer():GetSkin())

			for k, v in ipairs(LocalPlayer():GetBodyGroups()) do
				self.model.Entity:SetBodygroup(v.id, LocalPlayer():GetBodygroup(v.id))
			end

			local ent = self.model.Entity
			if (ent and IsValid(ent)) then
				local mats = LocalPlayer():GetMaterials()
				for k, v in pairs(mats) do
					ent:SetSubMaterial(k - 1, LocalPlayer():GetSubMaterial(k - 1))
				end
			end
		end
		hook.Run("CreateCharInfoText", self)
		hook.Run("OnCharInfoSetup", self)
	
	
	
end



function PANEL:Paint(w, h)
	draw.DrawText(LocalPlayer():getChar():getName(), "InterThinLarge", ScrW() * 0.21, ScrH() * 0.064, Color(182, 182, 182, 220), TEXT_ALIGN_CENTER)
	draw.DrawText(team.GetName(LocalPlayer():Team()), "InterThin", ScrW() * 0.21, ScrH() * 0.03, team.GetColor(LocalPlayer():Team()), TEXT_ALIGN_CENTER)
	draw.DrawText("$" .. (LocalPlayer():getChar():getMoney()), "InterThin", ScrW() * 0.063, ScrH() * 0.159, Color(109, 109, 109, 220), TEXT_ALIGN_LEFT)
	draw.DrawText((LocalPlayer():Health()), "InterThin", ScrW() * 0.064, ScrH() * 0.209, Color(109, 109, 109, 220), TEXT_ALIGN_LEFT)
	draw.DrawText((LocalPlayer():Armor()), "InterThin", ScrW() * 0.064, ScrH() * 0.259, Color(109, 109, 109, 220), TEXT_ALIGN_LEFT)
	
	--money
	surface.SetDrawColor(255, 255, 255, 220)
	surface.SetMaterial( Material("mafiarp/player/currency.png") )
	surface.DrawTexturedRect( ScrW() * 0.03, ScrH() * 0.15, 64, 64 )
	
	--health
	surface.SetDrawColor(255, 255, 255, 220)
	surface.SetMaterial( Material("mafiarp/player/health.png") )
	surface.DrawTexturedRect( ScrW() * 0.03, ScrH() * 0.2, 64, 64 )
	
	--armor
	surface.SetDrawColor(255, 255, 255, 220)
	surface.SetMaterial( Material("mafiarp/player/armor.png") )
	surface.DrawTexturedRect( ScrW() * 0.03, ScrH() * 0.25, 64, 64 )
end

function PANEL:OnRemove()
	self:SetAlpha(255)
	self:AlphaTo(0, 0.5, 0)
	inventoryframe:Remove()	
end


vgui.Register("inventory_info", PANEL, "DFrame")
netstream.Hook("inventory_info", function()
	inventory_info = vgui.Create("inventory_info")
end)