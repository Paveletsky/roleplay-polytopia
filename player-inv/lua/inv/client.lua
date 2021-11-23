surface.CreateFont( "polyfont.sm", {
	font = "Calibri", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 25,
} )

local sw, sh = ScrW(), ScrH()
local ply = LocalPlayer()

netstream.Hook( 'polyinv.initialize', function( ply ) 
    ply.cache_inv = {}
end)

netstream.Hook( 'polyinv.giveItem', function( ply, class )
    table.insert( ply.cache_inv, class )
end)

if n then n:Remove() end
n = vgui.Create 'DImageButton'
n:Center()
n:SetSize( 70, 70 )
n:AlignTop( 10 )
n:SetMaterial( 'poly/fedora.png', 'smooth' )
function n:DoClick()
    if !IsValid( m ) then
        polyinv.open()
        else m:Remove()
    end 
end

polyinv.open()

function polyinv.open()

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
    pr:Dock(BOTTOM)

    local scr = m:Add 'DScrollPanel'
    scr:Dock(FILL)

    local gr = vgui.Create( "DGrid", scr )
    gr:Dock( TOP )
    -- gr:SetPos( 10, 30 )
    gr:SetCols( 4 )
    gr:SetRowHeight( 70 )
    gr:SetColWide( 70 )

    for i = 1, 6 do
        -- if i == 0 then
        --     local nfy = m:Add 'DLabel'
        --     nfy:SetText( '1' )
        -- end

        local it = gr:Add 'DPanel'
        it:SetSize( 60, 60 )
        gr:AddItem( it )
        function it:Paint( w, h )
            draw.RoundedBox( 5, 0, 0, w, h, color_white )
            draw.SimpleText( 'Item ' .. i, 'polyfont.sm', 1, 20, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end

end