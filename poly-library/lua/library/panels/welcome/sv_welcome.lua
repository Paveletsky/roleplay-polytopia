netstream.Hook( 'lib.profileLoad', function(ply)
    
    ply:loadData()

    ply:loadModel()

    ply:changeTeam( 2, true, true )

    ply:loadPosition()

    net.Start( 'lib.openf4Menu' )

  net.Send( ply )

  netstream.Start( ply, 'lib.welcomeMsg' )

end)

