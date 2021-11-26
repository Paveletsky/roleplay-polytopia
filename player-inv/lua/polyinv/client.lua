library.createFont( 'polyfont.sm', 'Calibri', 15 )
library.createFont( 'polyfont.vsm', 'Calibri', 14 )
library.createFont( 'polyfont.rich', 'Trebuchet24', 14 )
library.createFont( 'polyfont.rich2', 'Trebuchet24', 21 )

library.createFont( 'polyfont.infoPl', 'Trebuchet24', 22 )


local sw, sh = ScrW(), ScrH()
local ply = LocalPlayer()

function polyinv.note( data )
    if nt then nt:Remove() end    

    PrintTable(data)

    nt = vgui.Create 'DFrame'
    nt:SetSize( 700, 400 )
    nt:Center()
    nt:ShowCloseButton(false)
    nt:SetScreenLock(true)
    nt:SetSizable(true)
    nt:SetTitle 'Список стандартных предметов'
    nt:AlignRight( 0 )
    nt:MoveTo( ScrW() / 1.6, ScrH() / 2 - nt:GetTall() / 2, 0.2, 0, -1 )

    local scr = nt:Add 'DScrollPanel'
    scr:Dock(FILL)

    local gr = vgui.Create( "DGrid", scr )
    gr:Dock( TOP )
    gr:DockMargin(2.5, 15, 0, 0)
    gr:SetCols( 4 )
    gr:SetRowHeight( 60)
    gr:SetColWide( 155 )
    for k, v in pairs( data  ) do
        local it = gr:Add 'DImageButton'
        it:SetSize( 150, 50 )
        
        if not v.isCustom then
            gr:AddItem( it )
            function it:Paint( w, h )
                draw.RoundedBox( 5, 0, 0, w, h, Color( 184, 53, 64, 130 ))
                surface.SetDrawColor( 250, 160, 0, 80 )
                surface.DrawOutlinedRect( 0, 0, w, h, 1 )

                draw.SimpleText( v.name, "DermaDefault",  it:GetSize() / 2 - 1, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText( v.weight * 32 .. 'л.', 'polyfont.vsm', it:GetSize() / 2 - 2, 35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        function it:OnCursorEntered()
            if !derm:IsValid() then netstream.Start( 'polyinv.sv-infoOpen', v.class ) end
        end

        function it:OnCursorExited()
            inf:AlphaTo( 0, 0.2, 0, function() 
                inf:Remove()
            end)
            
        end
    end
end

function polyinv.info( data )
    if inf then inf:Remove() end

    inf = vgui.Create 'DFrame'
    inf:MakePopup()
    inf:SetSize( 0, 350 )
    inf:ShowCloseButton( false )
    inf:Center() 
    inf:SetTitle( 'Описание предмета' )
    inf:SetAlpha( 0 )
    inf:AlignLeft( ScrW() / 2.8 )
    inf:AlignTop( ScrH() / 3.169 )
    inf:SizeTo( 350, 350, 0.2, 0, 0.2 )
    inf:AlphaTo( 230, 0.2, 0 )

    local logo = inf:Add("DPanel")
    logo:Dock(RIGHT)
    logo:SetWide(100)
    logo:DockMargin(2, 2, 2, 210)

    pName = inf:Add 'RichText'
    pName:Dock(FILL)
    pName:AppendText( data.name or "Без имени" )

    pDesc = inf:Add 'RichText'
    pDesc:Dock(FILL)
    pDesc:DockMargin( 0, #data.name + 3, 0, 0 )
    pDesc:AppendText( data.desc or "" )

    function logo:Paint(w, h)
        if data.logo then
            draw.RoundedBox( 4, 0, 0, w, h, Color( 184, 53, 64, 10 ))
                surface.SetDrawColor( 250, 160, 0, 255 )
                surface.DrawOutlinedRect( 0, 0, w, h, 1.9 )

            surface.SetMaterial( Material( data.logo, 'smooth' ) )
            	surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
                surface.DrawTexturedRect(11, 11, w-22, h-25)
        else
            draw.RoundedBox( 4, 0, 0, w, h, Color( 184, 53, 64, 10 ))
                surface.SetDrawColor( 250, 160, 0, 255 )
                surface.DrawOutlinedRect( 0, 0, w, h, 1.9 )

            surface.SetMaterial( Material( 'poly/button.png', 'smooth' ) )
            	surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
                surface.DrawTexturedRect(11, 11, w-22, h-25)
        end
    end

    function pName:PerformLayout()
        self:SetFontInternal( "polyfont.rich2" )
        self:SetFGColor( Color( 255, 255, 255 ) )            
    end

    function pDesc:PerformLayout()
        self:SetFontInternal( "polyfont.rich" )
        self:SetFGColor( Color( 255, 255, 255 ) )            
    end
end

netstream.Hook( 'polyinv.open', function( data, items, ch, customs )
    if m then m:Remove() end 

    m = vgui.Create 'DFrame'
    m:SetSize( 600, 400 )
    m:MakePopup()
    m:SetTitle( 'Рюкзак' )
    m:Center()
    m:SetScreenLock( true )
    m:AlignLeft(0)
    m:SetAlpha(0)
    m:MoveTo( ScrW() / 25, ScrH() / 2 - m:GetTall() / 2, 0.2, 0, -1 )
    m:AlphaTo( 255, 0.5, 0 )

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
        self:SetFontInternal( 'polyfont.rich2' )
        self:SetFGColor( Color( 255, 255, 255 ) )
    end

    function chName:Paint( w, h )
        self:SetFontInternal( 'polyfont.infoPl' )
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

    local pb = mdl:Add 'DButton'
    pb:Dock(TOP)
    pb:SetTall(20)
    pb:SetText( 'Список предметов' )
    pb:DockMargin( 0, 0, 150, 0 )
    function pb:DoClick()
        if !nt:IsValid() then netstream.Start('polyinv.sv-noteOpen') else 
            nt:AlphaTo( 0, 0.2, 0, function() nt:Remove() end)  
        end
    end

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
    gr:SetCols( 2 )
    gr:SetRowHeight( 60)
    gr:SetColWide( 155 )
    if data[1].inventory != '[}' then
        for k, class in pairs( inv_data ) do
            local data_inv = items[class]
            local it = gr:Add 'DImageButton'
            it:SetSize( 150, 50 )
            gr:AddItem( it )

            function it:DoClick()
                derm = DermaMenu()

                if data_inv.canUse then
                    derm:AddOption("Использовать", function()
                        netstream.Start( 'polyinv.sv-useItem', k )
                        netstream.Start 'polyinv.sv-open'
                    end):SetImage("icon16/briefcase.png")
                end

                derm:AddOption("Выкинуть", function()
                    netstream.Start( 'polyinv.sv-deleteItem', k )
                    netstream.Start 'polyinv.sv-open'
                end):SetImage("icon16/bin.png")

                derm:Open()
            end

            function it:Paint( w, h )
                draw.RoundedBox( 5, 0, 0, w, h, Color( 184, 53, 64, 130 ))
                surface.SetDrawColor( 250, 160, 0, 80 )
                surface.DrawOutlinedRect( 0, 0, w, h, 1 )

                draw.SimpleText( data_inv.name, 'polyfont.sm', it:GetSize() / 2 - 1, 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText( data_inv.weight * 32 .. 'л.', 'polyfont.vsm', it:GetSize() / 2 - 2, 35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            function it:OnCursorEntered()
                if !derm:IsValid() then netstream.Start( 'polyinv.sv-infoOpen', data_inv.class ) end
            end

            function it:OnCursorExited()
                inf:AlphaTo( 0, 0.2, 0, function() 
                    inf:Remove()
                end)
            end

        end
    end
end)

hook.Add( "Think", "lib.load", function()
    hook.Remove( 'Think', 'lib.load' )    

    netstream.Start 'polyinv.sv-open'

    netstream.Hook( 'polyinv.info', polyinv.info )
    netstream.Hook( 'polyinv.openMenu', polyinv.open )
    netstream.Hook( 'polyinv.noteOpen', polyinv.note )
end)
