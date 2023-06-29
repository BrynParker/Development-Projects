--

local PANEL = {}
	PANEL.WHITE = Color(255, 255, 255, 150)
	PANEL.SELECTED = Color(255, 255, 255, 230)
	PANEL.HOVERED = Color(255, 255, 255, 50)
	PANEL.COLOR_TRANSPARENT = Color(0, 0, 0, 200)
	PANEL.ANIM_SPEED = 0.1

function PANEL:hoverSound()
	LocalPlayer():EmitSound("buttons/button15.wav", 35, 250)
end

function PANEL:clickSound()
	LocalPlayer():EmitSound("buttons/button14.wav", 35, 255)
end

function PANEL:warningSound()
	LocalPlayer():EmitSound("friends/friend_join.wav", 40, 255)
end

function PANEL:errorSound()
	LocalPlayer():EmitSound("buttons/blip1.wav", 50)
end

function PANEL:setupFaction()
	for index, faction in pairs(nut.faction.indices) do
		if faction.isDefault then 
			self.context.faction = index
		end
	end
end

function PANEL:configureSteps()
	self:addStep(vgui.Create("nutCharacterBiography"))
	self:addStep(vgui.Create("nutCharacterAttribs"))
	hook.Run("ConfigureCharacterCreationSteps", self)
end

