if SERVER then
	AddCSLuaFile( "shared.lua" )

	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
else
	SWEP.PrintName  		= "Hands (but who cares?)"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 1
	SWEP.ViewModelFOV		= 60
end

SWEP.HoldType = "normal"

SWEP.ViewModel	= "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel	= "models/weapons/w_crowbar.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"


function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:DrawShadow(false)
end

function SWEP:Deploy()
	if SERVER then
		self:SetColor(255,255,255,0)
		if IsValid(self.Owner) then
			timer.Simple(0,function ()
				if IsValid(self) && IsValid(self.Owner) then
					self.Owner:DrawViewModel(false)
				end
			end)
		end
	end
	
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:PrimaryAttack()
	
end

function SWEP:SecondaryAttack()
	
end

function SWEP:Think()
	
end

function SWEP:DrawWorldModel()

end
