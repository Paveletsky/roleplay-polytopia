local PL = FindMetaTable("Player")

function PL:polychatNotify( typ, msg )

	netstream.Start( self, 'poly.sendNotify', typ, msg )

end

function PL:Emote( txt )

	return netstream.Start( self, 'polychat.Emote', txt )

end