function PANEL:addStep(step, priority)
	if (not ispanel(step)) and (not type(step) == "boolean") then Error("Invalid panel for step") end

	self.steps[#self.steps + 1] = step
	if ispanel(step) then step:SetParent(self.canvas) end
end

function PANEL:setStep(step)
	local lastStep = self.curStep
	local curStep = self.steps[lastStep]

	self.curStep = step
	local nextStep = self.steps[self.curStep]

	if (type(nextStep) == "boolean") then
		self.curStep = lastStep
		return self:onFinish()
	end

	self:onStepChanged(curStep, nextStep)
end


function PANEL:getPreviousStep()
	local step = self.curStep - 1
	while (IsValid(self.steps[step])) do
		if (not self.steps[step]:shouldSkip()) then
			hasPrevStep = true
			break
		end
		step = step - 1
	end
	return self.steps[step]
end

function PANEL:onStepChanged(oldStep, newStep)
	local ANIM_SPEED = nut.gui.character.ANIM_SPEED
	local shouldFinish = self.curStep == #self.steps

	-- Transition the view to the new step view.
	local function showNewStep()
		newStep:SetAlpha(0)
		newStep:SetVisible(true)
		newStep:Dock(FILL)
		newStep:onDisplay()
		newStep:AlphaTo(255, ANIM_SPEED)
	end

	if (IsValid(oldStep)) then
		oldStep:AlphaTo(0, ANIM_SPEED, 0, function()
			oldStep:SetVisible(false)
			oldStep:onHide()
			showNewStep()
		end)
	else
		showNewStep()
	end
end

function PANEL:loadModelSelection()
	local buttonPrev = vgui.Create("DButton", self)
		buttonPrev:SetSize(40, 80)
		buttonPrev:SetPos(self.w/10, self.h/2)
		buttonPrev:SetText("")

	local bw, bh = buttonPrev:GetSize()
	local arrow_left = {{ x = bw, y = 0 }, { x = bw, y = bh }, { x = 0, y = bh/2}}

	function buttonPrev:Paint(w,h)
		surface.SetDrawColor(PANEL.COLOR_TRANSPARENT)
		draw.NoTexture()
		surface.DrawPoly(arrow_left)
	end

	buttonPrev.OnCursorEntered = self.hoverSound

	buttonPrev.DoClick = function()
		self.model.num = self.model.num - 1
		if self.model.num == 0 then self.model.num = #self.model.models end
		self.model:SetUp()

		self:clickSound()
	end

	local buttonNext = vgui.Create("DButton", self)
		buttonNext:SetSize(40, 80)
		buttonNext:SetPos(self.w/3.42, self.h/2)
		buttonNext:SetText("")

	bw, bh = buttonNext:GetSize()
	local arrow_right = {{ x = 0, y = 0 }, { x = bw, y = bh/2 }, { x = 0, y = bh}}

	function buttonNext:Paint(w,h)
		surface.SetDrawColor(PANEL.COLOR_TRANSPARENT)
		draw.NoTexture()
		surface.DrawPoly(arrow_right)
	end

	buttonNext.OnCursorEntered = self.hoverSound

	buttonNext.DoClick = function()
		self.model.num = self.model.num + 1
		if self.model.num > #self.model.models then self.model.num = 1 end
		self.model:SetUp()

		self:clickSound()
	end
end

function PANEL:loadModel()
	self.model = vgui.Create( "DModelPanel", self )
		self.model.models = nut.faction.indices[self.context.faction].models

		self.model:SetPos(self.w/12, self.h/12)
		self.model:SetSize(self.w/4, self.h-self.h/6)		
		self.model:SetFOV(19)
		self.model:SetMouseInputEnabled(false)
		self.model:SetModel("models/error.mdl")
		self.model.num = 1
		function self.model:LayoutEntity(Entity) return end

	function self.model:SetUp()
		local model = self.models[self.num]
			local isTable = type(model) == "table"

		local modelString = isTable and model[1] or model

		self:SetModel(modelString)
		self:GetParent().context.model = self.num

		local bone = self.Entity:LookupBone("ValveBiped.Bip01_Spine")
		if bone then
			local eyepos = self.Entity:GetBonePosition(bone)
		    eyepos:Add(Vector(145, 0, 0))
		    self:SetCamPos(eyepos)
		end

		if isTable then
			self:SetSkin(model[2] or 0)
			self:SetBodyGroups(model[3] and model[3] or "")
		else
			self:SetSkin(0)
			self:SetSkin("")
		end
	end

	self.model:SetUp()
	if #self.model.models > 1 then self:loadModelSelection() end
end

function PANEL:loadStepButtons(w, h)
	for i = 1, #self.steps do
		local button_pos 

		if i == 1 then
			button_pos = Vector(#self.steps == 1 and (w/2 - 15) or (w/2 - 30 - (30 * (#self.steps / 2)) + 30/2), h-h/20)
			previous = button_pos
		else
			button_pos = Vector(previous.x + 40, h-h/20)
			previous = button_pos
		end

		local button = vgui.Create("DButton", self.content)
			button:SetText("")
			button:SetSize(30, 30)
			button:SetPos(button_pos.x, button_pos.y)

		button.OnCursorEntered = self.hoverSound

		button.DoClick = function()
			self:setStep(i)
			self:clickSound()
		end

		button.Paint = function(_, w, h)
			draw.NoTexture()
			surface.SetDrawColor(self.curStep == i and Color(0, 255, 0) or color_white)
			draw.Circle(w/2, h/2, 8, 20)
		end
	end
end

function PANEL:loadContent()
	self.content = vgui.Create("EditablePanel", self)
		self.content:SetSize(self.w/2, self.h/1.4)
		self.content:SetPos(self.w/12 + self.w/3.4, self.h/6)

	function self.content:Paint(w, h)
		local title = self:GetParent().steps[self:GetParent().curStep].stepTitle

		surface.SetDrawColor(PANEL.COLOR_TRANSPARENT)
		surface.DrawRect(0, 0, w, h)
		surface.DrawRect(0, h-h/16, w, h/16)
		surface.DrawRect(0, 0, w, h/12)

		draw.SimpleText(title or "", "solaireCharSlot", w/2, h/24, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local w, h = self.content:GetSize()

	self.canvas = vgui.Create("EditablePanel", self.content)
		self.canvas:SetPos(0, h/12)
		self.canvas:SetSize(w, h - h/12 - h/16)
end

function PANEL:onFinish()
	local blurTime = SysTime()

	local canvas = vgui.Create("EditablePanel")
		canvas:SetSize(ScrW(), ScrH())
		canvas:MakePopup()

	function canvas:Paint(w, h)
		Derma_DrawBackgroundBlur(self, blurTime)
	end

	local isvalid = nutMultiChar:validateData(self.context)
	if not isvalid then
		self:errorSound()

		local modal = vgui.Create("EditablePanel", canvas)
			modal:SetSize(ScrW()/4, ScrH()/6)
			modal:Center()

		modal.Paint = function(_, w, h)
			surface.SetDrawColor(PANEL.COLOR_TRANSPARENT)
			surface.DrawRect(0, 0, w, h)
			surface.DrawRect(0, 0, w, 30)

			draw.SimpleText("You need to complete all fields", "solaireModal", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local w, h = modal:GetSize()

		local close = vgui.Create("DButton", modal)
			close:SetText("")
			close:SetSize(30, 30)
			close:SetPos(w - 40, 0)

		close.OnCursorEntered = self.hoverSound
		close.DoClick = function()
			canvas:Remove()
			self:clickSound()
		end

		close.Paint = function(_, w, h)
			draw.NoTexture()
			surface.SetDrawColor(Color(255, 0, 0))
			draw.Circle(w/2, h/2, 8, 20)
		end

		return
	end

	self:warningSound()

	local modal = vgui.Create("EditablePanel", canvas)
		modal:SetSize(ScrW()/4, ScrH()/6)
		modal:Center()

	modal.Paint = function(_, w, h)
		surface.SetDrawColor(PANEL.COLOR_TRANSPARENT)
		surface.DrawRect(0, 0, w, h)
		surface.DrawRect(0, 0, w, 30)

		draw.SimpleText("Confirm action", "solaireModal", 8, 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("Do you really want to create character?", "solaireModal", w/2, h/3, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local w, h = modal:GetSize()

	local close = vgui.Create("DButton", modal)
		close:SetText("")
		close:SetSize(30, 30)
		close:SetPos(w - 40, 0)

	close.OnCursorEntered = self.hoverSound
	close.DoClick = function()
		canvas:Remove()
		self:clickSound()
	end

	close.Paint = function(_, w, h)
		draw.NoTexture()
		surface.SetDrawColor(Color(255, 0, 0))
		draw.Circle(w/2, h/2, 8, 20)
	end

	local confirm = vgui.Create("DButton", modal)
		confirm:SetPos(w/2-45, h/1.8)
		confirm:SetSize(30, 30)
		confirm:SetText("")

	confirm.OnCursorEntered = function(button)
		self:hoverSound()
		button.hovered = SysTime()
	end
	confirm.DoClick = function()
		self:clickSound()

		self:Remove()
		canvas:Remove()

		nutMultiChar:createCharacter(self.context)
		:next(function()
			vgui.Create("solaireCharacterSelection")
		end, function(arg1, arg2) print("Epic character creation fail") end)
	end

	confirm.Paint = function(self, w, h)
		if self:IsHovered() then
			DisableClipping(true)
				draw.SimpleText("Yes", "solaireModal", w/2, -16, Color(255, 255, 255, (SysTime() - self.hovered) * 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			DisableClipping(false)
		end

		draw.NoTexture()
		surface.SetDrawColor(Color(0, 255, 0))
		draw.Circle(w/2, h/2, 8, 20)
	end

	local deny = vgui.Create("DButton", modal)
		deny:SetPos(w/2+15, h/1.8)
		deny:SetSize(30, 30)
		deny:SetText("")

	deny.OnCursorEntered = function(button)
		self:hoverSound()
		button.hovered = SysTime()
	end
	deny.DoClick = function()
		canvas:Remove()
		self:clickSound()
	end

	deny.Paint = function(self, w, h)
		if self:IsHovered() then
			DisableClipping(true)
				draw.SimpleText("No", "solaireModal", w/2, -16, Color(255, 255, 255, (SysTime() - self.hovered) * 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			DisableClipping(false)
		end

		draw.NoTexture()
		surface.SetDrawColor(Color(255, 0, 0))
		draw.Circle(w/2, h/2, 8, 20)
	end
end

local background = nut.util.getMaterial("ex/charcreation"..math.random(1,3)..".png")

function PANEL:paintTitle(w, h)
	surface.SetFont("solaireCharSlot")
    local tw = surface.GetTextSize("CREATE CHARACTER")

	surface.SetDrawColor(self.COLOR_TRANSPARENT)
    surface.DrawRect(0, 40, tw + 40, h/12)

    draw.SimpleText("CREATE CHARACTER", "solaireCharSlot", 20, 40 + (h/12)/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function PANEL:paintBackground(w, h)
	surface.SetMaterial(background)
	surface.SetDrawColor(color_white)
	surface.DrawTexturedRect(0, 0, w, h)
end

function PANEL:Paint(w, h)
	self:paintBackground(w, h)
	self:paintTitle(w, h)
end

function PANEL:Init()
	background = nut.util.getMaterial("ex/charcreation"..math.random(1,3)..".png")
	nut.gui.charCreate = self
	nut.gui.character = self

	self:Dock(FILL)
	self:MakePopup()
	self:SetAlpha(0)
	self:AlphaTo(255, self.ANIM_SPEED * 2)

	self.w, self.h = ScrW(), ScrH()

	self.steps = {}
	self.curStep = 0
	self.context = {}

	self:setupFaction()
	self:loadContent()
	self:configureSteps()

	self:addStep(true)

	local w, h = self.content:GetSize()
	self:loadStepButtons(w, h)

	self:loadModel()
	self:setStep(1)
end

vgui.Register("solaireCharacterCreation", PANEL, "EditablePanel")

--