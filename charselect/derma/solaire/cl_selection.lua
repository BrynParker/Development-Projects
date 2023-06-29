local PANEL = {}
	PANEL.COLOR_TRANSPARENT = Color(0, 0, 0, 200)
	PANEL.ANIM_SPEED = 0.1
	PANEL.FADE_SPEED = 0.5

function PANEL:hoverSound()
	LocalPlayer():EmitSound("buttons/button15.wav", 35, 250)
end

function PANEL:clickSound()
	LocalPlayer():EmitSound("buttons/button14.wav", 35, 255)
end

function PANEL:warningSound()
	LocalPlayer():EmitSound("friends/friend_join.wav", 40, 255)
end

function PANEL:setFadeToBlack(fade)
	local d = deferred.new()
	if (fade) then
		if (IsValid(self.fade)) then
			self.fade:Remove()
		end
		local fade = vgui.Create("DPanel")
		fade:SetSize(ScrW(), ScrH())
		fade:SetSkin("Default")
		fade:SetBackgroundColor(color_black)
		fade:SetAlpha(0)
		fade:AlphaTo(255, self.FADE_SPEED, 0, function() d:resolve() end)
		fade:SetZPos(999)
		fade:MakePopup()
		self.fade = fade
	elseif (IsValid(self.fade)) then
		local fadePanel = self.fade
		fadePanel:AlphaTo(0, self.FADE_SPEED, 0, function()
			fadePanel:Remove()
			d:resolve()
		end)
	end
	return d
end


function PANEL:fadeOut()
	self:AlphaTo(0, self.ANIM_SPEED, 0, function()
		self:Remove()
	end)
end

function PANEL:loadBackground()
	-- Map scene integration.
	local mapScene = nut.plugin.list.mapscene
	if (not mapScene or table.Count(mapScene.scenes) == 0) then
		self.blank = true
	end

	local url = nut.config.get("backgroundURL")
	if (url and url:find("%S")) then
		self.bgLoader = self:Add("DPanel")
		self.bgLoader:SetSize(ScrW(), ScrH())
		self.bgLoader:SetZPos(-998)
		self.bgLoader.Paint = function(loader, w, h)
			surface.SetDrawColor(20, 20, 20)
			surface.DrawRect(0, 0, w, h)
		end
		
		self.background = self:Add("DHTML")
		self.background:SetSize(ScrW(), ScrH())
		if (url:find("http")) then
			self.background:OpenURL(url)
		else
			self.background:SetHTML(url)
		end
		self.background.OnDocumentReady = function(background)
			self.bgLoader:AlphaTo(0, 2, 1, function()
				self.bgLoader:Remove()
			end)
		end
		self.background:MoveToBack()
		self.background:SetZPos(-999)

		if (nut.config.get("charMenuBGInputDisabled")) then
			self.background:SetMouseInputEnabled(false)
			self.background:SetKeyboardInputEnabled(false)
		end
	end
end

local mat_arrow_left = nut.util.getMaterial("solaire_character/arrow.png")
local mat_arrow_right = nut.util.getMaterial("solaire_character/arrow2.png")

function PANEL:loadArrows()
	local w, h = ScrW(), ScrH()

	local leftArrow = vgui.Create( 'DButton', self )
	    leftArrow:SetPos( w/11, h * .5 - 50 )
	    leftArrow:SetSize( 100, 100 )
	    leftArrow:SetText('')

    leftArrow.DoClick = function()
        self.active_slot = 1
        self:clickSound()

        self:createButtons()
    end

    leftArrow.OnCursorEntered = self.hoverSound

    function leftArrow:Paint(w,h)
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( mat_arrow_right )
        surface.DrawTexturedRect( 0, 0, w, h)
    end

    local rightArrow = vgui.Create( 'DButton', self )
	    rightArrow:SetPos( w/1.15, h * .5 - 50 )
	    rightArrow:SetSize( 100, 100 )
	    rightArrow:SetText('')

    rightArrow.DoClick = function()
        self.active_slot = 2
        self:clickSound()

        self:createButtons()
    end

    rightArrow.OnCursorEntered = self.hoverSound

    function rightArrow:Paint(w,h)
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial(mat_arrow_left)
        surface.DrawTexturedRect( 0, 0, w, h)
    end
end

local slot = nut.util.getMaterial("solaire_character/slot.png")

