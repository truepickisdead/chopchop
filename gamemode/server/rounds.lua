-- initial values set at map start
GM.Stage = "WaitingForPlayers"
GM.Round = {
	Count = 0,
	StartTime = nil,
	EndTime = nil
}

-- executed every tick
function GM:RoundThink()
	local players = team.GetPlayers(1)

	if #players < 2 then
		self.Stage = "WaitingForPlayers"
	end
	
	if self.Stage == "WaitingForPlayers" && #players > 1 then
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
	self.Round.Count = self.Round.Count + 1
	self.Stage = "Playing"

	for k,v in pairs( team.GetPlayers(1) ) do
		if v:Alive() then v:KillSilent() end
		v:Spawn()
	end
	game.CleanUpMap()

	if chopchop.settings.debug then chopchop.chat:Send(
		player.GetAll(),
		chopchop.settings.colors.chatMsgInfo, "Round started"
	) end
end

function GM:CheckForWin()
	plysAlive = {}

	for k,ply in pairs( team.GetPlayers(1) ) do
		if ply:Alive() then table.insert( plysAlive, ply ) end
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
		chopchop.settings.colors.chatMsgInfo, "Round ended, restarting soon..."
	) end
end

function GM:PlayerDeathThink( ply )
	if self.Stage ~= "WaitingForPlayers" then return false end

	ply:Spawn()
	if chopchop.settings.debug then chopchop.chat:Send(
		player.GetAll(),
		chopchop.settings.colors.chatMsgInfo, "Not enough players, wait until someone else joins"
	) end
	return true
end