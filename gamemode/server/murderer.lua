GM.Maniac = nil

function GM:RoundStarted( mode )
	local plys = player.GetAll()
	self.Maniac = table.Random( plys )

	local bystanders = table.Copy( plys )
	table.RemoveByValue( bystanders, self.Maniac )
	table.Random( bystanders ):Give( chopchop.settings.bystanderGun )

	for k, ply in pairs( plys ) do
		ply.IsManiac = self.Maniac == ply and true or false
		
		-- loadout player
		self:PlayerLoadout( ply )
	end
end