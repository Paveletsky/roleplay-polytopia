hook.Add( 'Think', 'init.cmds', function()
    hook.Remove('Think', 'init.cmds')

    --
    --  remove default drp commands
    --

    DarkRP.removeChatCommand( 'me' )
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

    DarkRP.declareChatCommand{
        command = "me",
        description = "Chat roleplay to say you're doing things that you can't show otherwise.",
        delay = 1.5
    }

    DarkRP.declareChatCommand{
        command = "doit",
        description = "Chat roleplay to say you're doing things that you can't show otherwise.",
        delay = 1.5
    }

    DarkRP.declareChatCommand{
        command = "yit",
        description = "Chat roleplay to say you're doing things that you can't show otherwise.",
        delay = 1.5
    }

    DarkRP.declareChatCommand{
        command = "wit",
        description = "Chat roleplay to say you're doing things that you can't show otherwise.",
        delay = 1.5
    }

    DarkRP.declareChatCommand{
        command = "yme",
        description = "Chat roleplay to say you're doing things that you can't show otherwise.",
        delay = 1.5
    }

    DarkRP.declareChatCommand{
        command = "wme",
        description = "Chat roleplay to say you're doing things that you can't show otherwise.",
        delay = 1.5
    }

end)