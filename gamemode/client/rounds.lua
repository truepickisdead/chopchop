chopchop.Round = {}

net.Receive( "StartRound", function()
	chopchop.Round.StartTime = CurTime()
end)