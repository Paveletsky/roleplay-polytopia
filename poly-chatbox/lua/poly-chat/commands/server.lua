function polychat.registerCommand( data )

    local cmd = data.cmd
    polychat.Commands[cmd] = data
    
end

polychat.registerCommand({
    cmd = '/it',
    range = 300,
    result = function( v, ply )
        netstream.Start( v, 'polychat.sendEmote', ply, ' ебат собаку')
    end,
})

-- print('lol')