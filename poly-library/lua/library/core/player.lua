

GM = GAMEMODE or {}

local meta = FindMetaTable( 'Player' )

if ( !sql.TableExists( "polytopia_userdata" ) ) then
    sql.Query( 'CREATE TABLE IF NOT EXISTS polytopia_userdata( steamid TEXT , name TEXT )' )
end

function meta:LockPlayer()
    self:Freeze(true)
    self:SetNoDraw(true)
    self:SetNotSolid(true)
    self:StripWeapons()
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
    -- ply:LockPlayer()
end

function library.playerInit( ply )
    ply:SetNetVar( 'os_characters', sql.Query("SELECT chars FROM polytopia_characters WHERE steamid = " .. SQLStr(ply:SteamID())) )
end

function library.playerDisconnect( ply )
end

function GM:PlayerHurt( ply )
    ply:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 253 ), 0.1, 0.1 )
end

netstream.Hook( 'lib-lockplayer', LockPlayer )
netstream.Hook( 'lib-unlockplayer', UnlockPlayer )

hook.Add( 'Think', 'init-player', function()
    hook.Remove( 'Think', 'init-player' )

    hook.Add( 'PlayerSpawn', 'pl-spawn', library.PlayerSpawn )
    hook.Add( 'PlayerInitialSpawn', 'pl-init', library.playerInit )
    hook.Add( 'PlayerDisconnected', 'pl-disconnect', library.playerDisconnect )
    
end)

local allowed = {
    ['STEAM_0:0:30588797'] = true,
    ['STEAM_0:1:116256417'] = true,
    ['STEAM_0:0:72860823'] = true,
    ['STEAM_0:1:458158516'] = true,
}

local cache = {}

gameevent.Listen( "player_connect" )
hook.Add("player_connect", "access_whitelist1", function( data, steamID64 )

    for k, v in pairs( data ) do
        if not allowed[data.networkid] then game.KickID( data.networkid, "Тебя нет в вайтлисте. Наш проект - https://discord.gg/7vES6nzqYC" ) end
    end

    for k, v in pairs( data ) do
        if not cache[data.networkid] then game.KickID( data.networkid, 
[[ИНФОРМАЦИЯ ДЛЯ НОВЕНЬКИХ!

Сервер нацелен на серьезную игру ЧЕЛОВЕКА, и если ты относишься тем, кто любит веселиться и убивать - проходи мимо. 

Если хочешь приобщиться к настоящей серьезной ролевой игре - милости просим, просто закрой табличку и перезайди]] 
        ) end
        cache[data.networkid] = true
    end

end)