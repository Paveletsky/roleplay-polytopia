util.AddNetworkString( 'clib.addText' )

util.AddNetworkString( 'clib.sendMsg' )

util.AddNetworkString( 'NotificationChat' )


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
