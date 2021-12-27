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

if CLIENT then
    concommand.Add( 'getChars', function( ply )
        netstream.Start( 'polychars.getChars' )
    end)
end

hook.Add('Think', 'init', function()

    hook.Run('polylib.init')
    hook.Remove('Think', 'init')
end)