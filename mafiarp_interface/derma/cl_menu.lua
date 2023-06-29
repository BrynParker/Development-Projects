local PANEL = {}
local alpha = 80

		surface.CreateFont("MetroText", {
			font = "UniSansHeavyCAPS",
			size =  ScreenScale(12),
			weight = 800,
			antialias = true,
		})

		surface.CreateFont("InformationTextFont", {
			font = "Arial",
			size =  ScreenScale(5),
			weight = 800,
			antialias = true,
		})

		surface.CreateFont("InformationTextFont2", {
			font = "Arial",
			size =  ScreenScale(7),
			weight = 800,
			antialias = true,
		})

	surface.CreateFont("DescCharFont1",
	{
		font = "Myriad Pro",
		size = ScreenScale(7),
		weight = 150,
		antialias = true,
		extended = true
	})

		surface.CreateFont("dobi4ikxyecockft",
	{
		font = "GOST type B",
		size = ScreenScale(11),
		weight = 250,
		antialias = true,
		extended = true
	})

		surface.CreateFont("dobi4ikxyecoc44",
	{
		font = "GOST type B",
		size = ScreenScale(11),
		weight = 250,
		antialias = true,
		extended = true
	})
			surface.CreateFont("dobi4ikxyecockft123",
	{
		font = "GOST type B",
		size = ScreenScale(9),
		weight = 250,
		antialias = true,
		extended = true
	})

	function PANEL:Init()
		local char = LocalPlayer():getChar()
		if (IsValid(nut.gui.menu)) then
			nut.gui.menu:Remove()
		end

		nut.gui.menu = self
		self:SetSize(ScrW(), ScrH())

		local right_panelWyes, right_panelHyes = ScrW() * 0.564, ScrH() * 0.26
		local right_panelXyes, right_panelYyes = (ScrW() * 0.665) - (right_panelWyes * 0.5), ScrH() * 0.05

		local trueplusW, trueplusH = ScrW() * 0.542, ScrH() * 0.155
		local trueplusX, trueplusY = (ScrW() * 0.664) - (trueplusW * 0.5), ScrH() * 0.137

		local typo_logoWyes, typo_logoHyes = ScrW() * 0.32, ScrH() * 0.78
		local typo_logoXyes, typo_logoYyes = (ScrW() * 0.2) - (typo_logoWyes * 0.5), ScrH() * 0.05

		local right_panelplusW, right_panelplusH = ScrW() * 0.295, ScrH() * 0.08
		local right_panelplusX, right_panelplusY = (ScrW() * 0.16) - (right_panelplusW * 0.5), ScrH() * 0.02

		self:SetAlpha(0)
		self:AlphaTo(255, 0.25, 0)
		self:SetPopupStayAtBack(true)
		function self:Paint( w, h )
			local x, y = gui.MousePos()
			nut.util.drawBlur(self, 5)
			surface.SetDrawColor(Color( 0, 0, 0, 128))
			surface.DrawRect(right_panelXyes, right_panelYyes, right_panelWyes, right_panelHyes)

			surface.SetDrawColor(Color(52, 137, 128, 120))
			surface.SetMaterial(nut.util.getMaterial("gui/center_gradient"))
			surface.DrawTexturedRect(trueplusX, trueplusY - 70, trueplusW, trueplusH + 75) 


			surface.SetDrawColor(0, 0, 0, 128) 
			surface.DrawRect(typo_logoXyes, typo_logoYyes, typo_logoWyes, typo_logoHyes) 
			surface.DrawTexturedRect(typo_logoXyes, typo_logoYyes, typo_logoWyes, typo_logoHyes) 

			draw.DrawText(LocalPlayer():getChar():getName(), "MetroText",  ScrW() * 0.205, ScrH() * 0.764, Color(169, 169, 169), TEXT_ALIGN_CENTER )


		end
		local suppress = hook.Run("CanCreateCharInfo", self)

		local function paintDtextEntry(s, w, h)
		surface.SetDrawColor(0, 0, 0, 128)
		surface.DrawRect(0, 0, w, h)

		s:DrawTextEntryText(color_white, color_white, color_white)
		end

		self.build_info = self:Add("DLabel")
		self.build_info:SetSize(ScrW() * 0.15, ScrH() * 0.021)
		self.build_info:SetPos(ScrW() * -0.02, ScrH() * 0.97)
		self.build_info:SetTextColor( Color(182, 182, 182, 220) )
		self.build_info:SetText("Inventory - 'I' Key")
		self.build_info:SetFont("dobi4ikxyecockft123")
		self.build_info:SetContentAlignment(2)
		self.build_info:SetAlpha(0)
		self.build_info:AlphaTo(255, 1, 0, function()
			self.build_info.Paint = function(this)
				this:SetAlpha(math.abs(math.cos(RealTime() * 0) * 255))
			end
		end)
		self.build_info:SetExpensiveShadow(1, color_black)


		local typo_logoWyes, typo_logoHyes = ScrW() * 0.32, ScrH() * 0.78
		local typo_logoXyes, typo_logoYyes = (ScrW() * 0.2) - (typo_logoWyes * 0.5), ScrH() * 0.05

		self.left_panel = self:Add("DLabel")
		self.left_panel:SetPos( typo_logoXyes, typo_logoYyes )
		self.left_panel:SetSize( typo_logoWyes, typo_logoHyes )
		self.left_panel:SetText("")
		self.left_panel:SetFont("DescCharFont1")

		local but_1Wyes, but_1Hyes = ScrW() * 0.13, ScrH() * 0.045
		local but_1Xyes, but_1Yyes = (ScrW() * 0.485) - (but_1Wyes * 0.5), ScrH() * 0.09

		self.but_1 = self:Add("DButton")
		self.but_1:SetPos( but_1Xyes, but_1Yyes )
		self.but_1:SetSize( but_1Wyes, but_1Hyes )
		self.but_1:SetText("Characters")
		self.but_1:SetFont("MetroText")
		self.but_1:SetTextColor(color_white) 
		local buttonsBgColor = Color(182, 182, 182, 100)
		local buttonsHoverColor = Color(52, 137, 128)
		function self.but_1:Paint( w, h )
			surface.SetDrawColor(buttonsBgColor)
			surface.SetMaterial(nut.util.getMaterial("gui/center_gradient"))
			surface.DrawTexturedRect(0, 0, w, h)

			if self:IsDown() then 
			surface.SetDrawColor(buttonsHoverColor)
			surface.SetMaterial(nut.util.getMaterial("gui/center_gradient"))
			surface.DrawTexturedRect(0, 0, w, h)
			elseif self:IsHovered() then 
			surface.SetDrawColor(buttonsHoverColor)
			surface.SetMaterial(nut.util.getMaterial("gui/center_gradient"))
			surface.DrawTexturedRect(0, 0, w, h)
			end
		end
		self.but_1.DoClick = function(client)
			self:Remove()
			vgui.Create("solaireCharacterSelection")
		end


		local but_2Wyes, but_2Hyes = ScrW() * 0.13, ScrH() * 0.045
		local but_2Xyes, but_2Yyes = (ScrW() * 0.663) - (but_2Wyes * 0.5), ScrH() * 0.09



		local but_3Wyes, but_3Hyes = ScrW() * 0.13, ScrH() * 0.045
		local but_3Xyes, but_3Yyes = (ScrW() * 0.84) - (but_3Wyes * 0.5), ScrH() * 0.09

		self.but_3 = self:Add("DButton")
		self.but_3:SetPos( but_3Xyes, but_3Yyes )
		self.but_3:SetSize( but_3Wyes, but_3Hyes )
		self.but_3:SetText("Help")
		self.but_3:SetFont("MetroText")
		self.but_3:SetTextColor(color_white) 
		
		function self.but_3:Paint( w, h )
			surface.SetDrawColor(buttonsBgColor)
			surface.SetMaterial(nut.util.getMaterial("gui/center_gradient"))
			surface.DrawTexturedRect(0, 0, w, h)

			if self:IsDown() then 
			surface.SetDrawColor(buttonsHoverColor)
			surface.SetMaterial(nut.util.getMaterial("gui/center_gradient"))
			surface.DrawTexturedRect(0, 0, w, h)
			elseif self:IsHovered() then 
			surface.SetDrawColor(buttonsHoverColor)
			surface.SetMaterial(nut.util.getMaterial("gui/center_gradient"))
			surface.DrawTexturedRect(0, 0, w, h)
			end
		end
		self.but_3.DoClick = function(client)
			self:Remove()
		end


		local right_panelplusW, right_panelplusH = ScrW() * 0.295, ScrH() * 0.08
		local right_panelplusX, right_panelplusY = (ScrW() * 0.16) - (right_panelplusW * 0.5), ScrH() * 0.02

		self.right_panelplus = self.left_panel:Add("DLabel")
		self.right_panelplus:SetPos( right_panelplusX, right_panelplusY )
		self.right_panelplus:SetSize( right_panelplusW, right_panelplusH )
		self.right_panelplus:SetText("")
		self.right_panelplus:SetFont("DescCharFont1")
		function self.right_panelplus:Paint( w, h )
			surface.SetDrawColor(Color(52, 137, 128))
			surface.SetMaterial(nut.util.getMaterial("gui/center_gradient"))
			surface.DrawTexturedRect(0, 0, w, h)
		end
		
		local timeW, timeH = ScrW() * 0.225, ScrH() * 0.05
		local timeX, timeY = (ScrW() * 0.145) - (timeW * 0.5), ScrH() * 0.008

		self.time = self.right_panelplus:Add("DLabel")
		self.time:SetPos( timeX, timeY )
		self.time:SetSize( timeW, timeH )
		self.time:SetText("")
		self.time:SetFont("DescCharFont1")


		self.model = self.left_panel:Add("nutModelPanel")
		self.model:SetPos(ScrW() * 0.04, ScrH() * 0.03)
		self.model:SetSize(ScrW() * 0.5, ScrH() * 0.7)
		self.model:SetWide(ScrW() * 0.25)
		--self.model.enableHook = false
		--self.model.copyLocalSequence = true
		self.model:SetFOV(44)


		local main_valuesW, main_valuesH = ScrW() * 0.564, ScrH() * 0.03
		local main_valuesX, main_valuesY = (ScrW() * 0.665) - (main_valuesW * 0.5), ScrH() * 0.32

		self.main_values = self:Add("DLabel")
		self.main_values:SetPos( main_valuesX, main_valuesY )
		self.main_values:SetSize( main_valuesW, main_valuesH )
		self.main_values:SetText("Statistics")
		self.main_values:SetFont("MetroText")
		self.main_values:SetTextColor(color_black)
		self.main_values:SetExpensiveShadow(2, Color(52, 137, 128))

		self.first_list = self:Add("DListLayout")
		self.first_list:SetPos( ScrW() * 0.382, ScrH() * 0.36 )
		self.first_list:SetSize( ScrW() * 0.564, ScrH() * 0.33 )

		self.main_values2 = self.first_list:Add("DLabel")
		self.main_values2:Dock(TOP)
		self.main_values2:DockMargin(3, 3, 3, 0)
		self.main_values2:SetTall(ScrH() * 0.032)
		self.main_values2:SetText("General Information")
		self.main_values2:SetFont("MetroText")
		self.main_values2:SetTextColor(Color(255, 255, 255))
		function self.main_values2:Paint( w, h )
			surface.SetDrawColor(Color(52, 137, 128, 100))
			surface.SetMaterial(nut.util.getMaterial("vgui/gradient-l"))
			surface.DrawTexturedRect(0, 0, w, h) 
		end

		self.disc_values = self.first_list:Add("DLabel")
		self.disc_values:Dock(TOP)
		self.disc_values:DockMargin(3, 3, 3, 0)
		self.disc_values:SetTall(ScrH() * 0.032)
		self.disc_values:SetText(L("charFaction", L(team.GetName(LocalPlayer():Team()))))
		self.disc_values:SetFont("dobi4ikxyecockft")
		self.disc_values:SetTextColor(Color(169, 169, 169))
		function self.disc_values:Paint( w, h )
			surface.SetDrawColor(0, 0, 0, 128)
			surface.DrawRect(0, 0, w, h)
		end

		if (!suppress or (suppress and !suppress.all)) then
			if (!suppress or !suppress.desc) then
				self.desc = self.first_list:Add("DTextEntry")
				self.desc:Dock(TOP)
				self.desc:DockMargin(3, 3, 3, 0)
				self.desc:SetTall(ScrH() * 0.032)
				self.desc:SetFont("dobi4ikxyecockft")
				self.desc:SetTextColor(Color(169, 169, 169))
				self.desc.Paint = paintDtextEntry
			end
		end

		self.money_2ez = self.first_list:Add("DLabel")
		self.money_2ez:Dock(TOP)
		self.money_2ez:DockMargin(3, 3, 3, 0)
		self.money_2ez:SetTall(ScrH() * 0.032)
		self.money_2ez:SetText(L("charMoney", nut.currency.get(char:getMoney())))
		self.money_2ez:SetFont("dobi4ikxyecockft")
		self.money_2ez:SetTextColor(Color(169, 169, 169))
		function self.money_2ez:Paint( w, h )
			surface.SetDrawColor(0, 0, 0, 128)
			surface.DrawRect(0, 0, w, h)
		end


        self.information_list = self:Add("DLabel")
		self.information_list:SetPos( ScrW() * 0.382, ScrH() * 0.525 )
		self.information_list:SetSize( ScrW() * 0.564, ScrH() * 0.14 )

		self.information_list:SetText("")
		self.information_list:SetFont("dobi4ikxyecockft")
		self.information_list:SetTextColor(Color(169, 169, 169))
		function self.information_list:Paint( w, h )
			--surface.SetDrawColor(50, 60, 25, 255)
			--surface.DrawRect(0, 0, w, h) 
		end

		self.informationpanel = self.information_list:Add("DLabel")
		self.informationpanel:Dock(TOP)
		self.informationpanel:DockMargin(3, 3, 3, 0)
		self.informationpanel:SetTall(ScrH() * 0.032)
		self.informationpanel:SetText("External Gaming : 1985, New Jersey")
		self.informationpanel:SetFont("MetroText")
		self.informationpanel:SetTextColor(Color(255, 255, 255))
		function self.informationpanel:Paint( w, h )
			surface.SetDrawColor(Color(52, 137, 128, 100))
			surface.SetMaterial(nut.util.getMaterial("vgui/gradient-l"))
			surface.DrawTexturedRect(0, 0, w, h)
		end

		self.informationtext = self.information_list:Add("DLabel")
		self.informationtext:Dock(TOP)
		self.informationtext:DockMargin(3, 3, 3, 0)
		self.informationtext:SetTall(ScrH() * 0.5)
		self.informationtext:SetText("")
		self.informationtext:SetFont("dobi4ikxyecockft")
		self.informationtext:SetTextColor(Color(169, 169, 169))
		function self.informationtext:Paint( w, h )
			surface.SetDrawColor(0, 0, 0, 128)
			surface.DrawRect(0, 0, w, h)
			surface.SetTextPos( 3, 0 ) -- Set text position, top left corner
			surface.SetFont ("InformationTextFont")
			surface.DrawText("The Server takes place in the 1980s of Newark , New Jersey. The damp streets and brick walls are not a true reflection of the beautiful women and the riches inside the 4 walls of ones home.")
			surface.SetTextPos( 3, 15 ) -- Set text position, top left corner
			surface.SetFont ("InformationTextFont")
			surface.DrawText("Become a businessman, make a living in the legal or illegal scene. It is a man or womans free reign here. The streets are filled with figures and finger triggers.")
			surface.SetTextPos( 3, 30 ) -- Set text position, top left corner
			surface.SetFont ("InformationTextFont")
			surface.DrawText("How you spend your time here is up to you. Your roleplay is only limited by your imagination. You could even become a cop and fight crime. Nothing is impossible here.")
			surface.SetTextPos( 3, 45 ) -- Set text position, top left corner
			surface.SetFont ("InformationTextFont")
			surface.DrawText("This is your story, your actions matter and will be taken into account ICly and OOCly.")
		end

		self.discord_list = self:Add("DLabel")
		self.discord_list:SetPos( ScrW() * 0.382, ScrH() * 0.64 )
		self.discord_list:SetSize( ScrW() * 0.564, ScrH() * 0.14 )

		self.discord_list:SetText("")
		self.discord_list:SetFont("dobi4ikxyecockft")
		self.discord_list:SetTextColor(Color(169, 169, 169))
		function self.discord_list:Paint( w, h )
			--surface.SetDrawColor(50, 60, 25, 255)
			--surface.DrawRect(0, 0, w, h) 
		end

		self.discordmessage = self.discord_list:Add("DLabel")
		self.discordmessage:Dock(TOP)
		self.discordmessage:DockMargin(3, 3, 3, 0)
		self.discordmessage:SetTall(ScrH() * 0.032)
		self.discordmessage:SetText("")
		self.discordmessage:SetFont("InformationTextFont2")
		self.discordmessage:SetTextColor(Color(169, 169, 169))
		function self.discordmessage:Paint( w, h )
			surface.SetDrawColor(0, 0, 0, 0)
			surface.DrawRect(0, 0, w, h)
			surface.SetTextPos( 2, 0 ) -- Set text position, top left corner
			surface.SetFont ("InformationTextFont2")
			surface.DrawText("More information can be found at our discord > https://discord.gg/CJ7ThcBAR6")
		end


		local secord_strokaW, secord_strokaH = ScrW() * 0.564, ScrH() * 0.0355
		local secord_strokaX, secord_strokaY = (ScrW() * 0.665) - (secord_strokaW * 0.5), ScrH() * 0.688

		self.second_list = self:Add("DLabel")
		self.second_list:SetPos( ScrW() * 0.382, ScrH() * 0.69 )
		self.second_list:SetSize( ScrW() * 0.564, ScrH() * 0.14 )

		self.second_list:SetText("")
		self.second_list:SetFont("dobi4ikxyecockft")
		self.second_list:SetTextColor(Color(169, 169, 169))
		function self.second_list:Paint( w, h )
			--surface.SetDrawColor(50, 60, 25, 255)
			--surface.DrawRect(0, 0, w, h) 
		end

		self.secord_stroka = self.second_list:Add("DLabel")
		self.secord_stroka:Dock(TOP)
		self.secord_stroka:DockMargin(3, 3, 3, 0)
		self.secord_stroka:SetTall(ScrH() * 0.032)
		self.secord_stroka:SetText("Physical Data")
		self.secord_stroka:SetFont("MetroText")
		self.secord_stroka:SetTextColor(Color(255, 255, 255))
		function self.secord_stroka:Paint( w, h )
			surface.SetDrawColor(Color(52, 137, 128, 100))
			surface.SetMaterial(nut.util.getMaterial("vgui/gradient-l"))
			surface.DrawTexturedRect(0, 0, w, h)
		end

		self.hpmax = self.second_list:Add("DLabel")
		self.hpmax:Dock(TOP)
		self.hpmax:DockMargin(3, 3, 3, 0)
		self.hpmax:SetTall(ScrH() * 0.032)
		self.hpmax:SetText("Health: "..LocalPlayer():Health())
		self.hpmax:SetFont("dobi4ikxyecockft")
		self.hpmax:SetTextColor(Color(169, 169, 169))
		function self.hpmax:Paint( w, h )
			surface.SetDrawColor(0, 0, 0, 128)
			surface.DrawRect(0, 0, w, h)
		end

		self.stamina = self.second_list:Add("DLabel")
		self.stamina:Dock(TOP)
		self.stamina:DockMargin(3, 3, 3, 0)
		self.stamina:SetTall(ScrH() * 0.032)
		self.stamina:SetText("Stamina: "..LocalPlayer():getLocalVar("stm", 0))
		self.stamina:SetFont("dobi4ikxyecockft")
		self.stamina:SetTextColor(Color(169, 169, 169))
		function self.stamina:Paint( w, h )
			surface.SetDrawColor(0, 0, 0, 128)
			surface.DrawRect(0, 0, w, h)
		end
	
		self.speed_run = self.second_list:Add("DLabel")
		self.speed_run:Dock(TOP)
		self.speed_run:DockMargin(3, 3, 3, 0)
		self.speed_run:SetTall(ScrH() * 0.032)
		self.speed_run:SetText("Running Speed: "..LocalPlayer():GetRunSpeed())
		self.speed_run:SetFont("dobi4ikxyecockft")
		self.speed_run:SetTextColor(Color(169, 169, 169))
		function self.speed_run:Paint( w, h )
			surface.SetDrawColor(0, 0, 0, 128)
			surface.DrawRect(0, 0, w, h)
		end

		-------------








		
		self.noAnchor = CurTime() + .4
		self.anchorMode = true
		self:MakePopup()

		self:setup()
		hook.Run("CreateCharInfo", self)
	end

	function PANEL:setup()
		local char = LocalPlayer():getChar()

		if (self.time) then
			local format = "%A, %d %B %Y %X"
			
			self.time:SetText(L("curTime", os.date(format, nut.date.get())))
			self.time.Think = function(this)
				if ((this.nextTime or 0) < CurTime()) then
					this:SetText(L("curTime", os.date(format, nut.date.get())))
					this.nextTime = CurTime() + 0.5
				end
			end
		end

		if (self.desc) then
			self.desc:SetText(char:getDesc())
			self.desc.OnEnter = function(this, w, h)
				nut.command.send("chardesc", this:GetText())
			end
		end

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

	function PANEL:OnKeyCodePressed(key)
		self.noAnchor = CurTime() + .5

		if (key == KEY_F1) then
			self:remove()
		end
	end

	function PANEL:Think()
		local key = input.IsKeyDown(KEY_F1)
		if (LocalPlayer():Alive()) then
		if (key and (self.noAnchor or CurTime()+.4) < CurTime() and self.anchorMode == true) then
			self.anchorMode = false
			surface.PlaySound("buttons/lightswitch2.wav")
		end
		end
	end

	local color_bright = Color(240, 240, 240, 180)

	function PANEL:Paint(w, h)
		--[[nut.util.drawBlur(self, 12)

		surface.SetDrawColor(0, 0, 0)
		surface.SetMaterial(gradient)
		surface.DrawTexturedRect(0, 0, w, h)

		surface.SetDrawColor(30, 30, 30, alpha)
		surface.DrawRect(0, 0, w, 78)

		surface.SetDrawColor(color_bright)
		surface.DrawRect(0, 78, w, 8)]]
	end


	function PANEL:OnRemove()
	end

	function PANEL:remove()
		CloseDermaMenus()
		
		if (!self.closing) then
			self:AlphaTo(0, 0.25, 0, function()
				self:Remove()
			end)
			self.closing = true
		end
	end

vgui.Register("nutMenu", PANEL, "EditablePanel")

if (IsValid(nut.gui.menu)) then
	vgui.Create("nutMenu")
end