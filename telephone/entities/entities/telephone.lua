ENT.Type = "anim"
ENT.PrintName = "Telephone"
ENT.Category = "NutScript"
ENT.Spawnable = true
ENT.AdminOnly = true

if (SERVER) then
	TAKEN_NUMBERS = TAKEN_NUMBERS or {}

	function ENT:Initialize()
		self:SetModel("models/polievka/wallphone.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end

		self:setNetVar("ringing", false)
		self:setNetVar("inUse", false)

		self:GenerateNumber()
	end
	
	function ENT:GenerateNumber()
		local tries = 100
		local setNumber = false
		while (tries > 0) do
			local generatedNum = "448" .. tostring(math.random(1111111, 9999999))
			if (TAKEN_NUMBERS[generatedNum] == nil) then
				TAKEN_NUMBERS[generatedNum] = true
				self:SetNumber(generatedNum)
				self:setNetVar("number", generatedNum)
				setNumber = true
				break
			end
			tries = tries - 1
		end
		if (!setNumber) then
			ScriptLog("Telephone removed due to inability to find non-taken number in 100 tries. (the hell?)")
			self:Remove()
		end
	end
	
	function ENT:OnDuplicated(entTbl)
		if (entTbl.DT.Number) then
			if (self:GetNumber()) then
				TAKEN_NUMBERS[self:GetNumber()] = nil
			end
			
			if (TAKEN_NUMBERS[entTbl.DT.Number]) then
				self:GenerateNumber()
			else
				TAKEN_NUMBERS[entTbl.DT.Number] = true
				self:SetNumber(entTbl.DT.Number)
				self:setNetVar("number", entTbl.DT.Number)
			end
		end
	end
	

	function ENT:Use(ply)
		netstream.Start(ply, "OpenPhoneDialer", self, false)

		self:setNetVar("user", ply)
		if self:getNetVar("ringing", false) then
			self:RingStop(self:getNetVar("caller"))
		end
	end

	function ENT:RingStart(caller, num)
		self:setNetVar("ringing", true)
		self:setNetVar("caller", caller)
		self:setNetVar("callerNum", num)
		self.ring = CreateSound(self, "ag_wolfensteinrp/phonering.wav")
		self.ring:Play()
	end

	function ENT:RingStop()
		self:setNetVar("ringing", false)
		self.ring:Stop()
		self.ring = nil
	end

	function ENT:ResetVars()
		self:setNetVar("caller", nil)
		self:setNetVar("callerNum", nil)
	end
	
	function ENT:OnRemove()
		TAKEN_NUMBERS[self:GetNumber()] = nil
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Number")
end

