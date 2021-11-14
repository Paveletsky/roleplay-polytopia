--

hook.Add( 'Think', 'init-lib', function()
    hook.Remove( 'Think', 'init-lib' )

    local GM = GAMEMODE or {}

    local PL = FindMetaTable( 'Player' )

    if ( !sql.TableExists( "polytopia_characters" ) ) then
        sql.Query( 'CREATE TABLE IF NOT EXISTS polytopia_characters( steamid TEXT NOT NULL PRIMARY KEY , chars TEXT )' )    
    end

    function PL:getCharacters()
        local val = sql.Query("SELECT chars FROM polytopia_characters WHERE steamid = " .. SQLStr( self:SteamID() ) )
        return val
    end

    function PL:createCharacter( rpname, desc, scale, skin, bg )
        local cache = {}
        for k, v in pairs( self:getCharacters() ) do
            if ( v.chars != '' and #pon.decode(v.chars) == 3 ) then
                return false 
            end
            if ( v.chars == '' ) then
                cache[#cache+1] = {
                    rpname = rpname,
                    desc = desc,
                    scale = scale,
                    skin = skin,
                    bg = bg,
                }
                sql.Query( "REPLACE INTO polytopia_characters ( steamid, chars ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( pon.encode( cache ) ) .. " )" )
                self:SetNetVar( 'os_characters', sql.Query("SELECT chars FROM polytopia_characters WHERE steamid = " .. SQLStr(self:SteamID())) )
            end
            if ( v.chars != '' ) then
                cache = pon.decode( v.chars )
                cache[#cache+1] = {
                    rpname = rpname,
                    desc = desc,
                    scale = scale,
                    skin = skin,
                    bg = bg,                    
                }
                sql.Query( "REPLACE INTO polytopia_characters ( steamid, chars ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( pon.encode( cache ) ) .. " )" )
                self:SetNetVar( 'os_characters', sql.Query("SELECT chars FROM polytopia_characters WHERE steamid = " .. SQLStr(self:SteamID())) )
            end
        end
    end

    function PL:deleteCharacter( id )
        for k, v in pairs( self:getCharacters() ) do
            if ( v.chars == '' ) then
                self:ChatPrint( 'Так-то у тебя нет персонажей.' )
                return false
            end
            local cache = pon.decode( v.chars )
            table.remove( cache, id ) 
            sql.Query( "REPLACE INTO polytopia_characters ( steamid, chars ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( pon.encode( cache ) ) .. " )" )       
            self:SetNetVar( 'os_characters', sql.Query("SELECT chars FROM polytopia_characters WHERE steamid = " .. SQLStr(self:SteamID())) )
        end        
    end

    function PL:changeCharacter( ply, rpname, desc, scale, skin, bg )
        ply:Spawn()
        timer.Simple( 3, function()
            ply:SetNetVar( 'session_name', rpname )
            ply:SetNetVar( 'session_desc', desc )

            ply:SetPos( library.randSpawn() )
            ply:changeTeam( 1, true, true )
            ply:SetModel( skin )
            ply:SetModelScale( scale )
            
            local i = 1
            for k, v in pairs( ply:GetBodyGroups() ) do
                ply:SetBodygroup( v['id'], tonumber( bg[i] ) )
                    i = i + 1
            end
        end)
    end

    netstream.Hook( 'polychars.Pick', function( ply, rpname, desc, scale, skin, bg ) 
        ply:Spawn()
        timer.Simple( 0.2, function()
            ply:SetNetVar( 'session_name', rpname )
            ply:SetNetVar( 'session_desc', desc )

            ply:SetPos( library.randSpawn() )
            ply:SetTeam( 2 )
            ply:SetModel( skin )
            ply:SetModelScale( scale )

            ply:SetWalkSpeed( 100 )
            ply:SetRunSpeed( 180 )

            for k, v in pairs( ply:getJobTable()['weapons'] ) do
                ply:Give( v )
            end
        end)
    end)

    netstream.Hook( 'testBG', function( ply, bg ) 
        timer.Simple( 0.4, function()    
            local a = 1
            for l, p in pairs( ply:GetBodyGroups() ) do
                ply:SetBodygroup( p['id'], tonumber( bg[a] ) )
                a = a + 1
            end
        end)
    end)

    netstream.Hook( 'polychars.Create', function( ply, rpname, desc, scale, skin, bg ) 
        ply:createCharacter( rpname, desc, scale, skin, bg )
    end)

    netstream.Hook( 'polychars.Delete', function( ply, id ) 
        ply:deleteCharacter( id )
    end)

end)