function PANEL:loadSlots()
	if self.base then self.base:Remove() end

    self.base = vgui.Create("DModelPanel", self)
	    self.base:Dock(FILL)
	    self.base:SetModel("models/props_junk/watermelon01.mdl")
	    self.base:SetCamPos(Vector( 0, 0, 180 ))
	    self.base:SetMouseInputEnabled(false)

	self.base.animation_left = 0
	self.base.animation_right = 0

	local first_character = self.characters[1]
	local second_character = self.characters[2]

	local first_character_name = first_character and first_character:getName():gsub("#", "\226\128\139#"):upper()
	local second_character_name = second_character and second_character:getName():gsub("#", "\226\128\139#"):upper()

	local first_char_slot = first_character and (nut.faction.indices[first_character:getFaction()].slotMaterial or slot) or slot
	local second_char_slot = second_character and (nut.faction.indices[second_character:getFaction()].slotMaterial or slot) or slot

    function self.base:PreDrawModel(ent)
    	self.animation_left = Lerp(0.01, self.animation_left, self:GetParent().active_slot == 1 and 1 or 0)
		self.animation_right = Lerp(0.01, self.animation_right, self:GetParent().active_slot == 2 and 1 or 0)

        local vec = Vector(30, 0, -20)

        local banned = first_character and first_character:getData("banned") or false

        cam.Start3D2D( vec + Vector( 10, 70, 18 ), Angle( 20, 270, 0 ), 0.1 )
            surface.SetDrawColor(Color(0, 0, 0, 240))
            surface.SetMaterial(first_char_slot)
            surface.DrawTexturedRect( 0, 0, 500, 900 + 50 * self.animation_left )
            draw.RoundedBox( 0, 0, 400, 500, 100, Color( 0, 0, 0, 200 ) )
            draw.SimpleText(first_character and (banned and "BANNED" or first_character_name) or "EMPTY SLOT", "solaireCharSlot", 250, 450, color_white, 1, 1)
	    cam.End3D2D()

	    banned = second_character and second_character:getData("banned") or false

        cam.Start3D2D( vec + Vector( 10, -23, 0 ), Angle( -20, 270, 0 ), 0.1 )
            surface.SetDrawColor(Color(0, 0, 0, 240))
            surface.SetMaterial(second_char_slot)
            surface.DrawTexturedRect( 0, 0, 500, 900 + 50 * self.animation_right )
            draw.RoundedBox( 0, 0, 400, 500, 100, Color( 0, 0, 0, 200 ) )
            draw.SimpleText(second_character and (banned and "BANNED" or second_character_name) or "EMPTY SLOT", "solaireCharSlot", 250, 450, color_white, 1, 1)
	    cam.End3D2D()

        return false
    end

    self:loadArrows()
end

local play_icon = nut.util.getMaterial("solaire_character/icons/play.png")
local plus_icon = nut.util.getMaterial("solaire_character/icons/plus.png")
local delete_icon = nut.util.getMaterial("solaire_character/icons/delete.png")
local return_icon = nut.util.getMaterial("mafiarp/undo.png")

