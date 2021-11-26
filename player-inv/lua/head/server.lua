local PL = FindMetaTable( 'Player' )

function polyinv.notesOpen()
    netstream.Start( ply, 'polyinv.noteOpen', polyinv.List )
end

function polyinv.infoPage( id )
    local itemCl = polyinv.List[id]
    netstream.Start( ply, 'polyinv.info', itemCl )
end

netstream.Hook( 'polyinv.sv-infoOpen', function( ply, id ) 
    polyinv.infoPage( id )
end)

netstream.Hook( 'polyinv.sv-noteOpen', polyinv.notesOpen )