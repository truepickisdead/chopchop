-- initial values set at map start
chopchop.Stage = "WaitingForPlayers"
chopchop.Round = {
	Mode = "default",
	Count = 0,
	StartTime = nil,
	EndTime = nil
}

-- executed every tick
function chopchop:RoundThink()
	local players = team.NumPlayers(1)

	if players < 2 then
		chopchop.Stage = "WaitingForPlayers"
	end
	
	if chopchop.Stage == "WaitingForPlayers" && players > 1 then
		chopchop:StartRound( "default" )
	elseif chopchop.Stage == "Playing" then
		self:CheckForWin()
	elseif chopchop.Stage == "EndingRound" then
		if CurTime() > chopchop.Round.EndTime + chopchop.settings.rounds.restartTime then
			chopchop:StartRound( "default" )
		end
	end
end

function chopchop:StartRound( mode )
	game.CleanUpMap()

	chopchop.Round.Count = chopchop.Round.Count + 1
	chopchop.Round.Mode = mode
	chopchop.Stage = "Playing"

	for k,v in pairs( team.GetPlayers(1) ) do
		if v:Alive() then v:KillSilent() end
		v:SetNWBool( "Died", false )
		v:Spawn()
	end

	local plys = player.GetAll()
	self.Maniac = table.Random( plys )

	local bystanders = table.Copy( plys )
	table.RemoveByValue( bystanders, self.Maniac )
	table.Random( bystanders ):Give( chopchop.settings.bystanderGun )

	for k, ply in pairs( plys ) do
		-- set one random player as maniac
		ply.IsManiac = self.Maniac == ply and true or false
		
		-- loadout player
		self:PlayerLoadout( ply )
	end

	if chopchop.settings.debug then chopchop.chat:Send(
		player.GetAll(),
		chopchop.settings.colors.chatMsgInfo, "Round started"
	) end
end

function chopchop:CheckForWin()
	plysAlive = {}

	for k,ply in pairs( team.GetPlayers(1) ) do
		if ply:Alive() && !ply:GetNWBool( "Died", false ) then table.insert( plysAlive, ply ) end
	end

	if ( #plysAlive < 2 ) then
		chopchop:EndRound( "whatever" )
	end
end

function chopchop:EndRound( reason )
	chopchop.Stage = "EndingRound"
	chopchop.Round.EndTime = CurTime()

	if chopchop.settings.debug then chopchop.chat:Send(
		player.GetAll(),
		chopchop.settings.colors.chatMsgInfo, "[DEBUG] Round ended, restarting soon..."
	) end
end

function GM:PlayerDeathThink( ply )
	deathTime = ply:GetNWFloat( "DeathTime" )

	-- true to respawn, false to prevent
	if deathTime && CurTime() > deathTime + chopchop.settings.ghostSpawnDelay || chopchop.Stage == "WaitingForPlayers" then
		ply:Spawn()
	end
	if chopchop.settings.debug && chopchop.Stage == "WaitingForPlayers" then chopchop.chat:Send(
		player.GetAll(),
		chopchop.settings.colors.chatMsgInfo, "[DEBUG] Not enough players, wait until someone else joins"
	) end

	return false
end