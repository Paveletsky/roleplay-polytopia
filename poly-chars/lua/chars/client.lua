hook.Add( 'Think', 'init-lib', function()
    hook.Remove( 'Think', 'init-lib' )
        
    local pl = LocalPlayer()

    -- hook.Run( 'library.hook-flyover' )
        -- hook.Remove( 'CalcView', 'lib-flycam' )

    function library.openMenu()

        hook.Remove( 'HUDPaint', 'library-hud')
        hook.Add( 'CalcView', 'lib-flycam', flycam )
        netstream.Start( 'lib-lockplayer' )

        if IsValid(MENU) then MENU:Remove() end

        mainFr = vgui.Create 'DFrame'
            MENU = mainFr

        mainFr:SetSize( 500, 700 )
        mainFr:Center()
        mainFr:ShowCloseButton( false )
        mainFr:MakePopup()
        mainFr:SetDraggable( false )
        mainFr:SetTitle('Меню персонажей')

        local bar = mainFr:Add 'DPropertySheet'
        bar:Dock(FILL)

        local set = bar:Add 'DPanel'

        local but1 = bar:Add 'DButton'
        but1:SetText( 'Обновить страницу' )
        but1:SetSize( 120, 22)
        but1:SetPos( ScrW() / 10 - 180, ScrH() / 2 + 92 )

        local but2 = bar:Add 'DButton'
        but2:SetText( 'Создать' )
        but2:SetSize( 120, 22)
        but2:SetPos( ScrW() / 10 + 165, ScrH() / 2 + 92 )
        
        lst = set:Add 'DListView'
        lst:Dock( FILL )
        lst:DockMargin( 0, 0, 0, 30)
        lst:AddColumn( 'Модель' )
        lst:SetMultiSelect( false )
        lst:AddColumn( 'Имя персонажа' )
        lst:AddColumn( 'Описание' )

        local y = 15
        
        local cache = pl:GetNetVar( 'os_characters' )
        -- if cache != '' then
            for k, v in pairs( cache ) do
                local charList = pon.decode( v.chars )
                local glList = pon.decode( v.chars )

                if #charList == 3 then
                    but2:SetDisabled( true )
                end

                for k, v in pairs( charList ) do
                
                    mdl = lst:Add 'DModelPanel'
                    mdl:SetSize( 50, 50 )
                    mdl:SetPos( 0, y )
                    mdl:SetFOV( 10 )
                    mdl:SetLookAt( Vector( 0, -2, 67 ) )
                    mdl:SetModel( v.skin )
                        y = y + mdl:GetTall()
                    lst:AddLine( '', v.rpname, v.desc )
                    lst:SetDataHeight( 50 )
                    lst.Columns[1]:SetFixedWidth( 50 )
                    lst.Columns[1]:SetFixedWidth( 50 )
                    lst.OnRowRightClick = function( lineID, line )
                        local m = DermaMenu()
                        m:AddOption("Взять персонажа", function()
                            netstream.Start( 'polychars.Pick', glList[line].rpname, glList[line].desc, glList[line].scale, glList[line].skin )
                            netstream.Start( 'testBG', glList[line].bg ) 
                            netstream.Start( 'lib-unlockplayer' )
                                hook.Remove( 'CalcView', 'lib-flycam' )
                                hook.Add('HUDPaint', 'library-hud', function()
                                    drawPlrs()
                                    drawGui()
                                end)                            
                            mainFr:Remove()
                        end):SetImage("icon16/user.png")
                        
                        m:AddOption("Удалить", function()
                            Derma_Query( 'Вы уверены, что хотите удалить этого персонажа? Восстановить ничего уже не получится!', 'Подтвердить удаление', 'Подтвердить', function()          
                                    netstream.Start( 'polychars.Delete', line )
                                    timer.Simple( 0.3, function()
                                        RunConsoleCommand( 'polychars.OpenMenu' )
                                    end)
                                end, 'Отменить' )
                        end):SetImage("icon16/user_delete.png")
                        m:Open()
                    end
                    
                end
            end      
        -- end
        
        bar:AddSheet( "Персонаж", set, "icon16/cog.png", false, false, "Для вашего комфорта <3")

        function but2:DoClick()
            library.charMenu()
        end

        function but1:DoClick()
            RunConsoleCommand( 'polychars.OpenMenu' )
        end

    end


    function library.charMenu()

        if charFr then charFr:Remove() end
        
        charFr = vgui.Create 'DFrame'
        charFr:SetSize( 600, 650)
        charFr:Center()
        charFr:MakePopup()


        -- local slr = charFr:Add 'DSlider'

        -- slr:SetSize( 10, 50 ) 


        mpnl = charFr:Add 'DPanel'
        mpnl:SetSize( 250, 0 )
        mpnl:DockMargin( 0, 0, 0, 0 )
        mpnl:Dock(RIGHT)

        mdl = mpnl:Add 'DModelPanel'
        mdl:Dock(FILL)
        mdl:SetFOV( 30 )
        mdl:SetAmbientLight(Color(255, 150, 0, 150))
        mdl:SetAnimated( true )
        mdl:SetModel( LocalPlayer():GetModel() )

        -- mdl:SetLookAt( Vector( 0,10,0 ) )

        namName = charFr:Add 'DTextEntry'
        namName:SetFont('lib.notify')
        namName:SetText( 'Введите имя' )
        namName:SetSize( 300, 22 )
        namName:SetPos( 20, 50 )
        namName.OnEnter = function( self )
            chat.AddText( self:GetValue() )
        end

        namDesc = charFr:Add 'DTextEntry'
        namDesc:Center()    
        namDesc:SetFont('lib.notify')
        namDesc:SetText( 'Введите описание' )
        namDesc:SetMultiline( true )
        namDesc:SetSize( 300, 120 )
        namDesc:SetPos( 20, 80 )
        function namDesc.AllowInput( self, stringValue )
            if string.len( namDesc:GetValue() ) > 150 then
                return true
            end
        end

        mdlType = charFr:Add 'DNumSlider'
        mdlType:SetSize( 550, 15)
        mdlType:SetPos( -200, 260 )
        mdlType:SetMax( 1.10 )
        mdlType:SetMin( 1 )
        mdlType.OnValueChanged = function( self, value )
            mdl.Entity:SetModelScale( value )
        end

        local i = 0
        for k, mdls in pairs( LocalPlayer():getJobTable()['model'] ) do
            i = i + 1
        end


        local function getIndex(val, tab_to_pasre)

            for k,v in pairs(tab_to_pasre) do 
                if v==val then return k end
            end
            return nil

        end

    local mdlBgroups = {}
        local prevVal = 1
        local fromTop = 250
        mdlSkin = charFr:Add 'DNumSlider'
        mdlSkin:SetSize( 550, 15)
        mdlSkin:SetPos( -200, 300)
        mdlSkin:SetMax( i )
        mdlSkin:SetMin( 1 )
        mdlSkin:SetDecimals( 0 )    
        mdlSkin:SetValue(getIndex(LocalPlayer():GetNetVar('mdl_skin'),LocalPlayer():getJobTable()['model']))
        
        mdlSkin.OnValueChanged = function( self, value )
        
            if math.Round(value) != prevVal then 

                prevVal = math.Round(value)
                mdl.Entity:SetAnimation( 1 )
                local model = LocalPlayer():getJobTable()['model'][math.Round(value)]
                mdl.Entity:SetModel(model)
                fromTop = 340

                for k,v in pairs( mdlBgroups ) do
                    v:InvalidateParent( true )
                    v:Remove()
                    charFr:Refresh()
                    
                end

                table.Empty(mdlBgroups)

                for k,v in pairs(mdl.Entity:GetBodyGroups()) do
                    charFr:Refresh()
                    table.insert( mdlBgroups, charFr:Add( 'DNumSlider' ) )
                    mdlBgroups[#mdlBgroups]:SetSize( 550, 15 )
                    mdlBgroups[#mdlBgroups]:SetPos( -200, fromTop )
                    fromTop = fromTop + 40
                    mdlBgroups[#mdlBgroups]:SetMax(v['num'] - 1)
                    mdlBgroups[#mdlBgroups]:SetMin(0)
                    mdlBgroups[#mdlBgroups]:SetDecimals(0)
                    mdlBgroups[#mdlBgroups].OnValueChanged = function(self, value)
                        mdl.Entity:SetAnimation(1)
                        mdl.Entity:SetBodygroup(v['id'], value)
                    end
                
                end
        
            end
        
        end

        local crtBut = charFr:Add 'DButton'
        crtBut:SetText( 'Сохранить' )
        crtBut:SetSize( 100, 26 )
        crtBut:AlignBottom( 5 )	crtBut:AlignLeft( 5 )
        crtBut.DoClick = function( ply )
            local bGrps = {}
            for k,v in pairs (mdlBgroups) do
                table.insert(bGrps,math.floor(v:GetValue()))
            end                            
            netstream.Start( 'polychars.Create', namName:GetValue(), namDesc:GetValue(), mdl.Entity:GetModelScale(), mdl.Entity:GetModel(), bGrps )
            timer.Simple( 0.3, function()
                RunConsoleCommand( 'polychars.OpenMenu' )
            end)
            charFr:Remove()
        end

        function mdl:LayoutEntity( ent )
            ent:SetSequence( ent:LookupSequence( 'pose_standing_01' ) )
            mdl:RunAnimation()
        end

    end

    concommand.Add( 'polychars.OpenMenu', library.openMenu )

end)