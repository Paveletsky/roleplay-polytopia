surface.CreateFont( "polyfont.sm", {
	font = "Calibri", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 24,
})

surface.CreateFont( "polyfont.vsm", {
	font = "Calibri", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 18,
})

local sw, sh = ScrW(), ScrH()
local ply = LocalPlayer()

function polyinv.info( data )
    if inf then inf:Remove() end
    inf = vgui.Create 'DFrame'
    inf:SetSize( 300, 150 )
    inf:MakePopup()
    inf:Center() 
    inf:SetTitle( 'Описание предмета' )
    inf:AlignLeft( 670 )

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
        	surface.SetDrawColor( 70, 70, 70, 150 )
            surface.DrawOutlinedRect( 0, 0, w, h, 5 )

            surface.SetMaterial( Material( data.logo, 'smooth' ) )
            surface.SetDrawColor( 230, 230, 230, 255)
            surface.DrawTexturedRect(11, 11, w-20, h-20)
        else
            draw.RoundedBox( 8, 0, 0, w, h, Color( 240, 240, 240, 255 ))
        	surface.SetDrawColor( 70, 70, 70, 150 )
            surface.DrawOutlinedRect( 0, 0, w, h, 5 )

            surface.SetMaterial( Material( 'poly/cart.png', 'smooth' ) )
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRect(11, 11, w-20, h-20)
        end
    end

    -- function desc:PerformLayout()
    --     self:SetFontInternal( "DermaDefault" )
    --     self:SetFGColor( Color( 255, 255, 255 ) )
    -- end

    function name:Paint( w, h )
        draw.DrawText( data.name, 'polyfont.sm', 0, 0, color_white )
    end
end

netstream.Hook( 'polyinv.open', function( data, items, ch )
    if m then m:Remove() end 

    m = vgui.Create 'DFrame'
    m:SetSize( 600, 400 )
    m:MakePopup()
    m:SetTitle( 'Рюкзак' )
    m:Center()
    m:SetScreenLock( true )
    m:AlignLeft(0)
    m:MoveTo( ScrW() / 2 - m:GetWide() - 300, ScrH() / 2 - m:GetTall() / 2, 0.4, 0, -1 )

    local md = m:Add 'DPanel'
    md:Dock( RIGHT )
    md:SetSize( 250 )

    local sd1 = m:Add 'DPanel'
    sd1:Dock( TOP )
    sd1:SetTall(65)

    local sd2 = m:Add 'DPanel'
    sd2:Dock( BOTTOM )
    sd2:SetTall(65)

    local chInfo = pon.decode( ch[1].chars )
    local chName = sd1:Add 'RichText'
    chName:Dock(FILL)
    chName:AppendText( 'Имя: ' .. chInfo[1].rpname .. '\n' )
    chName:AppendText( 'Деятельность: nil' )

    local sdInfo = sd2:Add 'RichText'
    sdInfo:Dock(FILL)
    sdInfo:AppendText( 'Тип хранения: средний рюкзак \n' )

    function sdInfo:Paint( w, h )
        self:SetFontInternal( 'Trebuchet24' )
        self:SetFGColor( Color( 255, 255, 255 ) )
    end

    function chName:Paint( w, h )
        self:SetFontInternal( 'Trebuchet24' )
        self:SetFGColor( Color( 255, 255, 255 ) )
    end

    local mdl = md:Add 'DModelPanel'
    mdl:Dock(FILL)
    mdl:SetModel( LocalPlayer():GetModel() )
    mdl:SetFOV( 23 )
    local headpos = mdl.Entity:GetBonePosition(mdl.Entity:LookupBone("ValveBiped.Bip01_Spine"))
    mdl:SetCamPos( Vector( 50, 0, 80 ) )
    mdl:SetLookAt(headpos - Vector( 0, -2, -15 ))

    local i = 0
    for k, v in pairs( chInfo[1].bg ) do
        mdl.Entity:SetBodygroup( i, v )
        i = i + 1
    end

    local i = 0
    function mdl:LayoutEntity( ent )
        ent:SetSequence( ent:LookupSequence( 'pose_standing_01' ) )
        mdl:RunAnimation()
    end

    local pr = sd2:Add 'DProgress'
    pr:SetSize( 0, 15 )

    local fraq = 0
    local inv_data = pon.decode( data[1].inventory )

    if inv_data != '[}' then
        for k, v in pairs( inv_data ) do
            local ind = items[v].weight
            fraq = fraq + ind
        end
    end

    pr:SetFraction( fraq )
    pr:Dock(BOTTOM)

    local tx = pr:Add 'DLabel'
    tx:SetText( '' )
    tx:Dock(FILL)
    function tx:Paint( w, h )
        draw.SimpleText( pr:GetFraction() * 32 .. 'л', "polyfont.vsm", pr:GetSize() / 2 - 4, 6, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local scr = m:Add 'DScrollPanel'
    scr:Dock(FILL)

    local gr = vgui.Create( "DGrid", scr )
    gr:Dock( TOP )
    gr:DockMargin(2.5, 15, 0, 0)
    gr:SetCols( 5 )
    gr:SetRowHeight( 70 )
    gr:SetColWide( 66 )
    if data[1].inventory != '[}' then
        for k, class in pairs( inv_data ) do
            local data_inv = items[class]
            local it = gr:Add 'DImageButton'
            it:SetSize( 60, 60 )
            gr:AddItem( it )

            function it:DoClick()
                local m = DermaMenu()
                m:AddOption("О предмете", function()
                    polyinv.info( data_inv )
                end):SetImage("icon16/lightbulb.png")

                if data_inv.canUse then
                    m:AddOption("Использовать", function()

                    end):SetImage("icon16/briefcase.png")
                end

                m:AddOption("Выкинуть", function()
                    netstream.Start( 'polyinv.sv-deleteItem', k )
                end):SetImage("icon16/bin.png")

                m:Open()
            end

            function it:Paint( w, h )
                draw.RoundedBox( 7, 0, 0, w, h, Color( 240, 240, 240, 255 ))
                surface.SetDrawColor( 70, 70, 70, 100 )
                surface.DrawOutlinedRect( 0, 0, w, h, 3 )
                
                draw.SimpleText( data_inv.name, 'polyfont.sm', it:GetSize() / 2 - 1, 25, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText( data_inv.weight * 32 .. 'л.', 'polyfont.vsm', it:GetSize() / 2 - 2, 40, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end
end)

netstream.Start 'polyinv.sv-open'
netstream.Hook( 'polyinv.openMenu', polyinv.open )
