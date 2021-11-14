if CLIENT then

    local NOTIFY_LIST = {
        'У нас есть свой Дискорд-сервер, там ты найдешь множество полезной информации! - https://discord.gg/tFYctGUXMA \n P.S Его участники получают дополнительные плюшки C:',
        'На клавишу F4 открывается мини-меню сервера, в нем ты найдешь магазин сервера, контент, а также кнопку телепорта в зону строительства.',
        'На сервере периодически проходят ивенты, зависимые от онлайна. Так что зови скорее друзей и наслаждайтесь игрой!',
    }

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

    

        chat.AddText(_type, '[~]', Color(249, 174, 71), ' ' .. text)

    end


    timer.Create( 'polychat-notify.Discord', 390, 0, function()

        polychat.polyMsg( 1, table.Random( NOTIFY_LIST ) )

    end)
    

    function notification.AddLegacy(text, _type, _)

        polychat.polyMsg(_type, text)

    end
    

    netstream.Hook( 'poly.sendNotify', function( t, txt ) 
    
        polychat.polyMsg( t, txt )

    end)
    
    netstream.Hook('poly.show_emote', function(author, action, em_type)
    
        if em_type == 'me' then 
            chat.AddText(Color(226, 145, 39), author,Color(226, 145, 39), action) 
        end

        if em_type == 'it' then 
            local tauth = '(' .. author .. ')' 
            chat.AddText(Color(226, 145, 39), action,Color(226, 145, 39), tauth) 
        end

        if em_type == 'toit' or em_type == 'wit' or em_type == 'yit' then
            local splitted_text = string.Split(action, '*')
            local say_type
            if em_type == 'toit' then say_type = ', говорит: ' else say_type = em_type == 'wit' and ', шепчет: '  or ', кричит: ' end
            chat.AddText(Color(226, 145, 39), author .. ', ' .. splitted_text[1] .. say_type, Color(212,203,203), splitted_text[2])
        end
        
    end)

    netstream.Hook('poly.send_chat_message', function(author, content) chat.AddText(Color(227, 108, 49), author .. ' говорит: ', Color(255,255,255), content) end)
end