function startWelcome()

    if IsValid(goMen) then goMen:Remove() end

    goMen = vgui.Create 'DFrame'
    goMen:Dock( FILL )
    goMen:ShowCloseButton( false )
    goMen:MakePopup()
    goMen:SetTitle('')
    goMen:SetDraggable( false )

    goFr = vgui.Create( 'DPanel', goMen )
    goFr:SetSize( 700 )
    goFr:DockMargin( 0, -20, 0, 0)
    goFr:Dock( RIGHT )

    goFr2 = vgui.Create( 'DPanel', goFr )
    goFr2:Dock( TOP )

    goTxt = vgui.Create( 'DPanel', goFr )
    goTxt:Dock( TOP )
    goTxt:DockMargin( 0, 50, 0, 0)
    goTxt:SetSize( 0, 500 )

    goText = vgui.Create( 'DLabel', goTxt )
    goText:Dock(TOP)
    goText:DockMargin(0, 50, 0, 0)
    goText:SetSize( 0, goText:GetTextSize() + 90 )
    goText:SetText( string.format([[
        Вырезка лора...
    ]] ))
    goText:SetFont( 'lib.notify' )

    butForum = goFr:Add 'DButton'
    butForum:Dock( BOTTOM )
    butForum:DockMargin(0, 0, 0, 15)
    butForum:SetSize( 0, 30 )
    butForum:SetFont( 'lib.notify' )
    butForum:SetText( 'Форум' )
    butForum:SetTextColor( Color( 0, 0, 0 ) )

    goBut = vgui.Create( 'DButton', goFr )
    goBut:Dock( BOTTOM )
    goBut:DockMargin(0, 0, 0, 4)
    goBut:SetSize( 0, 30 )
    goBut:SetFont( 'lib.notify' )
    goBut:SetText( 'К персонажу' )
    goBut:SetTextColor( Color( 0, 0, 0 ) )
    goBut.DoClick = function(ply)
        netstream.Start( 'lib.profileLoad' )
        goMen:Remove()
    end

    function butForum:Paint( w, h )
        draw.RoundedBox( 3, 20, 0, w - 35, h, Color( 255, 255, 255, 150 ) )
    end

    function goBut:Paint( w, h )
        draw.RoundedBox( 3, 20, 0, w - 35, h, Color( 255, 255, 255, 150 ) )
    end

    function goMen:Paint()
        Derma_DrawBackgroundBlur( self, 5 )    
    end

    function goTxt:Paint( w, h )
        draw.RoundedBox( 5, 20, 0, w - 35, h, Color( 0, 0, 0, 200 ) )
        surface.SetDrawColor( 255, 255, 255, 255)
        surface.DrawOutlinedRect( 20, 0, w - 35, h)     
    end

    function goFr:Paint( w, h )
        draw.RoundedBox( 5, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
    end

    function goFr2:Paint( w, h )
        draw.RoundedBox( 2, 0, 0, w, h, Color( 250, 250, 250, 200 ) )
        draw.Text {
            font = "lib.profile",
            text = 'Добро пожаловать!',
            pos = { ScrW() / 5.5, -5 },
            xalign = TEXT_ALIGN_CENTER,
            color = Color(0, 0, 0)
		} 
    end

end

netstream.Hook( 'lib.welcomeOpen', startWelcome )

netstream.Hook( 'lib.welcomeMsg', function( ply )

    local time = os.date( "%H:%M:%S" , os.time() )

    chat.AddText( color_types[1], '[~]', Color(249, 174, 71), ' Вы проснулись. На часах ' .. time .. '.' .. ' На улице шумно.' )

end)