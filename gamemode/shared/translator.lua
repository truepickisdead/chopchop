-- returns a string 's' from translate module where substrings
-- '{m...n}' are replaced with '(m+1)th ... (n+1)th' arguments
function translate.make( s, ... )
	local args = { ... }
	local res = translate[s]

	for k,v in pairs(args) do
		res = string.gsub( res, "{" .. k .. "}", v )
	end

	return res
end