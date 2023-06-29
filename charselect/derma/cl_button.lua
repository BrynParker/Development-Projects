local PANEL = {}

function PANEL:Init()
	self:SetFont("nutCharButtonFont")
	self:SizeToContentsY()
	self:SetTextColor(nut.gui.charCreate.WHITE)
	self:SetPaintBackground(false)
end

function PANEL:OnCursorEntered()
	nut.gui.character:hoverSound()
	self:SetTextColor(nut.gui.charCreate.HOVERED)
end

function PANEL:OnCursorExited()
	self:SetTextColor(nut.gui.charCreate.WHITE)
end

function PANEL:OnMousePressed()
	nut.gui.character:clickSound()
	DButton.OnMousePressed(self)
end

vgui.Register("nutCharButton", PANEL, "DButton")