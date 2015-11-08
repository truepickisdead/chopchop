function GM:PlayerCanHear( listener, talker )
	-- ghosts can hear anyone
	if listener:GetNWBool( "Died" ) == false && talker:GetNWBool( "Died" ) then
		return false
	end

	return true
end

function GM:PlayerCanHearPlayersVoice( listener, talker )
	return self:PlayerCanHear( listener, talker ), true
end
