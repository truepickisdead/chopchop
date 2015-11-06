function GM:HUDAmmoPickedUp( itemName, amount ) end
function GM:HUDWeaponPickedUp( weapon ) end
function GM:DrawDeathNotice( x, y ) end

local hideName = {
	CHudAmmo = true,
	CHudBattery = true,
	CHudCrosshair = true,
	CHudHealth = true,
	CHudWeaponSelection = true	
}
function GM:HUDShouldDraw( name )
	if hideName[ name ] then
		return false
	end
	
	return true
end

function GM:HUDDrawTargetID()
	-- TODO: implement targetID
end