function openF4( ply )
    netstream.Start( ply, 'startMenu' )
end

hook.Add( 'ShowSpare2', 'f4menuHook', openF4 )

netstream.Hook( 'changeChar2', function( ply, name, desc )
    ply:SetPData( 'name', name)
    ply:SetPData( 'desc', desc )
end)

hook.Add( 'PlayerSpawn', 'newFag', function(ply)

    namesTable = {
        'Джэк Старший',
        'Говно Ебало',
    }

    if ply:GetPData( 'desc' == nil ) then 
        ply:SetNetVar( 'desc', 'Нет описания' )
    else
        ply:SetNetVar( 'desc', ply:GetPData('desc') )
    end

    if ply:GetPData( 'name' == nil ) then 
        ply:SetNetVar( 'name', table.Random(namesTable) )
    else
        ply:SetNetVar( 'name', ply:GetPData('name') )
    end

end)