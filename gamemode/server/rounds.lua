-- initial values set at map start
GM.Stage = "WaitingForPlayers"
GM.Round = {
	Mode = "",
	Count = 0,
	StartTime = nil,
	EndTime = nil
}

-- executed every tick
function GM:RoundThink()
	local players = team.NumPlayers(1)

	if players < 2 then
		self.Stage = "WaitingForPlayers"
	end
	
	if self.Stage == "WaitingForPlayers" && players > 1 then
		self:StartRound( "default" )
	elseif self.Stage == "Playing" then
		self:CheckForWin()
	elseif self.Stage == "EndingRound" then
		if CurTime() > self.Round.EndTime + chopchop.settings.rounds.restartTime then
			self:StartRound( "default" )
		end
	end
end

function GM:StartRound( mode )
	game.CleanUpMap()

	self.Round.Count = self.Round.Count + 1
	self.Round.Mode = mode
	self.Stage = "Playing"

	for k,v in pairs( team.GetPlayers(1) ) do
		if v:Alive() then v:KillSilent() end
		v:SetNWBool( "Died", false )
		v:Spawn()
	end

	if chopchop.settings.debug then chopchop.chat:Send(
		player.GetAll(),
		chopchop.settings.colors.chatMsgInfo, "Round started"
	) end

	self:RoundStarted( mode )
end

function GM:CheckForWin()
	plysAlive = {}

	for k,ply in pairs( team.GetPlayers(1) ) do
		if ply:Alive() && !ply:GetNWBool( "Died", false ) then table.insert( plysAlive, ply ) end
	end

	if ( #plysAlive < 2 ) then
		self:EndRound( "whatever" )
	end
end

function GM:EndRound( reason )
	self.Stage = "EndingRound"
	self.Round.EndTime = CurTime()

	if chopchop.settings.debug then chopchop.chat:Send(
		player.GetAll(),
		chopchop.settings.colors.chatMsgInfo, "[DEBUG] Round ended, restarting soon..."
	) end
end

function GM:PlayerDeathThink( ply )
	deathTime = ply:GetNWFloat( "DeathTime" )

	-- true to respawn, false to prevent
	if deathTime && CurTime() > deathTime + chopchop.settings.ghostSpawnDelay || self.RoundStage == "WaitingForPlayers" then
		ply:Spawn()
	end
	if chopchop.settings.debug && self.RoundStage == "WaitingForPlayers" then chopchop.chat:Send(
		player.GetAll(),
		chopchop.settings.colors.chatMsgInfo, "[DEBUG] Not enough players, wait until someone else joins"
	) end

	return false
end