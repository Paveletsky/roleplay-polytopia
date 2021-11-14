hook.Add( 'Think', 'init-lib', function()
    hook.Remove( 'Think', 'init-lib' )

    local GM = GAMEMODE or {}

    local PL = FindMetaTable( 'Player' )

    if ( !sql.TableExists( "polytopia_characters" ) ) then
        sql.Query( 'CREATE TABLE IF NOT EXISTS polytopia_characters( steamid TEXT NOT NULL PRIMARY KEY , chars TEXT )' )    
    end

    function GM:PlayerSpawn( ply )
        ply:SetNetVar( 'os_characters', sql.Query("SELECT * FROM polytopia_characters") )
    end

    function PL:getCharacters()
        local val = sql.Query("SELECT chars FROM polytopia_characters WHERE steamid = " .. SQLStr( self:SteamID() ) )
        return val
    end

    function PL:createCharacter( rpname, desc )

        local cache = {}
        for k, v in pairs( self:getCharacters() ) do
            if ( v.chars != '' and #pon.decode(v.chars) == 3 ) then
                return false 
            end

            if ( v.chars == '' ) then
                cache[#cache+1] = {
                    rpname = rpname,
                    desc = desc,
                }
                sql.Query( "REPLACE INTO polytopia_characters ( steamid, chars ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( pon.encode( cache ) ) .. " )" )
            end

            if ( v.chars != '' ) then
                cache = pon.decode( v.chars )
                cache[#cache+1] = {
                    rpname = rpname,
                    desc = desc,
                }
                sql.Query( "REPLACE INTO polytopia_characters ( steamid, chars ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( pon.encode( cache ) ) .. " )" )
            end
        end

    end

    concommand.Add( 'polychars.Create', function( ply, cmd, args )
        local rpname, desc = args[1], args[2]
        ply:createCharacter( rpname, desc )
    end)

end)