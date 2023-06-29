
local PANEL = {}
	local gradient = surface.GetTextureID("vgui/gradient-u")
	local gradient2 = surface.GetTextureID("vgui/gradient-d")

	function PANEL:Init()
		local fadeSpeed = 1

		if (IsValid(nut.gui.loading)) then
			nut.gui.loading:Remove()
		end

		if (!nut.localData.intro) then
			timer.Simple(0.1, function()
				vgui.Create("nutIntro", self)
			end)
		else
			self:playMusic()
		end

		if (IsValid(nut.gui.char) or (LocalPlayer().getChar and LocalPlayer():getChar())) then
			nut.gui.char:Remove()
			fadeSpeed = 0
		end

		nut.gui.char = self



		self:SetSize(ScrW(),ScrH())
		self:MakePopup()
		self:Center()
		self:ParentToHUD()


		self.darkness = self:Add("DPanel")
		self.darkness:Dock(FILL)
		self.darkness.Paint = function(this, w, h)
			surface.SetDrawColor(0, 0, 0)
			surface.DrawRect(0, 0, w, h)
		end
		self.darkness:SetZPos(99)
    self.darkness:AlphaTo(0, fadeSpeed, 0, function()
      self.darkness:SetZPos(-1)
    end)





		local curTab
		local buts = {}
		buts["character"] = {
			index = 1,
			open = function()
				self:Remove()
				vgui.Create("solaireCharacterSelection")
				--[[local accessableFactions = {}
				for k,v in pairs(nut.faction.indices) do
					if v.isDefault == true then
						accessableFactions[#accessableFactions+1] = k
					end
				end

				--Fade out side panel
				self.titlePanel:AlphaTo(0, 0.2)

				--Creating main panel (work panel)
				local wp = self:Add("DPanel")
				wp:SetSize(ScrW()-800, ScrH()-400)
				wp:CenterVertical()
				wp:Center()
				wp:SetAlpha(0)
				wp:AlphaTo(255,0.5,0.2)
				function wp.Close(this)
					if self.titlePanel and IsValid(self.titlePanel) then
            self.titlePanel:RefreshTabs()
						self.titlePanel:AlphaTo(255,0.2)
					end

					this:Remove()
				end
				function wp:Paint(w,h)
					nut.util.drawBlur(self, 4)
					draw.RoundedBox(4,0,0,w,h,Color(60, 60, 60, 50))
				end

				--The main center title
				wp.title = wp:Add("DLabel")
				wp.title:SetText("CHOOSE A FACTION")
				wp.title:SetFont("faction_title")
				wp.title:SetColor(Color(244, 119, 66))
				wp.title:SizeToContents()
				wp.title:SetPos(0,20)
				wp.title:CenterHorizontal()

				--Cancel button
				wp.cancel = wp:Add("DButton")
				wp.cancel:SetSize(wp:GetWide(),40)
				wp.cancel:SetPos(0,wp:GetTall()-wp.cancel:GetTall())
				wp.cancel:SetText("Cancel")
				wp.cancel:SetFont("nutSmallFont")
				wp.cancel:SetTextColor(color_white)
				function wp.cancel:DoClick()
					wp:AlphaTo(0,0.2,0,function()
						wp:Close()
					end)
				end
				function wp.cancel:Paint(w,h)
					if self:IsHovered() then
						draw.RoundedBoxEx(4,0,0,w,h,Color(235,85,85),false,false,true,true)
					else
						draw.RoundedBoxEx(4,0,0,w,h,Color(225,75,75),false,false,true,true)
					end
				end

				local limitDisplayCount
				if #accessableFactions > 3 then
					limitDisplayCount = 3
				end

				--Faction list layout
				wp.scroll = wp:Add("DScrollPanel")
				if limitDisplayCount ~= nil then
					wp.scroll:SetSize(500, 160*limitDisplayCount)
				else
					wp.scroll:SetSize(500, 160*#accessableFactions)
				end
				wp.scroll:Center()
				wp.hs = wp.scroll:Add("DListLayout")
				wp.hs:SetSize(wp.scroll:GetWide()-10, wp.scroll:GetTall()-10)

				--Drawing factions
				for k,v in pairs(accessableFactions) do
					local fac = nut.faction.indices[v]
					local f = wp.hs:Add("DButton")
					f:SetSize(wp.hs:GetWide(),wp.hs:GetTall()/2)
					f:SetText(fac.name)
					f:SetFont("faction_names")
					f:SetColor(color_white)
					function f:Paint(w,h)
						-- surface.SetDrawColor(fac.color)
						-- surface.DrawRect(0, 0, w, h)
						if self:IsHovered() then
							self:SetColor(fac.color)
						else
							self:SetColor(color_white)
						end
					end

					function f.DoClick(this)
						wp.hs:AlphaTo(0,0.5,0,function()
							wp.hs:Remove()

							wp:AlphaTo(0,0.5,0,function()
								wp:SetVisible(false)
							end)
							self.creation = self:Add("nutCharCreate")
							self.creation:setUp(v)
							self.creation:SetAlpha(0)
							self.creation:AlphaTo(255,0.2,0.5)
							self.creation:SetSize(self.creation:GetWide()+20,self.creation:GetTall()+50)
							self.creation:SetPos(0,self:GetTall()/2-self.creation:GetTall()/2-15)
							self.creation:CenterHorizontal()

							self.cancel = self:Add("DButton")
							self.cancel:SetPos(30,30)
							self.cancel:SetSize(120,40)
							self.cancel:SetText("Cancel")
							self.cancel:SetTextColor(color_white)
							function self.cancel:Paint(w,h)
								if self:IsHovered() then
									draw.RoundedBox(4, 0, 0, w, h, Color(225, 75, 75))
								else
									draw.RoundedBox(4, 0, 0, w, h, Color(215, 65, 65))
								end
							end
							function self.cancel.DoClick(this)
								this:AlphaTo(0,0.2)
								self.finish:AlphaTo(0,0.2)
								self.creation:AlphaTo(0,0.5,0,function()
									self.creation:Remove()
									self.finish:Remove()
									wp:Close()
								end)
							end

							local x,y = self.creation:GetPos()
							self.finish = self:Add("DButton")
							self.finish:SetText("Finish")
							self.finish:SetColor(color_white)
							self.finish:SetSize(self.creation:GetWide(), 30)
							self.finish:SetPos(x,y+self.creation:GetTall())
							self.finish:SetAlpha(0)
							self.finish:AlphaTo(255,0.2,0.5)
							function self.finish:Paint(w,h)
								if self:IsHovered() then
									draw.RoundedBoxEx(4,0,0,w,h,Color(68, 166, 255),false,false,true,true)
								else
									draw.RoundedBoxEx(4,0,0,w,h,Color(58, 156, 255),false,false,true,true)
								end
							end
							function self.finish.DoClick(this)
								if (!self.creation.creating) then
									local payload = {}

									--Verifying character variables
									for k, v in SortedPairsByMemberValue(nut.char.vars, "index") do
										local value = self.creation.payload[k]

										if (!v.noDisplay or v.onValidate) then
											if (v.onValidate) then
												local result = {v.onValidate(value, self.creation.payload, LocalPlayer())}

												if (result[1] == false) then
													self.creation.notice:setType(1)
													self.creation.notice:setText(L(unpack(result, 2)).."!")

													return
												end
											end

											payload[k] = value
										end
									end

									--Updating creation panel notice
									self.creation.notice:setType(6)
									self.creation.notice:setText(L"creating")
									self.creation.creating = true
									self.finish:AlphaTo(0, 0.5, 0)

									netstream.Hook("charAuthed", function(fault, ...)
										timer.Remove("nutCharTimeout")

										if (type(fault) == "string") then
											self.creation.notice:setType(1)
											self.creation.notice:setText(L(fault, ...))
											self.creation.creating = nil
											self.finish:AlphaTo(255, 0.5, 0)

											return
										end

										if (type(fault) == "table") then
											nut.characters = fault
										end

										self.cancel:AlphaTo(0,0.5,0,function()
											self.cancel:Remove()
										end)
										self.creation:AlphaTo(0,0.5,0,function()
											self.creation:Remove()
											wp:Close()
										end)
									end)

									timer.Create("nutCharTimeout", 20, 1, function()
										if (IsValid(self.creation) and self.creation.creating) then
											self.creation.notice:setType(1)
											self.creation.notice:setText(L"unknownError")
											self.creation.creating = nil
											self.finish:AlphaTo(255, 0.5, 0)
										end
									end)

									netstream.Start("charCreate", payload)
								end
							end
						end)
					end
				end--]]
			end
		}
		--[[buts["load"] = {
			index = 2,
			open = function()
				self:Remove()
				vgui.Create("solaireCharacterSelection")
			end,
			canShow = function()
		        if self.cl and IsValid(self.cl) then
		          return table.Count(self.cl:GetChildren()) > 0
		        else
		          return table.Count(nut.characters) > 0
		        end
		    end,--]]
			--[[
			open = function()
				--Character view
				self.charView = self:Add("DPanel")
				self.charView:SetSize(450,self:GetTall()-500)
				self.charView:SetPos(150, 20)
				self.charView.gradientColor = nil
				function self.charView:Paint(w,h)
					nut.util.drawBlur(self, 4) --Drawing background
					surface.SetDrawColor(60,60,60,50)
					surface.DrawRect(0,0,w,h)

					--Drawing gradient
					if self.gradientColor then
						surface.SetDrawColor(self.gradientColor.r,self.gradientColor.g,self.gradientColor.b, 50)
						surface.SetTexture(gradient)
						surface.DrawTexturedRect(0,0,w,h/2)
					end
				end

				--Character model
				local curChar = nut.characters[1]
				self.charView.mdl = self.charView:Add("nutModelPanel")
				self.charView.mdl:SetSize(self.charView:GetSize())
				self.charView.mdl:SetFOV(60)
				function self.charView.mdl:Think()
					if not curChar then return end
					local char = nut.char.loaded[curChar]
					self:SetModel(char:getModel())

					local parent = self:GetParent()
					parent.gradientColor = nut.faction.indices[char:getFaction()].color
				end

				--Fading things
				self.charView.mdl:SetAlpha(0)
				self.charView.mdl:AlphaTo(255,0.3)
				self.charView:SetAlpha(0)
				self.charView:AlphaTo(255,0.3)

				--Choose
				self.charView.choose = self.charView:Add("DButton")
				self.charView.choose:SetSize(self.charView:GetWide()/2,40)
				self.charView.choose:SetPos(0,self.charView:GetTall()-self.charView.choose:GetTall())
				self.charView.choose:SetText("CHOOSE")
				self.charView.choose:SetFont("mm_options")
				self.charView.choose:SetTextColor(color_white)
				function self.charView.choose:Paint(w,h)
					if self:IsHovered() then
						draw.RoundedBox(0,0,0,w,h,Color(85, 173, 210))
					else
						draw.RoundedBox(0,0,0,w,h,Color(75, 163, 200))
					end
				end
				function self.charView.choose.DoClick(this)
					if LocalPlayer():getChar() and LocalPlayer():getChar():getID() == curChar then
						nut.util.notify("You're already using this character", LocalPlayer())
						return
					end

					self.darkness:SetZPos(99)
					self.darkness:AlphaTo(255,0.5,0,function()
						self:Remove()
						local dark = vgui.Create("DPanel")
						dark:SetSize(ScrW(),ScrH())
						dark:Center()
						function dark:Paint(w,h)
							surface.SetDrawColor(0,0,0)
							surface.DrawRect(0,0,w,h)
						end

						netstream.Start("charChoose", curChar)

						dark:AlphaTo(0,0.5,1,function()
							dark:Remove()
						end)
					end)
				end

				--Remove
				self.charView.rem = self.charView:Add("DButton")
				self.charView.rem:SetSize(self.charView:GetWide()/2,40)
				self.charView.rem:SetPos(self.charView:GetWide()/2,self.charView:GetTall()-self.charView.rem:GetTall())
				self.charView.rem:SetText("REMOVE")
				self.charView.rem:SetFont("mm_options")
				self.charView.rem:SetTextColor(color_white)
				function self.charView.rem:Paint(w,h)
					if self:IsHovered() then
						draw.RoundedBox(0,0,0,w,h,Color(235,85,85))
					else
						draw.RoundedBox(0,0,0,w,h,Color(225,75,75))
					end
				end
				function self.charView.rem.DoClick(this)
					local char = nut.char.loaded[curChar]
					local menu = DermaMenu()
						local confirm = menu:AddSubMenu(L("delConfirm", char:getName()))
						confirm:AddOption(L"no"):SetImage("icon16/cross.png")
						confirm:AddOption(L"yes", function()
							netstream.Start("charDel", char:getID()) --TODO Uncomment this (debug)
							table.remove(nut.characters, curChar)
              print(#nut.characters)
							if #nut.characters == 1 or #self.cl:GetChildren() == 1 then
								buts["load"].close()
							end

							local cco = nut.char.loaded[curChar]
							for k,v in pairs(self.cl:GetChildren()) do
								if v.charObj:getName() == cco:getName() then
									v:Remove()
									char.removed = true
								end
							end

							curChar = nut.characters[1]
						end):SetImage("icon16/tick.png")
					menu:Open()
				end

				--Character list
				self.cl = self:Add("DListLayout")
				self.cl:SetSize(200,35*#nut.characters)
				self.cl:SetPos(960,100)
				function self.cl:Paint(w,h)
					nut.util.drawBlur(self, 4)
					surface.SetDrawColor(60,60,60,50)
					surface.DrawRect(0,0,w,h)
				end

				function self.cl.DisplayList(this)
					this:Clear()
					for k,v in pairs(nut.characters) do
						local char = nut.char.loaded[v]
						local c = this:Add("DButton")
						c:SetText(char:getName())
						c:SetFont("character_name")
						c:SetColor(color_white)
						c.charObj = char
						local nutCol = nut.config.get("color")
						if curChar == v then c:SetColor(nutCol) end
						function c:Paint(w,h)
							if self:IsHovered() or curChar == v then
								self:SetColor(nutCol)
							else
								self:SetColor(color_white)
							end
						end
						function c.DoClick(this)
							curChar = v

							for _,b in pairs(this:GetChildren()) do
								b:SetColor(color_white)
							end
						end
					end
				end

				self.cl:DisplayList()
			end,
      canShow = function()
        if self.cl and IsValid(self.cl) then
          return table.Count(self.cl:GetChildren()) > 0
        else
          return table.Count(nut.characters) > 0
        end
      end,
			close = function()
				if self.charView then self.charView:Remove() end
				if self.cl then self.cl:Remove() end
			end--]]
		--}
		buts["content"] = {
			index = 3,
			open = function()
				gui.OpenURL(MAINMENUSETTINGS.contentURL)
			end
		}
	    buts["discord"] = {
			index = 4,
			open = function()
				gui.OpenURL(MAINMENUSETTINGS.discordURL)
			end
		}
		buts["steam group"] = {
			index = 5,
			open = function()
				gui.OpenURL(MAINMENUSETTINGS.groupURL)
			end
		}
		buts["quit"] = {
			index = 6,
			open = function()
				self.darkness:SetZPos(99)
				self.darkness:SetAlpha(0)
				self.darkness:AlphaTo(255, 0.5, 0, function()
					RunConsoleCommand("disconnect")
				end)
			end
		}

    --Display return button if player comes from Tab menu
		if LocalPlayer().getChar and LocalPlayer():getChar() then
			buts["quit"] = nil
			buts["return"] = {
				index = 6,
				open = function()
					self:AlphaTo(0,0.4,2,function()
						self:Remove()
					end)
				end
			}
		end

		local iw,ih,iy = 450,450,20

		self.backgroundimg = Material("ex/mainmenu.png", "mips")
		function self:Paint(w,h)
			--Background draw
			surface.DrawTexturedRect(0, 0, w, h)
			surface.SetDrawColor(color_white)
			surface.SetMaterial(self.backgroundimg)
			surface.DrawTexturedRect(0, 0, w, h)
			surface.SetDrawColor(0, 0, 0, 235)
            surface.SetMaterial(nut.util.getMaterial("nutscript/gui/vignette.png"))
            surface.DrawTexturedRect(0, 0, w, h)
		end



		self.titlePanel = self:Add("DPanel")
		self.titlePanel:SetSize(iw, self:GetTall())
		self.titlePanel:SetPos(self:GetWide()-self.titlePanel:GetWide(),0)

    function self.titlePanel:RefreshTabs()
      self:DisplayTabs()
    end


		self.list = self.titlePanel:Add("DListLayout")
		self.list:Dock(FILL)
		self.list:DockMargin(0,(iy + ih)*.75, 0, 0)
		//self.list:SetSize(self.titlePanel:GetWide(),self:GetTall() - (iy + ih) - 10)
		//self.list:SetPos(self.titlePanel:GetWide()-self.list:GetWide()*1.5,(iy + ih) + 10)
		function self.titlePanel.DisplayTabs(this)
      self.list:Clear()
      for k,v in SortedPairsByMemberValue(buts, "index") do
        if v.canShow and not v.canShow() then continue end
  			local b = self.list:Add("DButton")
  			b:SetSize(self.list:GetWide(), 30)
  			b:SetText(k:upper())
  			b:SetFont("MySuperFont")
			b:SizeToContents()
  			b:SetColor(Color(0,0,0,0))
  			b:SetTextColor(color_white)
  			function b:Paint(w,h)
  				if self:IsHovered() or curTab == k then
  					self:SetTextColor(ExternalColors.Asbest)
  				else
  					self:SetTextColor(color_white)
  				end
  			end
  			function b:DoClick()
  				if curTab ~= nil then
  					if buts[curTab].close then buts[curTab].close() end
  				end

  				curTab = k
  				v.open()
  			end
  		end
    end

    self.titlePanel:DisplayTabs()
	end

	function PANEL:Think()
		if self.anim and self.anim:Active() then
			self.anim:Run()
		end
	end

	function PANEL:OnKeyCodePressed(key)
		if key == KEY_TAB and LocalPlayer():getChar() then
			self:Remove()
		end
	end

	function PANEL:playMusic()
		if (nut.menuMusic) then
			nut.menuMusic:Stop()
			nut.menuMusic = nil
		end

		timer.Remove("nutMusicFader")

		local source = "ex/mainmenu.mp3"

		
			local function callback(music, errorID, fault)
				if (music) then
					music:SetVolume(0.6)
					print("music menu,",music)
					nut.menuMusic = music
					nut.menuMusic:Play()
				else
					MsgC(Color(255, 50, 50), errorID.." ")
					MsgC(color_white, fault.."\n")
				end
			end
			sound.PlayFile("sound/"..source, "noplay", callback)
	

		for k, v in ipairs(engine.GetAddons()) do
			if (v.wsid == "207739713" and v.mounted) then
				return
			end
		end

		Derma_Query(L"contentWarning", L"contentTitle", L"yes", function()
			gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/?id=207739713")
		end, L"no")
	end

	function PANEL:OnRemove()
		if self.csent ~= nil then self.csent:Remove() end
		if (nut.menuMusic) then
			local fraction = 1
			local start, finish = RealTime(), RealTime() + 10

			timer.Create("nutMusicFader", 0.1, 0, function()
				if (nut.menuMusic) then
          			if not (nut.menuMusic) then return end
					fraction = 1 - math.TimeFraction(start, finish, RealTime())
					

					if (fraction <= 0) then
						nut.menuMusic:Stop()
						nut.menuMusic = nil

						timer.Remove("nutMusicFader")
					end
				else
					timer.Remove("nutMusicFader")
				end
			end)
		end
	end
vgui.Register("nutCharMenu", PANEL, "EditablePanel")

