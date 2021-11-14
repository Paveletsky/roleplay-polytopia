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

    function PL:getCharacters(steamid)
        local val = sql.Query("SELECT * FROM polytopia_characters WHERE steamid = " .. SQLStr( self:SteamID() ) )
        return val
    end

    function PL:createCharacter( rpname, desc )
        local data = self:getCharacters()[1].chars
        data = {
            rpname = rpname,
            desc = desc,
        }
        sql.Query( "REPLACE INTO polytopia_characters ( steamid, chars ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( pon.encode( data ) ) .. " )" )
    end

    netstream.Hook( 'poly-createCharacter', polychars.create )

end) --

-- Entity(1):createCharacter( 'Са1н', 'Пахнет' )

-- PrintTable( Entity(1):getCharacters() )


-- local tbl = {
--     ['STEAM:2281337']   = {
--         chars = {},
--     },
--     ['STEAM:1337ХУЙ']   = {
--         chars = {},
--     }
-- }

-- local function tblTest( name, desc )
--     tbl[''] = pon.encode({
--         name = name,
--         desc = desc,
--     })
--     return tbl
-- end

-- local function deleteChar( id )
--     table.remove( tbl, id )
--     return tbl
-- end

-- -- tblTest( 'Сашка Хохлякин', "Мертвый внутри" )
-- -- tblTest( 'Костечка Злякин', "На него нельзя пукать" )
-- -- tblTest( 'Данилка Плакин', "Любит плакать в доте" )

-- PrintTable(tbl)