--Keypad
local keys = {
	["1"] = {1, KEY_1, KEY_PAD_1},
	["2"] = {2, KEY_2, KEY_PAD_2},
	["3"] = {3, KEY_3, KEY_PAD_3},
	["4"] = {4, KEY_4, KEY_PAD_4},
	["5"] = {5, KEY_5, KEY_PAD_5},
	["6"] = {6, KEY_6, KEY_PAD_6},
	["7"] = {7, KEY_7, KEY_PAD_7},
	["8"] = {8, KEY_8, KEY_PAD_8},
	["9"] = {9, KEY_9, KEY_PAD_9},
	["-"] = {10},
	["0"] = {11, KEY_0, KEY_PAD_0},
	["<CALL>"] = {12}
}

--Setting the data file path
local path = "nutscript/" .. SCHEMA.folder .. "/saved_numbers.dat"

local savedNumbersTbl = util.JSONToTable(file.Read(path) or "{}") or {}

local function openDialer(telent)
	local beingCalled = telent:getNetVar("ringing")

	local frame = vgui.Create("DFrame")
	frame:SetSize(ScrW()-750, ScrH()-300)
	frame:MakePopup()
	frame:SetTitle("")
	frame:Center()
	frame:SetAlpha(0)
	frame:AlphaTo(255, 0.3)
	frame:ShowCloseButton(false)
	frame.dialNum = ""
	frame.preventClose = false
	function frame:Paint(w,h)
		nut.util.drawBlur(self,4)
		surface.SetDrawColor(30,30,30,200)
		surface.DrawRect(0, 0, w, h)
	end
	function frame:Think()
		self:Center()
	end
	function frame:OnKeyCodePressed(key)
		for k,v in pairs(keys) do
			if key == v[2] or key == v[3] then
				self:AddNumber(k)
			end
		end

		--Allow for correcting dial number.
		if key == KEY_BACKSPACE then
			self.dialNum = self.dialNum:sub(1,-2)
		end

		if key == KEY_F1 then
			if LocalPlayer():IsSuperAdmin() then self:Remove() end
		end
	end

	frame.close = frame:Add("DButton")
	frame.close:SetSize(50,25)
	frame.close:SetText("x")
	frame.close:SetColor(color_white)
	frame.close:SetPos(frame:GetWide()-frame.close:GetWide(), 0)
	frame.close.color = Color(225, 75, 75)
	function frame.close:Paint(w,h)
		surface.SetDrawColor(self.color)

		if self:GetDisabled() then
			surface.SetDrawColor(146, 146, 146, 255)
		end

		surface.DrawRect(0,0,w,h)
	end
	function frame.close:SetColor(col) self.color = col end
	function frame.close:GetColor() return self.color end
	function frame.close:OnCursorEntered()
		if self:GetDisabled() then return end
		self:ColorTo(Color(235,85,95), 0.2, 0)
	end
	function frame.close:OnCursorExited()
		if self:GetDisabled() then return end
		self:ColorTo(Color(225, 75, 75), 0.2, 0)
	end
	function frame.close:DoClick()
		frame:SizeTo(0,0,0.2,0,-0.1, function()
			frame:Remove()
		end)
	end

	frame.hint = frame:Add("DButton")
	frame.hint:SetFont("nutSmallFont")
	frame.hint:SetText("This phone's number is " .. telent:getNetVar("number") .. " (click to copy)")
	frame.hint:SetColor(color_white)
	frame.hint:SizeToContents()
	frame.hint:SetAlpha(0)
	function frame.hint:PerformLayout(w,h)
		self:SizeToContents()
		self:SetPos(0, 25/2-h/2)
		self:CenterHorizontal()
	end
	function frame.hint:Paint(w,h) end
	function frame.hint:DoClick()
		SetClipboardText(telent:getNetVar("number"))
		LocalPlayer():notify("Phone number copied", NOT_CORRECT)
	end
	
	local function createActionButton()
		local acb = frame:Add("DButton")
		acb:SetSize(150,45)
		acb:SetText("ACTION BUTTON")
		acb:SetFont("nutSmallFont")
		acb:SetColor(color_white)
		function acb:Paint(w,h)
			if self:IsHovered() then
				surface.SetDrawColor(235,85,85)
			else
				surface.SetDrawColor(225,75,75)
			end

			surface.DrawRect(0,0,w,h)
		end

		return acb
	end

	local function pushAway()
		frame.keypad:MoveTo(-frame.keypad:GetWide(), 25, 0.5, 0, 0.5)
		frame.savedNums:MoveTo(frame:GetWide(),frame.savedNums:GetY(), 0.5, 0, 0.5)
		
		frame.hint:AlphaTo(0,0.2,0,function()
			frame.hint:SetVisible(false)
		end)
	end
	local function pullBack()
		if not frame.keypad or not IsValid(frame.keypad) then return end
		frame.keypad:MoveTo(0, 25, 0.5, 0, 0.5)
		frame.savedNums:MoveTo(frame:GetWide()-frame.savedNums:GetWide(),frame.savedNums:GetY(), 0.5, 0, 0.5)
		
		if frame.hint and IsValid(frame.hint) then
			frame.hint:SetVisible(true)
			frame.hint:AlphaTo(255,0.2,0)
		end
	end
	
	function frame:Compose(num, conName)
		local foundNum = false
		for k,v in pairs(GetAllPhoneNumbers()) do
			if k == telent:getNetVar("number") then continue end
			if k == num then
				netstream.Start("startPhoneCall", telent, num) --Start call
				foundNum = v
				
				--Little trick for testing
				if LocalPlayer():IsSuperAdmin() and input.IsKeyDown(KEY_LCONTROL) then
					self:SetKeyboardInputEnabled(true)
				else
					self:SetKeyboardInputEnabled(false)
				end

				break
			end
		end

		--Phone couldn't be found
		if not foundNum then
			nut.util.notify("Number couldn't be found.", 3) --Error message
		end
		
		--Phone found, checking if used.
		if foundNum and not foundNum:getNetVar("ringing", false) then
			pushAway()

			frame.close:SetEnabled(false) --Disable close button for mass-fix ;)

			local cp = {}
			timer.Simple(0.8, function()
				if not frame or not IsValid(frame) then return end
				cp.name = frame:Add("DLabel")
				cp.name:SetText("Calling " .. num)
				cp.name:SetFont("nutMediumFont")
				cp.name:SetColor(color_white)
				cp.name:SetAlpha(0)
				cp.name:AlphaTo(255,0.3)
				function cp.name:PerformLayout()
					self:SizeToContents()
					self:CenterHorizontal()
					self:CenterVertical(0.2)
				end

				cp.dots = frame:Add("DPanel")
				cp.dots:SetSize(20*3 + 30, 25)
				cp.dots:Center()
				cp.dots:SetAlpha(0)
				cp.dots:AlphaTo(255, 0.2, 0)
				local rad = 7
				function cp.dots:Paint(w,h)
					draw.NoTexture()

					local function getAlpha(x)
						return ((1+math.cos(x))*255)/2
					end

					surface.SetDrawColor(255,255,255,getAlpha(5*CurTime()+1)) --Left
					draw.Circle(w/2-rad*2-5,h/2,rad,360)

					surface.SetDrawColor(255,255,255,getAlpha(5*CurTime()+0.5)) --Center
					draw.Circle(w/2,h/2,rad,360)

					surface.SetDrawColor(255,255,255,getAlpha(5*CurTime())) --Right
					draw.Circle(w/2+rad*2+5,h/2,rad,360)
				end
				
				--Caller hangup btn
				local hangup = createActionButton()
				hangup:SetText("Hangup")
				hangup:CenterHorizontal()
				hangup:CenterVertical(0.8)
				function hangup:DoClick()
					--Fading all the other panels
					cp.name:AlphaTo(0,0.2)
					if cp.dots and IsValid(cp.dots) then
						cp.dots:AlphaTo(0,0.2)
					end
					self:AlphaTo(0,0.2,0,function()
						cp.name:Remove()
						cp.dots:Remove()
						self:Remove()
						pullBack()

						frame.close:SetDisabled(false) --Re-enabling close button
					end)
					
					--Re-enabling keyboard input
					frame:SetKeyboardInputEnabled(true)

					--Update recipient
					netstream.Start("updateCallCaller", {
						update = "hangup",
						num = num,
						phone = telent
					})
				end
				
				--Caller updates
				netstream.Hook("updateCallListener", function(data)
					if not frame and not IsValid(frame) then return end
					if data.update == "hangup" then
						--Removing necessary panels
						if cp.dots and IsValid(cp.dots) then
							cp.dots:Remove()	
						end
						if cp.name and IsValid(cp.name) then
							cp.name:AlphaTo(0,0.2,0,function()
								cp.name:Remove()
							end)
						end
						if hangup and IsValid(hangup) then
							hangup:AlphaTo(0,0.2,0,function()
								hangup:Remove()
							end)
						end

						pullBack()
						frame:SetKeyboardInputEnabled(true)
						frame.close:SetDisabled(false)
					end

					if data.update == "respond" then
						cp.name:SetText("Recipient is hearing you...")
						cp.name:SizeToContents()
						frame:SetKeyboardInputEnabled(false)
						cp.dots:Remove()
					end
				end)
			end)
		end
	end

	--Add a number to dial
	function frame:AddNumber(n)
		if #self.dialNum == 10 then return end --If number is already 10 in lenght then stop.

		self.dialNum = self.dialNum .. n
	end

	--Number display
	frame.keypad = frame:Add("DPanel")
	frame.keypad:SetSize(frame:GetWide()/2, frame:GetTall()-25)
	frame.keypad:SetPos(0,25)

	--Reposition keypad if the phone is being called or not
	if beingCalled then
		frame.keypad:SetPos(-frame.keypad:GetWide(),25)
	end

	frame.keypad.numdis = frame.keypad:Add("DPanel") --The number display
	frame.keypad.numdis:SetSize(frame.keypad:GetWide()-2, 80)
	frame.keypad.numdis:SetPos(0,0)
	function frame.keypad.numdis:Paint(w,h)
		surface.SetDrawColor(45, 45, 45)
		surface.DrawRect(0, 0, w, h)
	end

	frame.keypad.numdis.lbl = frame.keypad.numdis:Add("DLabel") --Display label
	frame.keypad.numdis.lbl:SetFont("nutMediumFont")
	frame.keypad.numdis.lbl:SetColor(color_white)
	function frame.keypad.numdis.lbl:Think()
		self:SetText(frame.dialNum or "")

		self:SizeToContents()
		self:Center()
	end

	--Keypad
	local scroll = frame.keypad:Add("DScrollPanel")
	scroll:SetSize(frame.keypad:GetWide(), frame.keypad:GetTall()-frame.keypad.numdis:GetTall())
	scroll:SetPos(0,frame.keypad.numdis:GetTall())
	local list = scroll:Add("DIconLayout")
	list:SetSize(scroll:GetWide(), scroll:GetTall())

	for k,v in SortedPairsByMemberValue(keys, 1) do
		local key = list:Add("DButton")
		key:SetSize(list:GetWide()/3, list:GetTall()/4)
		key:SetText(k:Replace("-",""))
		key:SetFont("nutMediumFont")
		key:SetColor(color_white)
		if k == "<CALL>" then
			key:SetFont("wolficon_big")
			key:SetText(ICON:GetIconChar("phone"))
			frame.callButton = key
		end
		function key:Paint(w,h)
			if self:IsHovered() then
				draw.RoundedBox(0,0,0,w,h,Color(40,40,40))
			else
				draw.RoundedBox(0,0,0,w,h,Color(35,35,35))
			end
		end
		function key:DoClick()
			if not k:find("-") then
				frame:AddNumber(k)
			end
		end
	end

	function frame.callButton:DoClick()
		if #frame.dialNum == 10 then
			local conName
			for k,v in pairs(savedNumbersTbl) do
				if v.number == frame.dialNum then
					conName = v.name
				end
			end

			frame:Compose(frame.dialNum, conName or nil)
		end
	end

	--Saved numbers
	frame.savedNums = frame:Add("DPanel")
	frame.savedNums:SetSize(frame:GetWide()/2,frame:GetTall()-25)
	frame.savedNums:SetPos(frame:GetWide(),25)

	if not beingCalled then
		frame.savedNums:MoveTo(frame:GetWide()/2, 25, 0.3, 0.4, 0.5, function()
			if frame.hint and IsValid(frame.hint) then
				frame.hint:AlphaTo(255, 0.2)
			end
		end)
	end
	function frame.savedNums:Paint(w,h)
		surface.SetDrawColor(33,33,33)
		surface.DrawRect(0, 0, w, h)
	end

	local function NewNumberForm()
		local newNum = frame.savedNums:Add("DPanel")
		newNum:SetSize(frame.savedNums:GetWide(), 200)
		newNum:SetPos(0,frame.savedNums:GetTall())
		newNum:MoveTo(0,frame.savedNums:GetTall()-newNum:GetTall(),0.3,0,0.5)
		function newNum:Paint(w,h)
			surface.SetDrawColor(40,40,40)
			surface.DrawRect(0,0,w,h)
		end

		local function addTEHandle(te)
			function te:Think()
				local txt = self:GetText()
				if not self:IsEditing() then
					if txt == "" then
						self:SetText(self.placeholder)
					end
				elseif self:IsEditing() and txt == self.placeholder then
					self:SetText("")
				end
			end

			function te:IsEmpty()
				local val = self:GetText()
				if val == "" or not val or val == self.placeholder then
					return true
				else
					return false
				end
			end
		end

		--The 2 required text entries
		newNum.name = newNum:Add("DTextEntry")
		newNum.name:SetSize(newNum:GetWide()-200, 30)
		newNum.name.placeholder = "Name"
		newNum.name:SetText(newNum.name.placeholder)
		newNum.name:SetPos(0,30)
		newNum.name:CenterHorizontal()
		local nutcol = nut.config.get("color")
		function newNum.name:Paint(w,h)
			if self:IsEditing() then
				draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255))
			else
				draw.RoundedBox(4, 0, 0, w, h, Color(220,220,220))
			end
			self:DrawTextEntryText(Color(0,0,0), nutcol, Color(0,0,0))
		end
		addTEHandle(newNum.name)

		newNum.number = newNum:Add("DTextEntry")
		newNum.number:SetSize(newNum:GetWide()-200, 30)
		newNum.number.placeholder = "Number"
		newNum.number:SetText(newNum.number.placeholder)
		newNum.number:SetPos(0,70)
		newNum.number:CenterHorizontal()
		newNum.number:SetNumeric(true)
		local nutcol = nut.config.get("color")
		function newNum.number:Paint(w,h)
			if self:IsEditing() then
				draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255))
			else
				draw.RoundedBox(4, 0, 0, w, h, Color(220,220,220))
			end
			self:DrawTextEntryText(Color(0,0,0), nutcol, Color(0,0,0))
		end
		addTEHandle(newNum.number)

		--Finish button
		newNum.finish = newNum:Add("DButton")
		newNum.finish:SetSize(newNum:GetWide(),40)
		newNum.finish:SetPos(0,newNum:GetTall()-newNum.finish:GetTall())
		newNum.finish:SetText("Close")
		newNum.finish:SetColor(color_white)
		function newNum.finish:Paint(w,h)
			if self:IsHovered() then
				surface.SetDrawColor(37, 37, 37)
			else
				surface.SetDrawColor(35, 35, 35)
			end
			surface.DrawRect(0, 0, w, h)
		end
		function newNum.finish:Think()
			if not newNum.name:IsEmpty() and not newNum.number:IsEmpty() and #newNum.number:GetText() == 10 then
				self:SetText("Finish")
			else
				self:SetText("Quit")
			end
		end
		function newNum.finish:DoClick()
			if self:GetText() == "Finish" then
				local f = util.JSONToTable(file.Read(path) or "{}") or {}
				f[#f+1] = {
					name = newNum.name:GetText(),
					number = newNum.number:GetText()
				}
				file.Write(path, util.TableToJSON(f, true))

				savedNumbersTbl = f --Updating cached table
				frame.savedNums:DisplayList() --Update list
			end

			newNum:MoveTo(newNum:GetX(), frame.savedNums:GetTall(), 0.2, 0, 0.5, function()
				newNum:Remove()
			end)
		end
	end

	--Controls
	local controlHeight = 50
	frame.savedNums.addNum = frame.savedNums:Add("DButton")
	frame.savedNums.addNum:SetText("+")
	frame.savedNums.addNum:SetFont("nutMediumFont")
	frame.savedNums.addNum:SetColor(color_white)
	frame.savedNums.addNum:SetSize(frame.savedNums:GetWide()/2,controlHeight)
	frame.savedNums.addNum:SetPos(0,frame.savedNums:GetTall()-frame.savedNums.addNum:GetTall())
	function frame.savedNums.addNum:Paint(w,h)
		if self:IsHovered() then
			surface.SetDrawColor(75, 225, 75)
		else
			surface.SetDrawColor(65, 215, 65)
		end

		surface.DrawRect(0,0,w,h)
	end
	function frame.savedNums.addNum:DoClick()
		NewNumberForm()
	end

	local selNum
	frame.savedNums.remNum = frame.savedNums:Add("DButton")
	frame.savedNums.remNum:SetEnabled(false)
	frame.savedNums.remNum:SetFont("wolficon_normal")
	frame.savedNums.remNum:SetText(ICON:GetIconChar("trash"))
	frame.savedNums.remNum:SetColor(color_white)
	frame.savedNums.remNum:SetSize(frame.savedNums:GetWide()/2,controlHeight)
	frame.savedNums.remNum:SetPos(frame.savedNums.addNum:GetWide(),frame.savedNums:GetTall()-frame.savedNums.remNum:GetTall())
	function frame.savedNums.remNum:Paint(w,h)
		if self:IsHovered() then
			surface.SetDrawColor(225, 75, 75)
		else
			surface.SetDrawColor(215, 65, 65)
		end

		if not self:IsEnabled() then
			surface.SetDrawColor(181 ,181, 181)
		end

		surface.DrawRect(0, 0, w, h)
	end
	function frame.savedNums.remNum:DoClick()
		if not self:IsEnabled() or not selNum then return end
		
		selNum = nil
		self:SetEnabled(false)

		--Rewriting saved numbers
		local f = util.JSONToTable(file.Read(path) or "{}") or {}
		table.remove(f,selNum)
		file.Write(path, util.TableToJSON(f, true))

		savedNumbersTbl = f --Updating cached table
		frame.savedNums:DisplayList() --Updating the list
	end

	function frame.savedNums:DisplayList(delay)
		local delay = delay or 0
		if self.list and IsValid(self.list) then
			self.list:AlphaTo(0,0.2,0,function()
				self.list:Remove()
			end)

			delay = 0.4
		end

		timer.Simple(delay,function()
			if not frame.savedNums and not IsValid(frame.savedNums) then return end
			self.list = frame.savedNums:Add("DListLayout")
			self.list:SetSize(frame.savedNums:GetWide(),frame.savedNums:GetTall()-frame.savedNums.addNum:GetTall())
			local quant = 0
			for k,v in pairs(savedNumbersTbl) do
				quant = quant + 1
				local n = self.list:Add("DButton")
				n:SetSize(self.list:GetWide(), self.list:GetTall()/10)
				n:SetText("")
				n:SetColor(color_white)
				n:SetAlpha(0)
				n:AlphaTo(255,quant*0.2)
				function n:Paint(w,h)
					if self:IsHovered() then
						surface.SetDrawColor(36,36,36)
					else
						surface.SetDrawColor(34,34,34)
					end

					surface.DrawRect(0,0,w,h)
				end
				function n:DoClick()
					frame.savedNums.remNum:SetEnabled(true)

					selNum = k
					frame.dialNum = v.number
				end

				--Name Panel & Label
				n.namePanel = n:Add("DPanel")
				n.namePanel:SetSize(n:GetWide()*0.4,n:GetTall())
				function n.namePanel.Paint(this,w,h)
					if n:IsHovered() then
						surface.SetDrawColor(43,43,43)
					else
						surface.SetDrawColor(40,40,40)
					end
					surface.DrawRect(0,0,w,h)
				end

				n.name = n.namePanel:Add("DLabel")
				n.name:SetText(v.name)
				n.name:SetFont("nutSmallFont")
				n.name:SetColor(color_white)
				n.name:SizeToContents()
				n.name:Center()

				--Number Label
				n.number = n:Add("DLabel")
				n.number:SetText(v.number)
				n.number:SetColor(color_white)
				n.number:SetFont("nutSmallFont")
				n.number:SizeToContents()
				n.number:SetPos((n:GetWide()*0.6) - n.number:GetWide()/2,0)
				n.number:CenterVertical()
			end
		end)
	end

	--Initial list display call
	frame.savedNums:DisplayList(0.8)
	
	--Calling Menu (When phone is being called)
	if beingCalled then
		netstream.Start("respondPhoneCall", telent)

		frame:SetKeyboardInputEnabled(false)

		--Disable close button
		frame.close:SetDisabled(true)

		--Phone icon
		local pi = frame:Add("DLabel")
		pi:SetFont("wolficon_enormous")
		pi:SetText(ICON:GetIconChar("phone"))
		pi:SetColor(color_white)
		pi:SizeToContents()
		pi:CenterHorizontal()
		pi:CenterVertical(0.25)
		
		--Little animation
		local ow,oh = pi:GetSize()
		pi:SetSize(0,0)
		pi:SizeTo(ow, oh, 0.5, 0, 0.5)
		
		--Small Hint
		local sh = frame:Add("DLabel")
		sh:SetFont("nutMediumFont")
		sh:SetText("The caller can now hear you.")
		sh:SetColor(color_white)
		sh:SizeToContents()
		sh:CenterHorizontal()
		sh:CenterVertical(0.5)
		
		local function pullEverythingBackTogether(hangup)
			frame.close:SetDisabled(false) --Re-enabling close button
			pi:AlphaTo(0,0.3)
			sh:AlphaTo(0,0.3,0.3)
			hangup:AlphaTo(0,0.3,0.5,function()
				pi:Remove()
				sh:Remove()
				hangup:Remove()

				pullBack()
			end)
		end

		--Listener Hang up btn
		local hangup = createActionButton()
		hangup:SetText("Hangup")
		hangup:CenterHorizontal()
		hangup:CenterVertical(0.75)
		function hangup:DoClick()
			pullEverythingBackTogether(self)
			
			frame:SetKeyboardInputEnabled(true)

			--Update caller
			netstream.Start("updateCallCaller", {
				update = "hangup",
				caller = telent:getNetVar("caller"),
				phone = telent
			})
		end

		function frame:OnRemove()
			if hangup and IsValid(hangup) then
				hangup:DoClick()
			else
				self.OnRemove = nil
			end
		end

		netstream.Hook("updateCallListener", function(data)
			if data.update == "hangup" then
				frame:SetKeyboardInputEnabled(true)
				pullEverythingBackTogether(hangup)
			end
		end)
	end
end

netstream.Hook("OpenPhoneDialer", openDialer)