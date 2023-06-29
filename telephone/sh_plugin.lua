PLUGIN.name = "Communication"
PLUGIN.desc = "Telephone, radios and a p2p library!"
PLUGIN.author = "It's A Joke"
PLUGIN.dependencies = "wolflib, iconFonts"

resource.AddFile("sound/ag_wolfensteinrp/phonering.wav")
nut.util.include("cl_telephone_dialer.lua")

function GetAllPhoneNumbers()
	local nums = {}
	for k,v in pairs(ents.FindByClass("telephone")) do
		nums[v:getNetVar("number")] = v
	end

	return nums
end

if SERVER then
	--Net stuff
	netstream.Hook("startPhoneCall", function(ply, ephone, num)
		local e = GetAllPhoneNumbers()[num]
		if not e:getNetVar("ringing", false) then
			e:RingStart(ply, ephone:getNetVar("number"))
			e:setNetVar("caller", ply)
		else
			ply:notify("The number is already in use, please retry later.", 3)
		end
	end)

	netstream.Hook("respondPhoneCall", function(ply, ephone)
		local caller = ephone:getNetVar("caller")
		if not caller then
			return
		end
		
		--Update caller
		netstream.Start(caller, "updateCallListener", {
			update = "respond"
		})

		--Connecting the 2 players
		print("Connecting 2 players in a call", ply, caller)
		caller:setNetVar("talkingTo", ply)
		ply:setNetVar("talkingTo", caller)
	end)

	netstream.Hook("updateCallCaller", function(ply, data)
		if data.update == "hangup" then
			local caller = data.caller or GetAllPhoneNumbers()[data.num]:getNetVar("caller")
			
			--Updating caller
			netstream.Start(caller,"updateCallListener", {
				update = "hangup"
			})

			local phone = GetAllPhoneNumbers()[data.num]
			if phone:getNetVar("ringing", false) then
				phone:RingStop()
			end
			
			--Resetting netvar
			print("Resetting connection between 2 players", ply, caller)
			ply:setNetVar("talkingTo", nil)
			caller:setNetVar("talkingTo", nil)
		end
	end)
	
	function PLUGIN:SaveData()
		local data = {}
		for k,v in pairs(ents.FindByClass("telephone")) do
			data[#data + 1] = duplicator.CopyEntTable(v)
		end
		self:setData(data)
	end
	
	function PLUGIN:LoadData()
		local pasteData = self:getData() or {}
		duplicator.Paste(nil, pasteData, {})
	end
end

--Handles who can hear who
hook.Add("PlayerCanHearPlayersVoice", "phoneCallings", function(listener, talker)
	if talker:getNetVar("talkingTo", nil) and talker:getNetVar("talkingTo") == listener then
		if listener:getNetVar("talkingTo", nil) and listener:getNetVar("talkingTo") == talker then
			return true
		end
	end
end)

--Adds to ability to create circles ;)
if CLIENT then
	function draw.Circle( x, y, radius, seg )
		local cir = {}

		table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
		for i = 0, seg do
			local a = math.rad( ( i / seg ) * -360 )
			table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
		end

		local a = math.rad( 0 ) -- This is needed for non absolute segment counts
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

		surface.DrawPoly( cir )
	end
end