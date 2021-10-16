if CLIENT then

    color_types = {

        [0] = Color(46, 74, 217), -- Generic

        [1] = Color(201, 42, 61),

        [2] = Color(46, 74, 217),

        [3] = Color(46, 74, 217),

        [4] = Color(75, 250, 104)

    }

    

    local function addText(_type, text)

        if not text then text = " " end

        if not _type then _type = 0 end

        

        _type = color_types[_type] or Color(52, 235, 146)

    

        chat.AddText(_type, '[~]', Color(249, 174, 71), ' ' .. text)

    end

    

    function notification.AddLegacy(text, _type, _)

        addText(_type, text)

    end

    

    net.Receive( 'NotificationChat', function(_)

        local text = net.ReadString()

        local _type = net.ReadInt(3)

        addText(_type, text)

    end )

else

    function NNotify( ply, _type, text )

        if not IsValid( ply ) or not isstring( text ) then return end

        if not _type then _type = 1 end

        net.Start( 'NotificationChat' )

            net.WriteInt(_type, 3)

            net.WriteString( tostring( text ) )

        net.Send( ply )

    end

end

hook.Add("ChatText", "hide_joinleave", function( index, name, text, typ )

	if typ == "joinleave" then return true end

end)
