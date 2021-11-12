hook.Add( 'Think', 'init-lib', function()
    hook.Remove( 'Think', 'init-lib' )

    local PL = FindMetaTable( 'Player' )

    if ( !sql.TableExists( "polytopia_characters" ) ) then
        sql.Query( 'CREATE TABLE IF NOT EXISTS polytopia_characters( steamid TEXT NOT NULL PRIMARY KEY , chars TEXT )' )    
    end

    function GM:PlayerSpawn( ply )
        ply:SetNetVar( 'os_characters', sql.Query("SELECT * FROM polytopia_characters") )
    end

    function PL:getCharacters( name )
        local val = sql.Query("SELECT * FROM polytopia_characters")
        return val
    end

    function PL:createCharacter( charvars )
        local data = self:getCharacters()
        data[#data + 1] = {

        }
        name = Format( "%s[%s]", self:SteamID(), self:Nick() )
        return sql.Query( "REPLACE INTO polytopia_characters ( steamid, chars ) VALUES ( " .. SQLStr( name ) .. ", " .. SQLStr( charvars ) .. " )" ) ~= false
    end

    netstream.Hook( 'poly-createCharacter', polychars.create )

end)

-- Entity(1):createCharacter( '1ялох' )
-- PrintTable( Entity(1):getCharacters() )

-- Entity(1):SetNetVar( 'os_cheater', 'Лошок', true )
print( Entity(1):GetNetVar( 'os_cheater' ) )