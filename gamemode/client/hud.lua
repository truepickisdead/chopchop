function GM:HUDAmmoPickedUp( itemName, amount ) end
function GM:HUDWeaponPickedUp( weapon ) end
function GM:DrawDeathNotice( x, y ) end

local hideName = {
	CHudAmmo = true,
	CHudBattery = true,
	CHudCrosshair = true,
	CHudHealth = true,
	CHudDamageIndicator = true,
	CHudWeaponSelection = true
}
function GM:HUDShouldDraw( name )
	if hideName[ name ] then
		return false
	end
	
	return true
end

-- disable default targetID
function GM:HUDDrawTargetID() end

-- detect 3d context to display
chopchop.labels3d = {}

hook.Add("Think", "HUDTargetThink", function ()
	if LocalPlayer():Alive() then
		local canSeeGhostNames = LocalPlayer():GetNWBool( "Died" )
		local ignorePlayers = { LocalPlayer() }
		for k,ply in pairs( player.GetAll() ) do
			if !canSeeGhostNames && ply:GetNWBool( "Died" ) then
				table.insert( ignorePlayers, ply )
			end
		end

		local tr = util.GetPlayerTrace( LocalPlayer() )
		tr.filter = ignorePlayers
		local trace = util.TraceLine( tr )
		if ( !trace.Hit || trace.HitWorld ) then return end
		
		local _text = "ERROR!1!!1"
		local _altText = "some more error"
		local _offset = 0

		-- set view distance
		local dist = LocalPlayer():GetPos():Distance( trace.Entity:GetPos() )
		if dist > chopchop.settings.playerLabels.viewDist then return end
		
		-- avoid duplicates in table
		for k,v in pairs(chopchop.labels3d) do
			if v.entity == trace.Entity && dist <= chopchop.settings.playerLabels.viewDist then
				-- update time and exit
				v.hideTime = CurTime() + chopchop.settings.playerLabels.labelHideDelay
				if (dist <= chopchop.settings.playerLabels.viewDistAlt) then
					if (!v.altTextActive) then
						v.spawnAltTime = CurTime()
						v.altTextActive = true
					end
					v.hideAltTime = CurTime() + chopchop.settings.playerLabels.labelHideDelay
				else
					v.altTextActive = false
				end
				return
			end
		end

		-- detect only defined entities
		if trace.Entity:IsPlayer() then
			-- players
			_text = trace.Entity:GetNWString( "CCName" )
			_altText = trace.Entity:Nick()
			if trace.Entity:Crouching() then _offset = 60
			else _offset = 80 end
		elseif (trace.Entity:GetClass() == "prop_ragdoll") then
			-- ragdolls
			_text = trace.Entity:GetNWString( "CCName" )
			_offset = 30
		else
		-- if not one of them, exit
			return
		end

		-- add data to table
		local labeldata = {
			entity = trace.Entity,
			text = _text,
			altText = _altText,
			offset = _offset,
			spawnTime = CurTime(),
			hideTime = CurTime() + chopchop.settings.playerLabels.labelHideDelay,
			altTextActive = false,
			spawnAltTime = (dist <= chopchop.settings.playerLabels.viewDistAlt) and CurTime() or 0,
			hideAltTime = (dist <= chopchop.settings.playerLabels.viewDistAlt) and CurTime() + chopchop.settings.playerLabels.labelHideDelay or 0
		}

		table.insert(chopchop.labels3d, labeldata)
	end
end)

-- render 3D hud
hook.Add("PostDrawTranslucentRenderables", "Octo3DHUD", function()
	if LocalPlayer():Alive() then
		for k,v in pairs(chopchop.labels3d) do
			if v.hideTime <= CurTime() || !IsValid(v.entity) then
				-- if label is "timed out" delete it
				table.removekey(chopchop.labels3d, k)
			else
				-- if not, display it
				local trace = v.entity:GetPos() - LocalPlayer():GetShootPos() + Vector(0, 0, v.offset - 15)
				local textAng = Angle(0, trace:Angle().y - 90, -trace:Angle().p + 90)

				local opacity = (CurTime() - v.spawnTime < chopchop.settings.playerLabels.labelFadeIn)
					and (CurTime() - v.spawnTime) / chopchop.settings.playerLabels.labelFadeIn
					or math.Clamp( (v.hideTime - CurTime()) / chopchop.settings.playerLabels.labelFadeOut, 0, 1 )

				--[[local altopacity = (CurTime() - v.spawnAltTime < chopchop.settings.playerLabels.labelFadeIn)
					and (CurTime() - v.spawnAltTime) / chopchop.settings.playerLabels.labelFadeIn
					or math.Clamp( (v.hideAltTime - CurTime()) / chopchop.settings.playerLabels.labelFadeOut, 0, 1 )]]

				local color = v.entity:GetNWVector( "CCColor", Vector( 0, 0, 0 ) )

				if ( v.entity:IsPlayer() ) then
					if v.entity:Crouching() && v.offset == 80 then v.offset = 60
					elseif !v.entity:Crouching() && v.offset == 60 then v.offset = 80 end
				end

				opacity = ( v.entity:GetNWBool( "Died" ) && v.entity:GetClass() ~= "prop_ragdoll" ) and
					chopchop.settings.playerLabels.ghostLabelOpacity*opacity or opacity

				cam.Start3D2D( v.entity:GetPos() + Vector(0, 0, v.offset), textAng, 0.12 )
			        draw.DrawText(v.text, "Octo3DHUDmid", 5, -27, Color(0, 0, 0, 25 * opacity), TEXT_ALIGN_CENTER )
			        draw.DrawText(v.text, "Octo3DHUDmid", 4, -28, Color(0, 0, 0, 50 * opacity), TEXT_ALIGN_CENTER )
			        draw.DrawText(v.text, "Octo3DHUDmid", 3, -29, Color(0, 0, 0, 75 * opacity), TEXT_ALIGN_CENTER )
			        draw.DrawText(v.text, "Octo3DHUDmid", 2, -30, Color(0, 0, 0, 100 * opacity), TEXT_ALIGN_CENTER )
			        draw.DrawText(v.text, "Octo3DHUDmid", 1, -31, Color(0, 0, 0, 150 * opacity), TEXT_ALIGN_CENTER )
			        draw.DrawText(v.text, "Octo3DHUDmid", 0, -32, Color( color.x * 255, color.y * 255, color.z * 255, 255 * opacity), TEXT_ALIGN_CENTER )

			        --[[draw.DrawText(v.altText, "Octo3DHUDsmall", 3, 31, Color(0, 0, 0, 75 * altopacity * opacity), TEXT_ALIGN_CENTER )
			        draw.DrawText(v.altText, "Octo3DHUDsmall", 2, 30, Color(0, 0, 0, 150 * altopacity * opacity), TEXT_ALIGN_CENTER )
			        draw.DrawText(v.altText, "Octo3DHUDsmall", 1, 29, Color(0, 0, 0, 200 * altopacity * opacity), TEXT_ALIGN_CENTER )
			        draw.DrawText(v.altText, "Octo3DHUDsmall", 0, 28, Color(255, 255, 255, 255 * altopacity * opacity), TEXT_ALIGN_CENTER )]]
				cam.End3D2D()
			end
		end
	end
end)

-- DISABLED BASE FUNCTIONS
function GM:HUDDrawTargetID() end
function GM:DrawDeathNotice( x, y ) end