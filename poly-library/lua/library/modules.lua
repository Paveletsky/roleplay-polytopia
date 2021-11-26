--
-- connect methods
--

library.shared 'netlib/netwrapper/sh_netwrapper'
library.client 'netlib/netwrapper/cl_netwrapper'
library.server 'netlib/netwrapper/sv_netwrapper'

library.shared 'netlib/netstream'
library.shared 'netlib/netstream2'

library.client 'panels/welcome/cl_welcome'
library.server 'panels/welcome/sv_welcome'

library.server 'core/funcs'
library.server 'core/player'

library.shared 'netlib/pon'
library.shared 'netlib/von'

library.shared 'panels/derma'

--
-- игровые хуки
--

if SERVER then

    local allowed = {
        ['STEAM_0:0:30588797'] = true,
        ['STEAM_0:1:116256417'] = true,
        ['STEAM_0:0:72860823'] = true,
    }

    gameevent.Listen( "player_connect" )
    hook.Add("player_connect", "access_whitelist1", function( data, steamID64 )
        for k, v in pairs( data ) do
            if not allowed[data.networkid] then game.KickID( data.networkid, "Тебя нет в вайтлисте. Наш проект - https://discord.gg/7vES6nzqYC" ) end
        end
    end)

end

if CLIENT then
    concommand.Add( 'getChars', function( ply )
        netstream.Start( 'polychars.getChars' )
    end)
end