--

local sw, sh = ScrW(), ScrH()

function polyinv.open()
    
    if m then m:Remove() end 

    m = vgui.Create 'DFrame'
    m:SetSize( 300, 400)
    m:Center()
    m:AlignLeft( 5 )

end

polyinv.open()