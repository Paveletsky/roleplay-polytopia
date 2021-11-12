hook.Add( 'Think', 'init-lib', function()
    hook.Remove( 'Think', 'init-lib' )

    GM = GAMEMODE or {}

    local meta = FindMetaTable( 'Player' )

    if ( !sql.TableExists( "polytopia_userdata" ) ) then
        sql.Query( 'CREATE TABLE IF NOT EXISTS polytopia_userdata( steamid TEXT , name TEXT )' )
    end

    function meta:LockPlayer()
        self:Freeze(true)
        self:SetNoDraw(true)
        self:SetNotSolid(true)
        self:GodEnable()
        self:DrawWorldModel(false)
        netstream.Start( self, 'lib.spawnState' )
    end

    function meta:UnlockPlayer()
        self:Freeze(false)
        self:SetNoDraw(false)
        self:SetNotSolid(false)
        self:GodDisable()
        self:DrawWorldModel(true)
        netstream.Start( self, 'lib.unspawnState' )
    end

    function GM:PlayerSpawn( ply )
        ply:LockPlayer()
    end

    function GM:PlayerInitialSpawn( ply )
        timer.Simple( 0.1, function()
            netstream.Start( ply, 'lib.welcomeOpen' )
            sql.Query( "INSERT INTO IF NOT EXISTS polytopia_userdata( steamid , name ) VALUES( " .. sql.SQLStr(ply:SteamID()) .. " , " .. sql.SQLStr(ply:Nick()) .. " )" )
        end)
    end

    function GM:PlayerHurt( ply )
        ply:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 253 ), 0.1, 0.1 )
    end
    -- Entity(1):SetTeam( 2 )

    netstream.Hook( 'lib-unlockplayer', function( ply ) 
        ply:UnlockPlayer()
    end)

end)