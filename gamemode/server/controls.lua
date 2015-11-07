function GM:PlayerTick(ply, cmd)
	if IsValid(ply) && ply:Alive() then
		local weap = ""
		if IsValid(ply:GetActiveWeapon()) then weap = ply:GetActiveWeapon():GetClass() end

		-- switching to main weapon
		if ply:GetCurrentCommand():GetMouseWheel() > 0 && weap == "cc_weapon_hands" then
			if ply:HasWeapon( chopchop.settings.maniacMainWeapon ) then
				ply:SelectWeapon( chopchop.settings.maniacMainWeapon )
				--ply:EmitSound("chopchop/weapons/knife_deploy.wav",45)
				ply:ViewPunch(Angle(-0.8, math.random(-5,5)*0.01, math.random(-5,5)*0.15))
			end
			if ply:HasWeapon( chopchop.settings.bystanderGun ) then
				ply:SelectWeapon( chopchop.settings.bystanderGun )
				--ply:EmitSound("chopchop/weapons/magnum_deploy.wav",45)
				ply:ViewPunch(Angle(-0.8, math.random(-5,5)*0.01, math.random(-5,5)*0.15))
			end
		end
		
		-- switching from main weapon
		if ply:GetCurrentCommand():GetMouseWheel() < 0 then
			if weap == chopchop.settings.maniacMainWeapon then
				ply:SelectWeapon("cc_weapon_hands")
				--ply:EmitSound("chopchop/weapons/knife_holster.wav",35)
				ply:ViewPunch(Angle(0.8, math.random(-5,5)*0.01, math.random(-5,5)*0.15))
			end
			if weap == chopchop.settings.bystanderGun then
				ply:SelectWeapon("cc_weapon_hands")
				--ply:EmitSound("chopchop/weapons/magnum_holster.wav",45)
				ply:ViewPunch(Angle(0.8, math.random(-5,5)*0.01, math.random(-5,5)*0.15))
			end
		end
	end
end

function GM:PlayerButtonDown(ply, but)
	if ply && ply:HasWeapon("cc_weapon_hands") then
		if !IsValid( ply:GetActiveWeapon() ) then ply:SelectWeapon( "cc_weapon_hands" ) end
		local weap = ply:GetActiveWeapon():GetClass()

		if but == 18 && weap == "cc_weapon_hands" then
			ply:SelectWeapon("weapon_physgun")
		end
		if but == 18 && weap == "weapon_physgun" then
			ply:SelectWeapon("cc_weapon_hands")
		end
	end
end