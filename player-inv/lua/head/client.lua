---

local ply = LocalPlayer()

function polyinv.droppedItem( self, data )

    PrintTable( data )

    cam.Start3D2D( self:GetPos(), self:GetAngles(), 1 )

		draw.SimpleText( 'LOL', "DermaDefault", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	cam.End3D2D()

end

netstream.Hook( 'polyinv.droppedItem', polyinv.droppedItem )

function polyinv.openCustoms( itemList )

    if mn then mn:Remove() end
    mn = vgui.Create 'DFrame'
    mn:SetSize( 700, 500 )
    mn:SetTitle( 'Создание предметов' )
    mn:Center()
    mn:MakePopup()
    
    lst = mn:Add 'DPanel'
    lst:SetWide(200)
    lst:Dock(LEFT)

    lstIt = lst:Add 'DListLayout'
    lstIt:Dock(FILL)
    lstIt:Add( Label('lol') )
    lstIt:Add( Label('lol') )
    lstIt:Add( Label('lol') )
    lstIt:Add( Label('lol') )

end

netstream.Start 'polyinv.sv-customOpen'
netstream.Hook( 'polyinv.openCustoms', polyinv.openCustoms )