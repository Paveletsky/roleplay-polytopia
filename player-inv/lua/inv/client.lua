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

function polyinv.info( data )
    if inf then inf:Remove() end
    inf = vgui.Create 'DFrame'
    inf:SetSize( 400, 150 )
    inf:MakePopup()
    inf:Center() 
    inf:AlignTop( 100 )
    inf:AlignRight( 100 )

    local logo = inf:Add("DPanel")
    logo:Dock(RIGHT)
    logo:SetWide(100)
    logo:DockMargin(2, 2, 2, 2)

    local name = inf:Add("DPanel")
    name:Dock(TOP)

    local desc = inf:Add 'RichText'
    desc:Dock(FILL)
    desc:AppendText( data.desc or "Нет описания" )

    function logo:Paint(w, h)
        if data.logo then
            draw.RoundedBox( 8, 0, 0, w, h, Color( 240, 240, 240, 255 ))
        	surface.SetDrawColor( 70, 70, 70, 100 )
            surface.DrawOutlinedRect( 0, 0, w, h, 8 )

            surface.SetMaterial( Material( data.logo ) )
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRect(11, 11, w-20, h-20)
        else
            draw.DrawText( 'data.name', 'polyfont.sm', 0, 0, color_white )
        end
    end

    function desc:PerformLayout()
        self:SetFontInternal( "DermaDefault" )
        self:SetFGColor( Color( 255, 255, 255 ) )
    end

    function name:Paint( w, h )
        draw.DrawText( data.name, 'polyfont.sm', 0, 0, color_white )
    end
end

-- polyinv.info( data )

function polyinv.open()
    local list_inv = ply.cache_inv
    if m then m:Remove() end 

    m = vgui.Create 'DFrame'
    m:SetSize( 600, 400 )
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
        local it = gr:Add 'DImageButton'
        it:SetSize( 60, 60 )
        gr:AddItem( it )

        function it:DoClick()
            local m = DermaMenu()
            m:AddOption("О предмете", function()
                polyinv.info( data_inv )
            end):SetImage("icon16/user.png")
            m:Open()
        end

        function it:Paint( w, h )
            draw.RoundedBox( 7, 0, 0, w, h, Color( 240, 240, 240, 255 ))
        	surface.SetDrawColor( 70, 70, 70, 100 )
            surface.DrawOutlinedRect( 0, 0, w, h, 3 )
            
            draw.SimpleText( data_inv.name, 'polyfont.sm', 2, 20, color_black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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