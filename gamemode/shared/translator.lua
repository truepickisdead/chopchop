-- returns a string 's' from translate module where substrings
-- '{m...n}' are replaced with '(m+1)th ... (n+1)th' arguments
function translate.make( s, ... )
	return translate[s]:insert( ... )
end