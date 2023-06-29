PLUGIN.name = "NS Character Selection"
PLUGIN.author = "Cheesenut"
PLUGIN.desc = "The NutScript character selection screen."

nut.util.includeDir(PLUGIN.folder.."/derma/steps", true)
nut.util.includeDir(PLUGIN.folder.."/derma/solaire", true)

nut.config.add(
	"sound",
	"sound/ex/mainmenu.mp3",
	"The default music played in the character menu.",
	nil,
	{category = PLUGIN.name}
)
nut.config.add(
	"musicvolume",
	"0.25",
	"The Volume for the music played in the character menu.",
	nil,
	{
		form = "Float",
		data = {min = 0, max = 1},
		category = PLUGIN.name
	}
)
nut.config.add(
	"backgroundURL",
	"",
	"The URL or HTML for the background of the character menu.",
	nil,
	{category = PLUGIN.name}
)

nut.config.add(
	"charMenuBGInputDisabled",
	true,
	"Whether or not KB/mouse input is disabled in the character background.",
	nil,
	{category = PLUGIN.name}
)

if (SERVER) then
	hook.Add("OnDatabaseLoaded", "solaire_char.OnDatabaseLoaded", function()
		nut.db.query("ALTER TABLE nut_characters ADD COLUMN _slot INTEGER")
	end)
end

nut.char.registerVar("characterSlot", {
	field = "_slot",
	default = 1,
	--isLocal = true,
	onValidate = function(value, data, client)
		return (value == 1) or (value == 2)
	end,
})

if (SERVER) then return end

local function ScreenScale(size)
	return size * (ScrH() / 900) + 10
end

function PLUGIN:LoadFonts(font)
	-- old
	surface.CreateFont("nutCharTitleFont", {
		font = font,
		weight = 200,
		size = ScreenScale(70),
		additive = true
	})
	surface.CreateFont("nutCharDescFont", {
		font = font,
		weight = 200,
		size = ScreenScale(24),
		additive = true
	})
	surface.CreateFont("nutCharSubTitleFont", {
		font = font,
		weight = 200,
		size = ScreenScale(12),
		additive = true
	})
	surface.CreateFont("nutCharButtonFont", {
		font = font,
		weight = 200,
		size = ScreenScale(24),
		additive = true
	})
	surface.CreateFont("nutCharSmallButtonFont", {
		font = font,
		weight = 200,
		size = ScreenScale(22),
		additive = true
	})
	-- old
	surface.CreateFont("solaireCharSlot", {
		font = font,
		size = 48,
	})
	surface.CreateFont("solaireModal", {
		font = font,
		size = 24,
	})
end

function PLUGIN:NutScriptLoaded()
	vgui.Create("solaireCharacterSelection")
end

function PLUGIN:KickedFromCharacter(id, isCurrentChar)
	if (isCurrentChar) then
		vgui.Create("solaireCharacterSelection")
	end
end