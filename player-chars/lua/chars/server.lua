--

hook.Add( 'Think', 'init-lib', function()
    hook.Remove( 'Think', 'init-lib' )

    local GM = GAMEMODE or {}

    local PL = FindMetaTable( 'Player' )

    if ( !sql.TableExists( "polytopia_characters" ) ) then
        sql.Query( 'CREATE TABLE IF NOT EXISTS polytopia_characters( steamid TEXT NOT NULL PRIMARY KEY , chars TEXT )' )    
    end

    function PL:openPlayerChars()
        local data = sql.Query( "SELECT * FROM polytopia_characters WHERE steamid = " .. SQLStr( self:SteamID() ) .. ";")
        if data == nil then 
            sql.Query( "REPLACE INTO polytopia_characters ( steamid, chars ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( "[}" ) .. " )" )
        end
        local val = sql.Query("SELECT chars FROM polytopia_characters WHERE steamid = " .. SQLStr( self:SteamID() ) )
        netstream.Start( self, 'polychars.open', _, val )
    end

    Entity(1):openPlayerChars()

    function PL:getCharacters()
        local val = sql.Query("SELECT chars FROM polytopia_characters WHERE steamid = " .. SQLStr( self:SteamID() ) )
        return val
    end

    function PL:createCharacter( rpname, desc, scale, skin, bg )
        local cache = {}
        for k, v in pairs( self:getCharacters() ) do
            if ( v.chars != '' and #pon.decode(v.chars) == 1 ) then
                    self:ChatPrint( 'Так-то у тебя не может быть больше трех персонажей 0_o' )
                return
            end
            if scale < 1 or scale > 1.10 then 
                self:ChatPrint( 'Некорректные значения.' ) 
                return 
            end
            cache = pon.decode( v.chars )
            cache[#cache+1] = {
                rpname = rpname,
                desc = desc,
                scale = scale,
                skin = skin,
                bg = bg,
                hunger = 100,
                inventory = {},                    
            }
            sql.Query( "REPLACE INTO polytopia_characters ( steamid, chars ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( pon.encode( cache ) ) .. " )" )
        end
        self:openPlayerChars()
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
        end    
        self:openPlayerChars()    
    end

    function PL:pickCharacter( id )
        ply:SetPos( library.randSpawn() )
        timer.Create( 'lib-charPick', 0.2, 1, function()
            timer.Remove( 'lib-charPick' )
            for k, v in pairs( ply:getCharacters() ) do
                local charTmp = pon.decode( v.chars )
                local charId = pon.decode( v.chars )[id]
                local a = 1

                if not id or not charId then
                    ply:ChatPrint("Такого персонажа не существует.")
                    return
                end

                ply:UnlockPlayer()

                ply:SetNetVar( 'session_name', charId.rpname )
                ply:SetNetVar( 'session_desc', charId.desc )

                ply:SetTeam( 2 )
                ply:SetModel( charId.skin )
                ply:SetModelScale( charId.scale )

                ply:setDarkRPVar( 'Energy', charId.hunger )

                ply:SetWalkSpeed( 100 )
                ply:SetRunSpeed( 180 )

                for k, v in pairs( ply:getJobTable()['weapons'] ) do
                    ply:Give( v )
                end
                
                for l, p in pairs( ply:GetBodyGroups() ) do
                    ply:SetBodygroup( p['id'], tonumber( charId.bg[a] ) )
                    a = a + 1
                end

                local time = os.date( "%H:%M:%S" , os.time() )
                ply:ChatPrint( 'Вы проснулись. На часах ' .. time .. '.' .. ' На улице шумно.'  )
            end
        end)
    end

    netstream.Hook( 'polychars.Pick', function( ply, id ) 
        ply:pickCharacter( id )
    end)

    netstream.Hook( 'polychars.Create', function( ply, rpname, desc, scale, skin, bg, hunger ) 
        ply:createCharacter( rpname, desc, scale, skin, bg, hunger )
    end)

    netstream.Hook( 'polychars.Delete', function( ply, id ) 
        ply:deleteCharacter( id )
    end)

    netstream.Hook( 'polychars.Open', function( ply ) 
        ply:openPlayerChars()
    end)

end)