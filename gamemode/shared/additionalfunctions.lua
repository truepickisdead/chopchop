function table.removekey(table, key)
    local element = table[key]
    table[key] = nil
    return element
end

function table.contains(table, val)
	for k,v in pairs(table) do
		if v == val then return k end
	end

	return nil
end

-- check if folder exists
function file.CheckFolder(name, location)
	if !file.Exists(name, location) then
		file.CreateDir(name)
		return false
	end

	return true
end

-- send and include on client shortcut for serverside scripts
if SERVER then
	util.AddNetworkString("ClientInclude")

	function chopchop:sendAndInclude( name )
		AddCSLuaFile( name )
		timer.Simple( 0, function ()
			net.Start( "ClientInclude" )
				net.WriteString( name )
			net.Broadcast()
		end)
	end
end

if CLIENT then
	net.Receive("ClientInclude", function (length)
		local name = net.ReadString()
		include( name )
	end)
end

-- returns a string 's' from translate module where substrings
-- '{m}...{n}' are replaced with '(m+1)th ... (n+1)th' arguments
function string:insert( ... )
	local args = { ... }
	local temp = self

	for k,v in pairs(args) do
		temp = string.gsub( temp, "{" .. k .. "}", v )
	end

	return temp
end

function math.inRange( val, min, max )
	return val > min && val < max 
end
