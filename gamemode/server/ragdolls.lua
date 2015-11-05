chopchop.DeathRagdolls = {}
local PM = FindMetaTable("Player")
local EM = FindMetaTable("Entity")
local maxPerPlayer = chopchop.settings.maxCorpsesPerPlayer
local maxPerServer = chopchop.settings.maxCorpsesPerServer

function PM:CreateRagdoll( attacker, dmginfo )
	local ent = self:GetNWEntity("DeathRagdoll")

	-- remove old player ragdolls
	if !self.DeathRagdolls then self.DeathRagdolls = {} end
	local numPlyR = 1
	for k,rag in pairs(self.DeathRagdolls) do
		if IsValid(rag) then
			numPlyR = numPlyR + 1
		else
			self.DeathRagdolls[k] = nil
		end
	end
	if maxPerPlayer >= 0 && numPlyR > maxPerPlayer then
		for i = 0,numPlyR do
			if numPlyR > maxPerPlayer then
				self.DeathRagdolls[1]:Remove()
				table.remove(self.DeathRagdolls, 1)
				numPlyR = numPlyR - 1
			else
				break
			end
		end
	end

	-- remove old server ragdolls
	local c2 = 1
	for k,rag in pairs(chopchop.DeathRagdolls) do
		if IsValid(rag) then
			c2 = c2 + 1
		else
			chopchop.DeathRagdolls[k] = nil
		end
	end
	if maxPerServer >= 0 && c2 > maxPerServer then
		for i = 0,c2 do
			if c2 > maxPerServer then
				chopchop.DeathRagdolls[1]:Remove()
				table.remove(chopchop.DeathRagdolls,1)
				c2 = c2 - 1
			else
				break
			end
		end
	end

	local Data = duplicator.CopyEntTable( self )

	local ent = ents.Create( "prop_ragdoll" )
		duplicator.DoGeneric( ent, Data )
	ent:Spawn()
	ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	ent:Fire("kill","",60 * 8)
	if ent.SetPlayerColor then
		ent:SetPlayerColor(self:GetPlayerColor())
	end
	ent:SetNWEntity("RagdollOwner", self)
	
	ent.Corpse = {}
	ent.Corpse.Name = self:Nick()
	ent.Corpse.CauseDeath = ""
	ent.Corpse.Attacker = ""
	if IsValid(attacker) && attacker:IsPlayer() then
		if attacker == self then
			if ent.Corpse.CauseDeath == "" then
				ent.Corpse.CauseDeath = "Suicide"
			end
		else
			ent.Corpse.Attacker = attacker:Nick()
		end
	end

	-- set velocity for every bone in created corpse
	-- TODO: set velocity only on bone that was hit
	local Vel = self:GetVelocity()

	local iNumPhysObjects = ent:GetPhysicsObjectCount()
	for Bone = 0, iNumPhysObjects-1 do

		local PhysObj = ent:GetPhysicsObjectNum( Bone )
		if IsValid(PhysObj) then

			local Pos, Ang = self:GetBonePosition( ent:TranslatePhysBoneToBone( Bone ) )
			PhysObj:SetPos( Pos )
			PhysObj:SetAngles( Ang )
			PhysObj:AddVelocity( Vel )

		end

	end

	-- finish up
	self:SetNWEntity( "DeathRagdoll", ent )
	table.insert( self.DeathRagdolls, ent )
	table.insert( chopchop.DeathRagdolls, ent )
end

if !PM.GetRagdollEntityOld then
	PM.GetRagdollEntityOld = PM.GetRagdollEntity
end
function PM:GetRagdollEntity()
	local ent = self:GetNWEntity("DeathRagdoll")
	if IsValid(ent) then
		return ent
	else
		return self:GetRagdollEntityOld()
	end
end

if !PM.GetRagdollOwnerOld then
	PM.GetRagdollOwnerOld = PM.GetRagdollOwner
end
function EM:GetRagdollOwner()
	local ent = self:GetNWEntity("RagdollOwner")
	if IsValid(ent) then
		return ent
	end
	return self:GetRagdollOwnerOld()
end

function GM:RagdollSetDeathDetails(victim, inflictor, attacker) 
	local rag = victim:GetRagdollEntity()
	if rag then
		if IsValid(inflictor) && inflictor:IsWeapon() then
			if inflictor.PrintName then
				rag.Corpse.inflictor = inflictor.PrintName
			else
				rag.Corpse.inflictor = inflictor:GetClass()
			end
		end
	end
end