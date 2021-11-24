surface.CreateFont( "polyfont.sm", {
	font = "Calibri", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 25,
} )

local sw, sh = ScrW(), ScrH()
local ply = LocalPlayer()

netstream.Hook( 'polyinv.initialize', function() 
    ply.cache_inv = {}
end)

netstream.Hook( 'polyinv.giveItem', function( class )
    table.insert( ply.cache_inv, class )
end)

if n then n:Remove() end
n = vgui.Create 'DImageButton'
n:Center()
n:SetSize( 70, 70 )
n:AlignTop( 10 )
n:SetMaterial( 'poly/fedora.png', 'smooth' )

function polyinv.open()
    local list_inv = ply.cache_inv

    if m then m:Remove() end 

    m = vgui.Create 'DFrame'
    m:SetSize( 550, 300 )
    m:Center()
    m:MakePopup()
    m:AlignTop( 70 )
    m:MoveTo( ScrW() / 2 - m:GetWide() / 2, 100, 0.4, 0, -1 )

    local md = m:Add 'DPanel'
    md:Dock( RIGHT )
    md:SetSize( 250 )

    local mdl = md:Add 'DModelPanel'
    mdl:Dock(FILL)
    mdl:SetModel( LocalPlayer():GetModel() )
    mdl:SetFOV( 60 )

    local pr = m:Add 'DProgress'
    pr:SetSize( 0, 15 )
    local fraq = 0
    for k, v in pairs( ply.cache_inv ) do
        local data_inv = polyinv.List[v].weight
        fraq = fraq + data_inv
    end

    pr:SetFraction( fraq )
    pr:Dock(BOTTOM)

    local tx = pr:Add 'DLabel'
    tx:SetText( pr:GetFraction() )
    tx:SetPos( 140, -2 )

    local scr = m:Add 'DScrollPanel'
    scr:Dock(FILL)

    local gr = vgui.Create( "DGrid", scr )
    gr:Dock( TOP )
    -- gr:SetPos( 10, 30 )
    gr:SetCols( 4 )
    gr:SetRowHeight( 70 )
    gr:SetColWide( 70 )
    for k, class in pairs(list_inv) do
        local data_inv = polyinv.List[class]
        local it = gr:Add 'DPanel'
        it:SetSize( 60, 60 )
        gr:AddItem( it )
        function it:Paint( w, h )
            draw.RoundedBox( 5, 0, 0, w, h, color_white )
            draw.SimpleText( data_inv.name, 'polyfont.sm', 1, 20, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end

end

function n:DoClick()
    if !IsValid( m ) then
            polyinv.open()
        else m:Remove()
    end 
end

netstream.Hook( 'polyinv.openMenu', polyinv.open )
-- PrintTable( polyinv.List )
