local function ME(ply, args)
    if args == "" then
            ply:polychatNotify( 5, 'Уточни что ты делаешь =)' )
        return ""
    end

    local DoSay = function(text)
        if text == "" then
                ply:polychatNotify( 5, 'Уточни что ты делаешь =)' )
            return
        end

        -- ply:Emote(  )
        
    end
    return args, DoSay
end
DarkRP.defineChatCommand("todo", ME, true, 1.5)

Entity(1):Emote( 'lol' )