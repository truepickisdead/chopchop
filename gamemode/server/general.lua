function GM:Think()
	chopchop:RoundThink()
	chopchop:PlayerThink()
end

function chopchop:FindSuitablePosition( pos, ent, dist, filtr )
	-- NOTE: ply size: (32, 32, 72)
	local function checkPos( pos )
		local trace = { start = pos, endpos = pos, filter = filtr }
		local tr = util.TraceEntity( trace, ent )

		return !tr.Hit
	end

	-- check initial position
	if checkPos( pos ) then return pos end

	-- find a place around
	local testpos
	for i = 0, 300, 60 do
		testpos = pos + Angle( 0, i, 0):Forward() * dist.around
		if checkPos( testpos ) then return testpos end
	end

	-- check a place above
	testpos = pos + Vector( 0, 0, dist.above )
	if checkPos( pos + Vector( 0, 0, dist.above ) ) then return testpos end

	-- if we haven't found any place
	return false
end
