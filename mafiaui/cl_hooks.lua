if CLIENT then
    Openkey = KEY_F4
    MenuButton = {}
    local blur = Material("pp/blurscreen")

    local function DrawBlur(panel, amount)
        local x, y = panel:LocalToScreen(0, 0)
        local scrW, scrH = ScrW(), ScrH()
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(blur)

        for i = 1, 3 do
            blur:SetFloat("$blur", (i / 3) * (amount or 6))
            blur:Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
        end
    end


    --print(LocalPlayer():SteamID())
end


hook.Add("StartChat", "HasStartedTyping", function()
    IsPlayerChat = true
end)

hook.Add("FinishChat", "ClientFinishTyping", function()
    IsPlayerChat = false
end)

local KeyDown = false



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
        size = ScreenScale(8), --21
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
end)