function PANEL:createButtons()
	local w, h = ScrW(), ScrH()
	local f1 = LocalPlayer():getChar()

	if self.buttons then self.buttons:Remove() end

	local function playCharacter()
		self:clickSound()

		local character = self.characters[self.active_slot]
		if not character then 
			self:Remove() 
			vgui.Create("solaireCharacterCreation") 

			nut.gui.charCreate.context.characterSlot = self.active_slot
			return 
		end

		if (self.choosing) then return end
		
		local gui = self
		if (character == LocalPlayer():getChar()) then
			return gui:fadeOut()
		end

		self.choosing = true
		gui:setFadeToBlack(true)
			:next(function()
				timer.Simple(0.25, function()
					if (not IsValid(gui)) then return end
					gui:setFadeToBlack(false)
					gui:Remove()
				end)

				return nutMultiChar:chooseCharacter(character:getID())
			end)
			
	end

	local buttonSize = 98
	local character = self.characters[self.active_slot]

	local width = buttonSize * ((character and 2 or 1) + (f1 and 1 or 0))

	self.buttons = vgui.Create("Panel", self)
		self.buttons:SetSize(width, buttonSize)
		self.buttons:SetX(w/2-width/2)
		self.buttons:SetY(h-buttonSize)

	function self.buttons:Paint(w, h)
		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	if f1 then
		local close = vgui.Create("DButton", self.buttons)
			close:SetSize(buttonSize, buttonSize)
			close:Dock(LEFT)
			close:SetText("")
		close.Paint = function(_, w, h)
			surface.SetDrawColor(self.COLOR_TRANSPARENT)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(color_white)
			surface.DrawOutlinedRect(0, 0, w, h)

			surface.SetMaterial(return_icon)
			surface.DrawTexturedRect(w/2-48/2, h/2-48/2, 48, 48)
		end

		close.DoClick = function() self:clickSound() self:Remove() end
		close.OnCursorEntered = self.hoverSound
	end

	local icon = character and play_icon or plus_icon

	local play = vgui.Create("DButton", self.buttons)
		play:SetSize(buttonSize, buttonSize)
		play:Dock(LEFT)
		play:SetText("")
	play.Paint = function(_, w, h)
		surface.SetDrawColor(self.COLOR_TRANSPARENT)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(0, 0, w, h)

		surface.SetMaterial(icon)
		surface.DrawTexturedRect(w/2-48/2, h/2-48/2, 48, 48)
	end

	play.DoClick = playCharacter
	play.OnCursorEntered = self.hoverSound

	if character then
		local delete = vgui.Create("DButton", self.buttons)
			delete:SetSize(buttonSize, buttonSize)
			delete:Dock(LEFT)
			delete:SetText("")
		delete.Paint = function(_, w, h)
			surface.SetDrawColor(self.COLOR_TRANSPARENT)
	    	surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(color_white)
			surface.DrawOutlinedRect(0, 0, w, h)

			surface.SetMaterial(delete_icon)
			surface.DrawTexturedRect(w/2-32/2, h/2-32/2, 32, 32)
		end

		delete.DoClick = function()
			self:warningSound()

			local blurTime = SysTime()

			local canvas = vgui.Create("EditablePanel")
				canvas:SetSize(ScrW(), ScrH())
				canvas:MakePopup()

			function canvas:Paint(w, h)
				Derma_DrawBackgroundBlur(self, blurTime)
			end

			local modal = vgui.Create("EditablePanel", canvas)
				modal:SetSize(ScrW()/4, ScrH()/6)
				modal:Center()

			modal.Paint = function(_, w, h)
				surface.SetDrawColor(PANEL.COLOR_TRANSPARENT)
				surface.DrawRect(0, 0, w, h)
				surface.DrawRect(0, 0, w, 30)

				draw.SimpleText("Confirm action", "solaireModal", 8, 15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText("Do you really want to delete character?", "solaireModal", w/2, h/3, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
				canvas:Remove()
				
				netstream.Start("charDel", character:getID())
				table.RemoveByValue(nut.characters, character:getID())
				hook.Run("CharacterListUpdated")
				
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

		delete.OnCursorEntered = self.hoverSound
	end
end

local background = nut.util.getMaterial("ex/charcreation"..math.random(1,3)..".png")
function PANEL:paintBackground(w, h)
	if (IsValid(self.background)) then return end

	if (self.blank) then
		surface.SetDrawColor(30, 30, 30)
		surface.DrawRect(0, 0, w, h)
	end

	surface.SetMaterial(background)
	surface.SetDrawColor(color_white)
	surface.DrawTexturedRect(0, 0, w, h)
end

function PANEL:paintTitle(w, h)
	surface.SetFont("solaireCharSlot")
    local tw = surface.GetTextSize("SELECT CHARACTER")

	surface.SetDrawColor(self.COLOR_TRANSPARENT)
    surface.DrawRect(0, 40, tw + 40, h/12)

    draw.SimpleText("SELECT CHARACTER", "solaireCharSlot", 20, 40 + (h/12)/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function PANEL:Paint(w, h)
	self:paintBackground(w, h)
	self:paintTitle(w, h)
end

function PANEL:UpdateCharacters()

	self.characters = {}

	for _, id in ipairs(nut.characters) do
		if(!nut.char.loaded[id]) then continue end
		local character = nut.char.loaded[id]
		//PrintTable(character)
		self.characters[character.vars.characterSlot or (self.characters[1] and 2 or 1)] = character
	end

end

function PANEL:Init()
	background = nut.util.getMaterial("ex/charcreation"..math.random(1,3)..".png")
	self:Dock(FILL)
	self:MakePopup()
	self:SetAlpha(0)
	self:AlphaTo(255, self.ANIM_SPEED * 2)

	self:UpdateCharacters()

	self.music = self:Add("nutCharBGMusic")
	self:loadBackground()

	self.active_slot = 1

	self:loadSlots()
	self:createButtons()

	hook.Add("CharacterListUpdated", self, function()
		self:UpdateCharacters()

		self:loadSlots()
		self:createButtons()
	end)
end

vgui.Register("solaireCharacterSelection", PANEL, "EditablePanel")