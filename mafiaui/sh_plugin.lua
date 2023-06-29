PLUGIN.name = "Character Creation"
PLUGIN.author = "Cyi"
PLUGIN.desc = "Char creation"

--Mainmenu settings
MAINMENUSETTINGS = {}
MAINMENUSETTINGS.font = "UniSansHeavyCAPS"
MAINMENUSETTINGS.contentURL = "https://steamcommunity.com/sharedfiles/filedetails/?id=1645008597"
MAINMENUSETTINGS.discordURL = "https://discord.gg/7GA6RTU7gF"
MAINMENUSETTINGS.groupURL = "https://steamcommunity.com/groups/externalgamingeu"

resource.AddFile("resource/fonts/Bitter-Bold.ttf")
resource.AddFile("resource/fonts/Uni_Sans_Heavy.ttf")

--Includes
nut.util.include("cl_character.lua")
nut.util.include("cl_menu.lua")
nut.util.include("cl_information.lua")
nut.util.include("cl_hooks.lua")
nut.util.include("cl_inventory.lua")

--Creating Fonts
if CLIENT then
  hook.Add("LoadFonts", "MainmenuFonts", function(font,genericFont)
  	surface.CreateFont("mm_options", {
  		font = MAINMENUSETTINGS.font,
  		size = 30,
  		weight = 800,
  		antialias = true
  	})

  	surface.CreateFont("character_name", {
  		font = MAINMENUSETTINGS.font,
  		size = 25,
  		weight = 800,
  		antialias = true
  	})

  	surface.CreateFont("faction_names", {
  		font = "Bitter Bold",
  		size = 45,
  		weight = 1000,
  		antialias = true
  	})

  	surface.CreateFont("faction_title", {
  		font = MAINMENUSETTINGS.font,
  		size = 50,
  		weight = 1000,
  		antialias = true
  	})

    surface.CreateFont("bitter_huge", {
      font = "Bitter Bold",
      size = 72,
      weight = 600,
      antialias = true
    })

    surface.CreateFont("bitter", {
      font = "Bitter Bold",
      size = 25,
      weight = 600,
      antialias = true
    })

    surface.CreateFont("bitter_small", {
      font = "Bitter Bold",
      size = 20,
      weight = 600,
      antialias = true
    })
  end)
end