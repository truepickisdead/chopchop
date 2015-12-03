-- hide default join and leave messages
hook.Add("ChatText", "HideMSG", function( _, _, _, msg )
    if msg == "joinleave" then return true end
end)

-- ==================
-- =====< CHAT >=====
-- ==================

-- get and display incoming messages
net.Receive("CC_ChatSentToClient", function (length)
	local dat = net.ReadTable()
	chat.AddText( unpack(dat) )
end)