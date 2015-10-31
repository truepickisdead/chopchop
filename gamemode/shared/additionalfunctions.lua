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