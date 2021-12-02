hook.Add( 'Think', 'svbackpack', function()
    hook.Remove( 'Think', 'svbackpack' )
    
    local PL = FindMetaTable( 'Player' )

    if ( !sql.TableExists( "polytopia_inventory" ) ) then
        sql.Query( 'CREATE TABLE IF NOT EXISTS polytopia_inventory( steamid TEXT NOT NULL PRIMARY KEY , inventory TEXT )' )    
    end

    function PL:GetCharInventory(ID)

        local val = sql.Query("SELECT chars FROM polytopia_characters WHERE steamid = " .. SQLStr( self:SteamID() ) )
        local encoded = pon.decode( val[1].chars )

        return encoded
    end

    function PL:CurrentCharInventory()

        local val = sql.Query("SELECT chars FROM polytopia_characters WHERE steamid = " .. SQLStr( self:SteamID() ) )
        local encoded = pon.decode( val[1].chars )[self:GetNetVar('char.id')].inventory

        return encoded
    end

    function PL:isValidItems( )

        for k, v in pairs( self:CurrentCharInventory() ) do
            if polyinv.List[v] == nil then 
                self:ChatPrint( 'Предмет ' .. v .. ' не валиден и будет удален из инвентаря.' )
                self:RemoveItem( k )
                self:OpenInventory( self:SteamID() )
            end
        end

    end

    function PL:OpenInventory( owner )

        local steam = player.GetBySteamID( owner )
        local charInfo = sql.Query( "SELECT * FROM polytopia_characters WHERE steamid = " .. SQLStr( steam:SteamID() ) .. ";")
        
        if not owner then self:polychatNotify( 1, 'SteamID не найден.' ) return end
        
        local data = steam:CurrentCharInventory() 
        netstream.Start( self, 'polyinv.open', data, polyinv.List, charInfo, polyinv.customCache )

    end

    function PL:GiveItem( class )

        local val = sql.Query("SELECT chars FROM polytopia_characters WHERE steamid = " .. SQLStr( self:SteamID() ) )
        local encoded = pon.decode( val[1].chars )
        local data = pon.decode( val[1].chars )

        local charId = self:GetNetVar( 'char.id' )

        local fraq = 0

        if !polyinv.List[class] then polychat.sendNotify( self, 1, 'Где ты откопал этот никому неизвестный предмет? 0_o' ) return end
        if self:GetItemCount( class ) >= polyinv.List[class].max then polychat.sendNotify( self, 1, 'У тебя максимальное количество "' .. polyinv.List[class].name .. '".' ) return end
        for k, v in pairs( data[charId].inventory ) do
            local data_inv = polyinv.List[v].weight
            fraq = fraq + data_inv
        end
        if fraq > 1.01 or fraq + polyinv.List[class].weight > 1.01 then polychat.sendNotify( self, 1, 'В рюкзаке нет места для этого предмета.' ) return end

        table.insert( data[charId].inventory, class )
        sql.Query( "REPLACE INTO polytopia_characters ( steamid, chars ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( pon.encode( data ) ) .. " )" )

    end

    function PL:HasItem( id )
        return self:CurrentCharInventory()[id]
    end

    function PL:RemoveItem( id )

        local val = sql.Query("SELECT chars FROM polytopia_characters WHERE steamid = " .. SQLStr( self:SteamID() ) )
        local encoded = pon.decode( val[1].chars )
        local data = pon.decode( val[1].chars )

        local charId = self:GetNetVar( 'char.id' )

        if self:HasItem( id ) then
            local notDel = data[charId].inventory
                notDel[id] = nil 
            sql.Query( "REPLACE INTO polytopia_characters ( steamid, chars ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( pon.encode( data ) ) .. " )" )
        end

    end

    function PL:UseItem( id )

        if self:HasItem( id ) then
            local itemCl = polyinv.List[self:CurrentCharInventory()[id]]
            local isOk = polyinv.itemTypes[itemCl.func]( itemCl, self )
            if !isOk then
                self:RemoveItem( id )
            end
        end

    end

    function PL:GetItemCount( class )

        local data = self:CurrentCharInventory()
        local i = 0

        for k, v in pairs( data ) do
            if v == class then
                i = i + 1
            end
        end
        return i

    end

    function PL:DropItem( ID )

        if self:HasItem( ID ) then
            
            local I = ents.Create 'polystore_item'
            local itemData = polyinv.List[self:CurrentCharInventory()[ID]]
            local trace = util.TraceLine({
                start = self:EyePos(),
                endpos = self:EyePos() + self:EyeAngles():Forward() * 50,
                filter = self,
            })
            I:SetPos( trace.HitPos )
            I:SetAngles( Angle( 0, 0, 0 ) )
            I:Register( itemData )
            I:Spawn()

            self:RemoveItem( ID )

        end

    end

    function PL:openCustomItemsMenu()
        netstream.Start( self, 'polyinv.openCustoms', polyinv.List )
    end

    netstream.Hook( 'polyinv.sv-useItem', function( ply, id ) 
        ply:UseItem( id )
    end)

    netstream.Hook( 'polyinv.sv-deleteItem', function( ply, id ) 
        ply:RemoveItem( id )
    end)

    netstream.Hook( 'polyinv.sv-dropItem', function( ply, id ) 
        ply:DropItem( id )
    end)

    netstream.Hook( 'polyinv.sv-open', function( ply ) 
        
        ply:CurrentCharInventory()
        ply:isValidItems()
        ply:OpenInventory( ply:SteamID() )

    end)

    netstream.Hook( 'polyinv.sv-customOpen', function( ply ) 
        ply:openCustomItemsMenu()
    end)

    hook.Add( 'ShowSpare2', 'polychars.openOnSay', function( ply )
        ply:OpenInventory( ply:SteamID() )
    end)

end)