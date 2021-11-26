---

local ply = LocalPlayer()

function polyinv.openCustoms( itemList )

    if mn then mn:Remove() end
    mn = vgui.Create 'DFrame'
    mn:SetSize( 700, 500 )
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