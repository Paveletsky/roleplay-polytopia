function flycam( ply, pos, ang, fov )

    cur = RealTime()

    pos = LerpVector( 5, Vector( -3951, -1078, 43 ), Vector( -3951, -1078, 43 ) )
    ang = LerpAngle( 0, Angle(4, math.sin( cur+180 ), 0), Angle(4, 0, 0))
    fov = Lerp(1, 90, 90)

    return {
        origin = pos,
        angles = ang,
        fov = fov,
        znear = 5,
    }

end

local function startWelcome()

    hook.Add( 'CalcView', 'lib-flycam', flycam )

    hook.Remove( 'HUDPaint', 'library-hud')

    if IsValid(goMen) then goMen:Remove() end

    goMen = vgui.Create 'DFrame'
    goMen:SetSize( 800, 500 )
    goMen:Center()
    goMen:ShowCloseButton( false )
    goMen:MakePopup()
    goMen:SetTitle('')
    goMen:SetDraggable( false )

    goFr = vgui.Create( 'DPanel', goMen )
    goFr:Dock( FILL )
    goFr:DockMargin( 0, 0, 0, -75)

    goFr2 = vgui.Create( 'DPanel', goMen )
    goFr2:Dock( TOP )

    goTxt = vgui.Create( 'DScrollPanel', goFr )
    goTxt:Dock( TOP )
    goTxt:DockMargin( 0, 50, 0, 0)
    goTxt:SetSize( 110, 300 )
    
    local lore = [[
        Политопия — мир приключений и развития персонажа, в котором Вы играете в 
        свое удовольствие. Это режим Ролевой игры, в котором есть свои порядки
        и правила, нарушение которых крайне не приветствуется. 
        
        Ролевая игра — это выбор, реализация, соблюдение неких границ опреде-
        ленной роли, которую вы создаете для себя. В ролевой игре импровизация — 
        неотъемлемая часть, ибо весь алгоритм отыгрывания роли строится на ней, 
        и собственно, роли которую вы выбрали. В ролевой игре вы взаимодействуете 
        с другими персонажами, а люди при общении с вами, создают собственное 
        мнение, оно может быть предвзятым, все зависит опять же от характера 
        персонажа! 
    ]]



    goText = vgui.Create( 'DLabel', goTxt )
    goText:Dock( TOP )
    goText:DockMargin(0, -90, 0, 0)
    goText:SetSize( 0, 500 )
    goText:SetText( lore )
    goText:SetFont( 'lib.notify' )

    butForum = goMen:Add 'DButton'
    butForum:Dock( BOTTOM )
    butForum:DockMargin(0, 0, 0, 15)
    butForum:SetSize( 0, 30 )
    butForum:SetFont( 'lib.notify' )
    butForum:SetText( 'Форум' )
    butForum:SetTextColor( Color( 0, 0, 0 ) )

    goBut = vgui.Create( 'DButton', goMen )
    goBut:Dock( BOTTOM )
    goBut:DockMargin(0, 0, 0, 4)
    goBut:SetSize( 0, 30 )
    goBut:SetFont( 'lib.notify' )
    goBut:SetText( 'К персонажу' )
    goBut:SetTextColor( Color( 0, 0, 0 ) )
    goBut.DoClick = function(ply)
        RunConsoleCommand( 'polychars.OpenMenu' )
                -- netstream.Start( 'lib-unlockplayer' )
            -- hook.Remove( 'CalcView', 'flyover' )
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
            pos = { ScrW() / 5+10, -6 },
            xalign = TEXT_ALIGN_CENTER,
            color = Color(0, 0, 0)
		} 
    end

end

netstream.Hook( 'lib.spawnState', function() 
    hook.Add('CalcView', 'flyover', flyover)
end)

netstream.Hook( 'lib.unspawnState', function() 
    hook.Remove( 'CalcView', 'flyover' )
end)

netstream.Hook( 'lib.welcomeOpen', startWelcome )

netstream.Hook( 'lib.welcomeMsg', function( ply )

    local time = os.date( "%H:%M:%S" , os.time() )

    chat.AddText( color_types[1], '[~]', Color(249, 174, 71), ' Вы проснулись. На часах ' .. time .. '.' .. ' На улице шумно.' )

end)

startWelcome()