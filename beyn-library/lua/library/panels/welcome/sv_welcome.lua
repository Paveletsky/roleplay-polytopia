netstream.Hook( 'lib.profileLoad', function(ply)

    net.Start( 'lib.openf4Menu' )

  net.Send( ply )

  netstream.Start( ply, 'lib.welcomeMsg' )

end)