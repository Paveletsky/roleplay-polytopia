local function is_emote(text)
    if string.sub(text, 1, 4) == '/me ' then return 'me' end
    if string.sub(text, 1, 4) == '/it ' then return'it' end
    if string.sub(text, 1, 5) == '/pit ' then return 'pit' end
    if string.sub(text, 1, 6) == '/toit ' then return 'toit' end
    if string.sub(text, 1, 5) == '/wit ' then return 'wit' end
    if string.sub(text, 1, 5) == '/yit ' then return 'yit' end
    return ''
end

local function who_can_hear(performer_pos, em_type)
    local who_can_hear_table = {}
    local range = 400
    for k, v in ipairs(player.GetAll()) do
        local plpos = v:GetPos()
        local diffx, diffy, diffz
        diffx = math.abs(performer_pos.x - plpos.x)
        diffy = math.abs(performer_pos.y - plpos.y)
        diffz = math.abs(performer_pos.z - plpos.z)
        if diffx <= range and diffy <= range and diffz <= range then who_can_hear_table[#who_can_hear_table + 1] = v end
    end
    return who_can_hear_table
end

local function check_emote_com(sender, text, teamChat)

    if text == 'lol' then

        for k, v in ipairs(who_can_hear(sender:GetPos(), is_em)) do
            netstream.Start(v, 'polychat.sendEmote', sender:Nick(), 'Мать жива?', 'ЛОЛ')
        end
    
    end

    return ""
end

hook.Add("PlayerSay", "EmotePerforming", check_emote_com)