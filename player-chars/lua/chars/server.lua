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

    function PL:getCharacters()
        local val = sql.Query("SELECT chars FROM polytopia_characters WHERE steamid = " .. SQLStr( self:SteamID() ) )
        return val
    end

    PrintTable( pon.decode( Entity(1):getCharacters()[1].chars ) )

    function PL:createCharacter( rpname, desc, scale, skin, mdskin, bg )
        local cache = {}
        for k, v in pairs( self:getCharacters() ) do
            if ( v.chars != '' and #pon.decode(v.chars) == 3 ) then
                    self:ChatPrint( 'Так-то у тебя не может быть больше трех персонажей 0_o' )
                return
            end
            if scale < 0.9 or scale > 1.11 then 
                self:ChatPrint( 'Некорректные значения.' ) 
                return 
            end
            cache = pon.decode( v.chars )
            cache[#cache+1] = {
                rpname = rpname,
                desc = desc,
                scale = scale,
                skin = skin,
                mdskin = mdskin,
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
        local charInfo = sql.Query( "SELECT * FROM polytopia_characters WHERE steamid = " .. SQLStr( self:SteamID() ) .. ";")
        local chInfo = pon.decode( charInfo[1].chars )
        -- self:SetPos( library.randSpawn() )
        for k, v in pairs( self:getCharacters() ) do
            local charTmp = pon.decode( v.chars )
            local charId = pon.decode( v.chars )[id]
            local a = 1

            if not id or not charId then
                self:ChatPrint("Такого персонажа не существует.")
                return
            end

            self:UnlockPlayer()

            self:SetTeam( 2 )
            self:SetModel( charId.skin )
            self:SetModelScale( charId.scale )
            self:SetSkin( charId.mdskin )

            self:setDarkRPVar( 'Energy', charId.hunger )

            self:SetNetVar( 'char.name', charId.rpname )

            self:SetWalkSpeed( 100 )
            self:SetRunSpeed( 180 )

            for k, v in pairs( self:getJobTable()['weapons'] ) do
                self:Give( v )
            end
            
        end

        local i = 0
        if chInfo[id].bg == '' then return end
        for k, v in pairs( chInfo[id].bg ) do
            self:SetBodygroup( i, v )
            i = i + 1
        end

    end

    netstream.Hook( 'polychars.Pick', function( ply, id ) 

        ply:SetNetVar( 'char.id', id )
        ply:pickCharacter( id )

        local time = os.date( "%H:%M:%S" , os.time() )
        ply:ChatPrint( 'Вы проснулись. На часах ' .. time .. '.' .. ' На улице шумно.'  )

    end)

    netstream.Hook( 'polychars.Create', function( ply, rpname, desc, scale, skin, bg, hunger ) 
        ply:createCharacter( rpname, desc, scale, skin, bg, hunger )
    end)

    netstream.Hook( 'polyinv.noteOpen', function(ply) 
        ply:notesOpen()
    end)

    netstream.Hook( 'polychars.Delete', function( ply, id ) 
        ply:deleteCharacter( id )
    end)

    netstream.Hook( 'polychars.Open', function( ply ) 
        ply:openPlayerChars()
    end)

    concommand.Add( 'polychars_open', function( ply )
        if not ply:IsSuperAdmin() then return end
        ply:openPlayerChars()
    end)

end)
Entity(1):openPlayerChars()