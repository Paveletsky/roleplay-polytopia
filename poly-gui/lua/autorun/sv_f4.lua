local player = FindMetaTable( 'Player' )

-- util.AddNetworkString( 'lib.openf4Menu' )

-- hook.Add('ShowSpare2', 'library.f4', function( ply )
--       net.Start( 'lib.openf4Menu' )
--     net.Send( ply )
-- end)

netstream.Hook( 'changeChar2', function( ply, name, desc, skin, scale, bgroups )

    local temp = pon.decode( ply:GetPData( 'characters' ) )

        if #temp == 3 then netstream.Start( ply, 'poly.sendNotify', 1, 'Больше персонажей вы создать не сможете.' ) return false end
        
        temp[#temp+1] = {
            name = name,
            desc = desc,
            scale = scale,
            skin = skin,
            bgroups = bgroups,
        }

        ply:SetPData( 'characters', pon.encode( temp ) )
        

        ply:SetNetVar( 'characters', ply:GetPData( 'characters' ) )

    -- local i = 1
    -- for k, v in pairs( ply:GetBodyGroups() ) do
    --     ply:SetBodygroup( v['id'], tonumber( bgroups[i] ) )
    --         i = i + 1
    -- end

    -- ply:SetModel( skin )
    -- ply:SetModelScale( scale )

end)

netstream.Hook( 'polychar.createCharacter', function( ply, name, desc, skin, scale, bgroups )

    local temp = pon.decode( ply:GetPData( 'characters' ) )

    temp[#temp+1] = {
        name = name,
        desc = desc,
        scale = scale,
        skin = skin,
        bgroups = bgroups,
    }

    ply:SetPData( 'characters', pon.encode( temp ) )
    ply:SetNetVar( 'characters', ply:GetPData( 'characters' ) )

end)

netstream.Hook( 'polychar.pickCharacter', function( ply, name, desc, mdl, bgroups ) 

    local temp = pon.decode( ply:GetPData 'characters' )

        ply:Spawn()

        timer.Simple( 3, function() 


            ply:SetNetVar( 'session_name', name )
            ply:SetNetVar( 'session_desc', desc )
            ply:SetNetVar( 'session_model', mdl )
            ply:SetModel( ply:GetNetVar( 'session_model' ) )

            ply:SetNoDraw(false);
            ply:SetNotSolid(false);
            ply:GodDisable();
            ply:DrawWorldModel(true);

            local i = 1
            for k, v in pairs( ply:GetBodyGroups() ) do
                ply:SetBodygroup( v['id'], tonumber( bgroups[i] ) )
                    i = i + 1
            end

            ply:changeTeam( 2, true, true )
        
        end)    
    

end)

netstream.Hook( 'polychar.deleteCharacter', function( ply, index ) 

    local temp = pon.decode( ply:GetPData( 'characters' ) )

        table.remove( temp, index )

    ply:SetPData( 'characters', pon.encode( temp ) )
    ply:SetNetVar( 'characters', ply:GetPData( 'characters' ) )

end)

    -- local temp = pon.decode( Entity(1):GetPData( 'characters' ) )

    -- PrintTable( temp )