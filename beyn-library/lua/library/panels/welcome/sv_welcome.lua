netstream.Hook( 'lib.profileLoad', function(ply)

    ply:loadModel()
    
      ply:loadData()

        ply:loadPosition()

      ply:Freeze( false )

    net.Start( 'lib.openf4Menu' )

  net.Send( ply )

  netstream.Start( ply, 'lib.welcomeMsg' )

end)