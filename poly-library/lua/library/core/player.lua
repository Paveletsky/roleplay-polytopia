

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

function library.PlayerSpawn( ply )
    local data = sql.Query( "SELECT * FROM polytopia_characters WHERE steamid = " .. sql.SQLStr( ply:SteamID() ) .. ";")
    if data == nil then 
        sql.Query( "REPLACE INTO polytopia_characters ( steamid, chars ) VALUES ( " .. SQLStr( ply:SteamID() ) .. ", " .. SQLStr( "[}" ) .. " )" )
        return--
    end
    ply:SetNetVar( 'os_characters', sql.Query("SELECT chars FROM polytopia_characters WHERE steamid = " .. SQLStr(ply:SteamID())) )
    ply:SetTeam( 2 )
    ply:LockPlayer()
end

function library.playerInit( ply )
    ply:SetNetVar( 'os_characters', sql.Query("SELECT chars FROM polytopia_characters WHERE steamid = " .. SQLStr(ply:SteamID())) )
end

function library.playerDisconnect( ply )
end

function GM:PlayerHurt( ply )
    ply:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 253 ), 0.1, 0.1 )
end
-- Entity(1):SetTeam( 2 )

netstream.Hook( 'lib-lockplayer', LockPlayer )
netstream.Hook( 'lib-unlockplayer', UnlockPlayer )

hook.Add( 'Think', 'init-player', function()
    hook.Remove( 'Think', 'init-player' )

    hook.Add( 'PlayerSpawn', 'pl-spawn', library.PlayerSpawn )
    hook.Add( 'PlayerInitialSpawn', 'pl-init', library.playerInit )
    hook.Add( 'PlayerDisconnected', 'pl-disconnect', library.playerDisconnect )
    
end)
