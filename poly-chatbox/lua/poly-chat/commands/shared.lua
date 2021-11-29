-- hook.Add( 'polylib.init', 'chatinit', function()

--     DarkRP.removeChatCommand( 'me' )

-- end)

--
--  remove default drp commands
--

-- DarkRP.removeChatCommand( 'me' )
-- DarkRP.removeChatCommand( 'w' )
-- DarkRP.removeChatCommand( 'y' )
-- DarkRP.removeChatCommand( '//' )
-- DarkRP.removeChatCommand( '/' )
-- DarkRP.removeChatCommand( 'ooc' )
-- DarkRP.removeChatCommand( 'a' )
-- DarkRP.removeChatCommand( 'broadcast' )
-- DarkRP.removeChatCommand( 'channel' )
-- DarkRP.removeChatCommand( 'radio' )
-- DarkRP.removeChatCommand( 'group' )
-- DarkRP.removeChatCommand( 'credits' )

--
--  register custom commands
--

DarkRP.declareChatCommand{
    command = "todo",
    description = "Круто",
    delay = 1.5
}