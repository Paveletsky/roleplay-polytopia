color_types = {
    [0] = Color(46, 74, 217), -- Generic
    [1] = Color(201, 42, 61),
    [2] = Color(46, 74, 217),
    [3] = Color(46, 74, 217),
    [4] = Color(75, 250, 104)
}

function polychat.polyMsg(_type, text)

    if not text then text = " " end
    if not _type then _type = 0 end

    _type = color_types[_type] or Color(52, 235, 146)
    chat.AddText(_type, '<~>', Color(249, 174, 71), ' ' .. text)

end

function notification.AddLegacy(text, _type, _)

    polychat.polyMsg(_type, text)

end

netstream.Hook( 'poly.sendNotify', function( t, txt ) 

    polychat.polyMsg( t, txt )

end)

    polychat.polyMsg(1, 'Мать жива?')

DarkRP.removeChatCommand( 'me' )