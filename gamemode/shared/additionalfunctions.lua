function table.removekey(table, key)
    local element = table[key]
    table[key] = nil
    return element
end

function file.CheckFolder(name, location)
	if !file.Exists(name, location) then
		file.CreateDir(name)
		return false
	end

	return true
end

if SERVER then
	util.AddNetworkString("ClientInclude")

	function chopchop:sendAndInclude( name )
		AddCSLuaFile( name )
		net.Start( "ClientInclude" )
			net.WriteString( name )
		net.Broadcast()
	end
end

if CLIENT then
	net.Receive("ClientInclude", function (length)
		local name = net.ReadTable()
		include( name )
	end)
end

-- returns a string 's' from translate module where substrings
-- '{m...n}' are replaced with '(m+1)th ... (n+1)th' arguments
function string:insert( ... )
	local args = { ... }
	local temp = self

	for k,v in pairs(args) do
		temp = string.gsub( temp, "{" .. k .. "}", v )
	end

	return temp
end
