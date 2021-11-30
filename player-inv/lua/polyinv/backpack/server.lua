hook.Add( 'Think', 'svbackpack', function()
    hook.Remove( 'Think', 'svbackpack' )
    
    local PL = FindMetaTable( 'Player' )

    if ( !sql.TableExists( "polytopia_inventory" ) ) then
        sql.Query( 'CREATE TABLE IF NOT EXISTS polytopia_inventory( steamid TEXT NOT NULL PRIMARY KEY , inventory TEXT )' )    
    end

    function PL:GetInventory()

        local encoded = sql.Query( "SELECT inventory FROM polytopia_inventory WHERE steamid = " .. sql.SQLStr( self:SteamID() ) .. ";")
            if encoded == nil then
                sql.Query( "REPLACE INTO polytopia_inventory ( steamid, inventory ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( "[}" ) .. " )" )
            end

            local okDB = sql.Query( "SELECT inventory FROM polytopia_inventory WHERE steamid = " .. sql.SQLStr( self:SteamID() ) .. ";") 
            local data = pon.decode( encoded[1].inventory )    

        return data

    end

    -- PrintTable( Entity(1):GetInventory() )

    function PL:isValidItems( )

        for k, v in pairs( self:GetInventory() ) do
            if polyinv.List[v] == nil then 
                self:ChatPrint( 'Предмет ' .. v .. ' не валиден и будет удален из инвентаря.' )
                self:RemoveItem( k )
                self:OpenInventory( self:SteamID() )
            end
        end

    end

    -- Entity(1):GetInventory()
    -- Entity(1):isValidItems()

    function PL:OpenInventory( owner )

        local steam = player.GetBySteamID( owner )
        local charInfo = sql.Query( "SELECT * FROM polytopia_characters WHERE steamid = " .. SQLStr( steam:SteamID() ) .. ";")
        
        if not owner then self:polychatNotify( 1, 'SteamID не найден.' ) return end
        
        local data = steam:GetInventory() 
        netstream.Start( self, 'polyinv.open', data, polyinv.List, charInfo, polyinv.customCache )

    end

    function PL:GiveItem( class )

        local data = self:GetInventory()
        local fraq = 0

        if !polyinv.List[class] then self:polychatNotify( 1, 'Я не могу взять то, чего не существует :D' ) return end
        if self:GetItemCount( class ) >= polyinv.List[class].max then self:ChatPrint( 'У вас максимальное кол-во "' .. polyinv.List[class].name .. '"' ) return end
        for k, v in pairs( data ) do
            local data_inv = polyinv.List[v].weight
            fraq = fraq + data_inv
        end

        if fraq > 1.01 or fraq + polyinv.List[class].weight > 1.01 then self:polychatNotify( 1, 'Нет места.' ) return end

        table.insert( data, class )
        sql.Query( "REPLACE INTO polytopia_inventory ( steamid, inventory ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( pon.encode( data ) ) .. " )" )
        -- self:OpenInventory(self:SteamID())

    end

    -- Entity(2):OpenInventory( Entity(1):SteamID() )

    -- PrintTable( polyinv.List )

    function PL:HasItem( id )

        return self:GetInventory()[id]

    end

    function PL:RemoveItem( id )

        if self:HasItem( id ) then
            local notDel = self:GetInventory()
                notDel[id] = nil 
            sql.Query( "REPLACE INTO polytopia_inventory ( steamid, inventory ) VALUES ( " .. SQLStr( self:SteamID() ) .. ", " .. SQLStr( pon.encode( notDel ) ) .. " )" )
        end

    end

    function PL:UseItem( id )

        if self:HasItem( id ) then
            local itemCl = polyinv.List[self:GetInventory()[id]]
            local isOk = polyinv.itemTypes[itemCl.func]( itemCl, self )
            if !isOk then
                self:RemoveItem( id )
            end
        end

    end

    function PL:GetItemCount( class )

        local data = self:GetInventory()
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
            local itemData = polyinv.List[self:GetInventory()[ID]]
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
        
        ply:GetInventory()
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