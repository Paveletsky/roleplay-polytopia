hook.Add( 'Think', 'init.cmds', function()
    hook.Remove('Think', 'init.cmds')

    polychat.Commands = polychat.Commands or {}

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

    function polychat.registerCommand( data )

        local cmd = data.cmd
        polychat.Commands[cmd] = data
        
    end
    
    -- polychat.Commands = {}


    polychat.registerCommand({
        cmd = 'doit',
        range = 300,
        result = function( v, ply, txt )
            netstream.Start( v, 'polychat.sendEmote', 'Окружение могло наблюдать ' .. txt .. ' (' .. ply .. ')' )
        end,
    })

    -- polychat.registerCommand({
    --     cmd = 'me',
    --     range = 300,
    --     result = function( v, ply, txt )
    --         netstream.Start( v, 'polychat.sendEmote', ply, ' ' .. txt )
    --     end,
    -- })

end)