local function getCharName(ply) 

    return ply:GetNetVar( 'char.name' )

end

local function Me(ply, args)
    if args == "" then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
        return ""
    end

    local DoSay = function(text)
        if text == "" then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
            return ""
        end

        local col = Color(250, 160, 0)
        for _, target in ipairs( who_can_hear( ply:GetPos(), 2 ) ) do
            DarkRP.talkToPerson(target, col, getCharName(ply) .. " " .. text)
        end

    end
    return args, DoSay
end
DarkRP.defineChatCommand("me", Me, 1.5)

local function wme(ply, args)
    if args == "" then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
        return ""
    end

    local DoSay = function(text)
        if text == "" then return end

        local col = Color(250, 160, 0)
        for _, target in ipairs( who_can_hear( ply:GetPos(), 2 ) ) do
            netstream.Start( target, 'polygui.drawAction', ply, text, 15 )
        end

    end
    return args, DoSay
end
DarkRP.defineChatCommand("wme", wme, 1.5)

local function doit(ply, args)
    if args == "" then
        DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
        return ""
    end

    local DoSay = function(text)
        if text == "" then
            DarkRP.notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", DarkRP.getPhrase("arguments"), ""))
            return ""
        end

        local col = Color(250, 160, 0)
        for _, target in ipairs( who_can_hear( ply:GetPos(), 2 ) ) do
            DarkRP.talkToPerson(target, col, 'Окружение могло наблюдать, ' .. text .. ' <'..getCharName(ply)..'>')
        end

    end
    return args, DoSay
end
DarkRP.defineChatCommand("doit", doit, 1.5)