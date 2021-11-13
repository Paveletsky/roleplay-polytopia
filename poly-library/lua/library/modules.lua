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
        [ "76561198021443322" ] = true,
    }

    hook.Add( "CheckPassword", "access_whitelist", function( steamID64 )
        if not allowed[ steamID64 ] then
            return false, "Сервер в разработке. Наш проект - https://discord.gg/7vES6nzqYC"
        end
    end )

end--test3