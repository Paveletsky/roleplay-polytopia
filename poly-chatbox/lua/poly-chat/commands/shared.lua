hook.Add( 'Think', 'init.cmds', function()
    hook.Remove('Think', 'init.cmds')

    --
    --  remove default drp commands
    --

    -- DarkRP.removeChatCommand( 'me' )
    DarkRP.removeChatCommand( 'w' )
    DarkRP.removeChatCommand( 'y' )
    DarkRP.removeChatCommand( '//' )
    DarkRP.removeChatCommand( '/' )
    DarkRP.removeChatCommand( 'ooc' )
    DarkRP.removeChatCommand( 'a' )
    DarkRP.removeChatCommand( 'broadcast' )
    DarkRP.removeChatCommand( 'channel' )
    DarkRP.removeChatCommand( 'radio' )
    DarkRP.removeChatCommand( 'group' )
    DarkRP.removeChatCommand( 'credits' )
    
    --
    --  register custom commands
    --



end)