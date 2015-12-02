-- fix for clients to fisplay color on ragdolls
local EntityMeta = FindMetaTable("Entity")
function EntityMeta:GetPlayerColor()
	return self:GetNWVector("CCColor") or Vector()
end

hook.Add( "Think", "PlayerRender", function()
	local imDead = LocalPlayer():GetNWBool( "Died", false )

	for k, ply in pairs( player.GetAll() ) do
		local dead = ply:GetNWBool( "Died", false )

		if imDead then
			ply:SetColor( chopchop.settings.colors.ghosts )
		else
			if dead then
				ply:SetColor( Color( 255, 255, 255, 0 ) )
			else
				ply:SetColor( chopchop.settings.colors.ghosts )
			end
		end
	end
end)

hook.Add( "HUDPaint", "DrawGhostOverlay", function()
	if LocalPlayer():GetNWBool( "Died" ) then
		local isGhost = CurTime() > LocalPlayer():GetNWFloat( "DeathTime" ) + chopchop.settings.ghostSpawnDelay
		local percent = !isGhost and
			((CurTime() - LocalPlayer():GetNWFloat( "DeathTime" )) / chopchop.settings.ghostSpawnDelay) or
			(math.Clamp( 1 - (( CurTime() - LocalPlayer():GetNWFloat( "DeathTime" ) - chopchop.settings.ghostSpawnDelay ) / chopchop.settings.ghostFadeInDelay), 0, 1 ))

		local deathColors = {
			[ "$pp_colour_addr" ] = 0,
			[ "$pp_colour_addg" ] = 0,
			[ "$pp_colour_addb" ] = isGhost and 0.01 + 0.19*percent or 0.2*percent,
			[ "$pp_colour_brightness" ] = -0.1*percent,
			[ "$pp_colour_contrast" ] = 1 - 0.6*percent,
			[ "$pp_colour_colour" ] = (isGhost and 0.5 or 1)*(1 - percent),
			[ "$pp_colour_mulr" ] = 0,
			[ "$pp_colour_mulg" ] = 0,
			[ "$pp_colour_mulb" ] = 0
		}

		if isGhost then DrawMaterialOverlay( "models/props/cs_office/clouds", 1-percent ) end
		if percent ~= 0 && CurTime() > LocalPlayer():GetNWFloat( "DeathTime" ) + 0.2 then
			DrawMotionBlur( 0, percent, 0.02 )
			DrawBloom( (1 - percent*1.2)^2, 2, 9, 9, 3, 1, 1, 1, 1 )
		end
		
		DrawColorModify( deathColors )
	else
		local percent = 0

		if ( chopchop.Round.StartTime && CurTime() < chopchop.Round.StartTime + chopchop.settings.ghostFadeInDelay ) then
			percent = (1 - (CurTime() - chopchop.Round.StartTime) / chopchop.settings.ghostFadeInDelay )
		end

		local deathColors = {
			[ "$pp_colour_addr" ] = 0,
			[ "$pp_colour_addg" ] = 0,
			[ "$pp_colour_addb" ] = 0.1*percent,
			[ "$pp_colour_brightness" ] = 0.05*percent,
			[ "$pp_colour_contrast" ] = (1 - percent)^2,
			[ "$pp_colour_colour" ] = 1,
			[ "$pp_colour_mulr" ] = 0,
			[ "$pp_colour_mulg" ] = 0,
			[ "$pp_colour_mulb" ] = 0
		}
		
		if percent ~= 0 then DrawColorModify( deathColors ) end	
	end
end)

function MyCalcView( ply, origin, angles, fov )
	if ply:GetNWBool( "Died" ) then
		local body = ply:GetNWEntity( "DeathRagdoll" )
		if !body or !IsValid( body ) or body == NULL then return end

		if CurTime() < ply:GetNWFloat( "DeathTime" ) + chopchop.settings.ghostSpawnDelay then
			local head = body:LookupBone( "ValveBiped.Bip01_Head1" )
			body:ManipulateBoneScale( head, Vector( 0, 0, 0) )
			local eyes = body:GetAttachment( body:LookupAttachment( "eyes" ) )
			local view = {
				origin = eyes.Pos - eyes.Ang:Forward() * 6,
				angles = eyes.Ang,
				fov = 90
			}

			return view
		else
			local head = body:LookupBone( "ValveBiped.Bip01_Head1" )
			body:ManipulateBoneScale( head, Vector( 1, 1, 1) )
		end
	end
end

hook.Add( "CalcView", "FPDeath", MyCalcView )
