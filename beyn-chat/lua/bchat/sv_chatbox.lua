util.AddNetworkString( 'clib.addText' )

local PLAYER = FindMetaTable("Player")



function PLAYER:ChatAddText(...)

	net.Start('clib.addText')

		net.WriteTable({...})

	net.Send(self)

end



function ChatAddText(...)

	net.Start('clib.addText')

		net.WriteTable({...})

	net.Broadcast()

end

Entity(1):changeTeam( 2, true, true )

-- теыфqewssaasqfaaqqwfasf