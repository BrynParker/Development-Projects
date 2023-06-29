PLUGIN.name = "MafiaRP Inventory"
PLUGIN.author = ""
PLUGIN.desc = "Replaces default nutscript inventory, F1 menu, tooltips, and more."

if (CLIENT) then
	hook.Add("Think", "OpenInventory", function()
		if !IsValid(LocalPlayer()) then return end

		if LocalPlayer():IsTyping() or (IsValid(vgui.GetKeyboardFocus()) and vgui.GetKeyboardFocus():GetClassName( ) == "TextEntry") or gui.IsGameUIVisible() or gui.IsConsoleVisible() then
			if IsValid(nut.gui.inv1) and IsValid(inventory_info) and !IsValid(safebox_menuINV) then
				nut.gui.inv1:Remove()
				inventory_info:Remove()
			end
			return
		end

		if (LocalPlayer():getChar()) then
			if (LocalPlayer().nextUseMenu or 0) < CurTime() and input.IsKeyDown(KEY_I) and !LocalPlayer():getNetVar("typing") then
				if IsValid(nut.gui.inv1) and IsValid(inventory_info) then
					nut.gui.inv1:Remove()
					inventory_info:Remove()
					if IsValid(safebox_menuINV)  then
						safebox_menuINV:Remove()
					end
					if IsValid(container_info)  then
						container_info:Remove()
						container_info:OnRemove()
					end
				else
					nut.gui.inv1 = vgui.Create("nutInventory")
					nut.gui.inv1:ShowCloseButton(false)
					local inventory2 = LocalPlayer():getChar():getInv()
					if (inventory2) then nut.gui.inv1:setInventory(inventory2) end
					nut.gui.inv1:SetSize(nut.gui.inv1:GetWide(), nut.gui.inv1:GetTall())
					nut.gui.inv1:SetPos(ScrW()*0.61, ScrH()*0.1)
					nut.gui.inv1:SetZPos(-999999)
					
					
					--model+player info
					inventory_info = vgui.Create("inventory_info")
					inventory_info:SetPos(ScrW() * -0.01, ScrH()*0.09)
					inventory_info:SetSize(inventory_info:GetSize())
					inventory_info:SetZPos(-999999)
				end
			LocalPlayer().nextUseMenu = CurTime() + 0.4
			end
			if (LocalPlayer().nextUseMenu_second or 0) < CurTime() and input.IsKeyDown(KEY_E) and !LocalPlayer():getNetVar("typing") then
				if IsValid(nut.gui.inv1) and IsValid(inventory_info) and IsValid(safebox_menuINV) and IsValid(container_info) then
					nut.gui.inv1:Remove()
					inventory_info:Remove()
					safebox_menuINV:Remove()
					container_info:Remove()
				end
			LocalPlayer().nextUseMenu_second = CurTime() + 0.1
			end
		end
	end)
	
	
	
	hook.Add("LoadFonts", "MPLoadFonts", function(font, genericFont)
    surface.CreateFont("StalkerMediumFont", {
        font = "Myriad Pro",
        size = ScreenScale(9),
        weight = 300,
        antialias = true,
        extended = true
    })
    surface.CreateFont("MySuperFont", {
        font = "Gangsta",
        size = ScreenScale(20),
        weight = 300,
        antialias = true,
        extended = true
    })
    
    surface.CreateFont("StalkerSmallFont", {
        font = "Myriad Pro",
        size = ScreenScale(9),
        weight = 150,
        antialias = true,
        extended = true
    })

    surface.CreateFont("TitleStalkerBigFont", {
        font = "Arial Bold",
        size = ScreenScale(15),
        weight = 550,
        antialias = true,
        extended = true
    })

    surface.CreateFont("NameFactionFont", {
        font = "Myriad Arabic",
        size = ScreenScale(9),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("DescCharFont", {
        font = "Myriad Pro",
        size = ScreenScale(7),
        weight = 150,
        antialias = true,
        extended = true
    })

    surface.CreateFont("DescCharFont1", {
        font = "Myriad Pro",
        size = ScreenScale(7),
        weight = 150,
        antialias = true,
        extended = true
    })

    surface.CreateFont("DescTipFont", {
        font = "Myriad Pro",
        size = ScreenScale(7),
        weight = 150,
        antialias = true,
        extended = true
    })

    surface.CreateFont("NameFactionPingFont", {
        font = "Myriad Arabic",
        size = ScreenScale(9),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("NameFactionFactionFont", {
        font = "Myriad Arabic",
        size = ScreenScale(9),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("BigFontForSafe", {
        font = "Graffiti1CTT",
        size = ScreenScale(19),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("LFontForSafe", {
        font = "Graffiti1CTT",
        size = ScreenScale(9),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("1LFontForSafe", {
        font = "Graffiti1CTT",
        size = ScreenScale(10),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("BigFontForWS", {
        font = "Graffiti1CTT",
        size = ScreenScale(12),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("dobi4ikxyecoc", {
        font = "GOST type B",
        size = ScreenScale(13),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("dobi4ikxyecoc44", {
        font = "GOST type B",
        size = ScreenScale(11),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("dobi4ikxyecockft", {
        font = "GOST type B",
        size = ScreenScale(11),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("dobi4ikxyecockft123", {
        font = "GOST type B",
        size = ScreenScale(9),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("dobi4ikxyecockft1234444", {
        font = "GOST type B",
        size = ScreenScale(9),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("gost6", {
        font = "GOST type B",
        size = ScreenScale(6),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("gost5", {
        font = "GOST type B",
        size = ScreenScale(5),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("dobi4ikxyecockft123123123", {
        font = "GOST type B",
        size = ScreenScale(13),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("dobi4ikxyecoc1", {
        font = "Tahoma",
        size = ScreenScale(16),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("Tahoma13", {
        font = "Tahoma",
        size = ScreenScale(13),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("Tahoma10", {
        font = "Tahoma",
        size = ScreenScale(10),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("gost10", {
        font = "GOST type B",
        size = ScreenScale(10),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("gost8", {
        font = "GOST type B",
        size = ScreenScale(8),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("gost7", {
        font = "GOST type B",
        size = ScreenScale(7),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("dobi4ikxyecoc1_ver", {
        font = "GOST type B",
        size = ScreenScale(6),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("DeadBigFontForSafe", {
        font = "Graffiti1CTT",
        size = ScreenScale(32),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("ChatFontMisery", {
        font = "Myriad Pro",
        size = ScreenScale(7),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("ChatFontMisery32", {
        font = "Myriad Arabic",
        size = ScreenScale(7),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("ChatFontMisery1", {
        font = "Myriad Pro",
        size = ScreenScale(6),
        weight = 250,
        antialias = true,
        extended = true
    })

    surface.CreateFont("Roh_Low", {
        font = "Courier",
        extended = false,
        size = ScreenScale(5), --14
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    })

    surface.CreateFont("Roh14", {
        font = "Courier",
        extended = false,
        size = ScreenScale(6), --14
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = true,
        additive = false,
        outline = false,
    })

    surface.CreateFont("Roh10", {
        font = "Courier",
        extended = false,
        size = ScreenScale(7), --17
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = true,
        additive = false,
        outline = false,
    })

    surface.CreateFont("Dma6", {
        font = "Courier",
        extended = false,
        size = ScreenScale(6),
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = true,
        additive = false,
        outline = false,
    })

    surface.CreateFont("Dma13", {
        font = "Courier",
        extended = false,
        size = ScreenScale(13),
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = true,
        additive = false,
        outline = false,
    })

    surface.CreateFont("Dma5", {
        font = "Courier",
        extended = false,
        size = ScreenScale(5),
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = true,
        additive = false,
        outline = false,
    })

    surface.CreateFont("Dma4", {
        font = "Courier",
        extended = false,
        size = ScreenScale(4),
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = true,
        additive = false,
        outline = false,
    })

    surface.CreateFont("Roh20", {
        font = "Courier",
        extended = false,
        size = ScreenScale(9), --21
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    })

    surface.CreateFont("Roh25", {
        font = "Courier",
        extended = false,
        size = ScreenScale(11),
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    })

    surface.CreateFont("Test", {
        font = "FranklinGothicHeavyRegular",
        extended = false,
        size = ScreenScale(12),
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = true,
        additive = false,
        outline = true,
    })

    surface.CreateFont("Roh15", {
        font = "Courier",
        extended = false,
        size = ScreenScale(8), 
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = true,
        additive = false,
        outline = false,
    })
	
	surface.CreateFont("InterItalic", {
        font = "Inter Italic",
        extended = false,
        size = ScreenScale(8), 
        weight = 350,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = true,
        additive = false,
        outline = false,
    })
	surface.CreateFont("InterThin", {
        font = "Inter Thin BETA",
        extended = false,
        size = ScreenScale(14), 
        weight = 350,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = true,
        additive = false,
        outline = false,
    })
	surface.CreateFont("InterRegular", {
        font = "Inter Regular",
        extended = false,
        size = ScreenScale(13), 
        weight = 350,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = true,
        additive = false,
        outline = false,
    })
	surface.CreateFont("InterThinLarge", {
        font = "Inter Thin BETA",
        extended = false,
        size = ScreenScale(20), 
        weight = 350,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = true,
        additive = false,
        outline = false,
    })
	
	surface.CreateFont("InterThinSmall", {
        font = "Inter Thin BETA",
        extended = false,
        size = ScreenScale(8), 
        weight = 350,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = true,
        additive = false,
        outline = false,
    })
	
	surface.CreateFont("InterThinItalic", {
        font = "Inter Thin Italic BETA",
        extended = false,
        size = ScreenScale(14), 
        weight = 350,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = true,
        additive = false,
        outline = false,
    })
end)
end
