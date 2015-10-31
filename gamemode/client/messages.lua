hook.Add("ChatText", "HideMSG", function( _, _, _, msg )
    if msg == "joinleave" then return true end
end)

-- ====
-- CHAT
-- ====

net.Receive("ChatSentToClient", function (length)
	local dat = net.ReadTable()
	chat.AddText( unpack(dat) )
end)