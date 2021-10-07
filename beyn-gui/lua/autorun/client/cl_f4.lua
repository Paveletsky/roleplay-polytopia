--
-- hello world 
--

surface.CreateFont('lib.name', {
	font = 'Calibri',
	extended = true,
	size = 50,
	weight = 0,
	antialias = true,
})

surface.CreateFont('lib.notify', {
	font = 'Calibri',
	extended = true,
	size = 25,
	weight = 0,
	antialias = true,
})

surface.CreateFont('lib.profile', {
	font = 'Calibri',
	extended = true,
	size = 35,
	weight = 0,
	antialias = true,
})

local function openMenu( ply )

    if IsValid(MENU) then MENU:Remove() end

    gen = vgui.Create( 'DFrame' )
        MENU = gen
    gen:DockPadding(10, 10, 1000, 10)
    gen:Dock(FILL)
    gen:MakePopup()
    gen:SetTitle('')
    gen:ShowCloseButton( false )
    gen:SetDraggable( false )
    gen.OnClick = function( self )
        self:SetVisible( false )
    end

    cls = vgui.Create( 'DButton', gen )
    cls:SetSize(5000, 5000)
    cls.Paint = function() end
    cls.DoClick = function( self )
        gen:SetVisible( false )
        self:SetVisible( false )
    end
    
    bar = vgui.Create( 'DPropertySheet', gen)
    bar:Dock(FILL)

    mpnl = vgui.Create( 'DPanel', gen)
    mpnl:SetSize( 500, 0 )
    mpnl:DockMargin( 330, 0, -990, 0 )
    mpnl:Dock(RIGHT)

    mdl = vgui.Create( "DModelPanel", mpnl )
    mdl:Dock(FILL)
    mdl:DockMargin(0, 0, 0, 100)
    mdl:SetFOV( 40 )
    mdl:SetAmbientLight(Color(255, 150, 0, 150))
    mdl:SetAnimated( true )

    mdl:SetModel( LocalPlayer():GetModel() )
    
	-- local bJS = util.JSONToTable( LocalPlayer():GetNetVar( 'mdl_bg' ) )
    -- for k, v in pairs( LocalPlayer():GetBodyGroups() ) do
    --     if v['name'] != 'head' then 
    --         mdl.Entity:SetBodygroup( v['id'], bJS[v['id']] )
    --     end

    -- end


    dev = vgui.Create( 'DIconBrowser', gen )
    dev.OnChange = function(self)
        SetClipboardText( self:GetSelectedIcon() )
        chat.AddText( Color( 255, 0, 0, 0), "Выбрано: ", self:GetSelectedIcon() )
    end

    ch = vgui.Create( 'DPanel', gen )    
    ch:Dock(FILL)

    namText = vgui.Create( 'DLabel', ch )
    namText:SetFont( 'lib.profile' )
    namText:SetPos( ScrW() / 25, ScrH() / 8.3 )
    namText:SetText( 'Имя персонажа' )
    namText:SetSize( 200, 35 )

    descText = vgui.Create( 'DLabel', ch )
    descText:SetFont( 'lib.profile' )
    descText:SetPos( ScrW() / 3, ScrH() / 5.5 )
    descText:SetText( 'Отображаемое описание' )
    descText:SetSize( 400, 35 )

    descText2 = vgui.Create( 'DLabel', ch )
    descText2:SetFont( 'lib.notify' )
    descText2:SetPos( ScrW() / 2.95, ScrH() / 4.5 )
    descText2:SetText( 'Опишите внешние черты персонажа, не \nстоит говорить о его характере. Постарайтесь \nуложиться в 200 символов!' )
    descText2:SetSize( 400, 70 )
    descText2:SetVisible(false)

    butDesc = vgui.Create('DImageButton', ch)
    butDesc:SetSize( 18, 18 )
    butDesc:AlignLeft( 970 )
    butDesc:AlignTop( 207 )
    butDesc:SetToolTip( 'Показать подсказку ( пропадет через 10 секунд )' )
    butDesc:SetMaterial( 'icon16/lightbulb.png' )
    butDesc.DoClick = function()
        
        if descText2:IsVisible() == true then return false else descText2:SetVisible( true )  end
        timer.Simple( 10, function() descText2:SetVisible(false) end  )
    
    end

    namName = vgui.Create( 'DTextEntry', ch )
    namName:Center()
    namName:SetFont('lib.notify')
    namName:SetText( LocalPlayer():GetNetVar( 'name' ) )
    namName:SetSize( 300, 22 )
    namName:SetPos( 280, 140 )
	namName.OnEnter = function( self )
		chat.AddText( self:GetValue() )
	end

    namDesc = vgui.Create( 'DTextEntry', ch )
    namDesc:Center()    
    namDesc:SetFont('lib.notify')
    namDesc:SetText( LocalPlayer():GetNetVar( 'desc' ) or 'Описания нет' )
    namDesc:SetSize( 400, 22 )
    namDesc:SetPos( 230, 203 )

    mdlType = ch:Add 'DNumSlider'
    mdlType:SetSize( 600, 15)
    mdlType:AlignTop( 450 )
    mdlType:AlignLeft( 100 )
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
    local fromTop = 550

    local function DrawBodygroupsSliders()
        for k,v in pairs(mdl.Entity:GetBodyGroups()) do
                ch:Refresh()
                table.insert( mdlBgroups, ch:Add( 'DNumSlider' ) )
                mdlBgroups[#mdlBgroups]:SetSize(600,15)
                mdlBgroups[#mdlBgroups]:AlignTop(fromTop)
                fromTop = fromTop + 50
                mdlBgroups[#mdlBgroups]:AlignLeft(100)
                mdlBgroups[#mdlBgroups]:SetMax(v['num'] - 1)
                mdlBgroups[#mdlBgroups]:SetMin(0)
                mdlBgroups[#mdlBgroups]:SetDecimals(0)
                mdlBgroups[#mdlBgroups].OnValueChanged = function(self, value)
                    mdl.Entity:SetAnimation(1)
                    mdl.Entity:SetBodygroup(v['id'], value)
                end
            
            end
    end

    local function DeleteBodygroupsSliders()
        for k,v in pairs( mdlBgroups ) do
                v:InvalidateParent( true )
                v:Remove()
                ch:Refresh()
                
            end
            table.Empty(mdlBgroups)
    end

    mdlSkin = ch:Add 'DNumSlider'
    mdlSkin:SetSize( 600, 15)
    mdlSkin:AlignTop( 500 )
    mdlSkin:AlignLeft( 100 )
    mdlSkin:SetMax( i )
    mdlSkin:SetMin( 1 )
    mdlSkin:SetDecimals( 0 )    
    mdlSkin:SetValue(getIndex(LocalPlayer():GetNetVar('mdl_skin'),LocalPlayer():getJobTable()['model']))
    DrawBodygroupsSliders()
    mdlSkin.OnValueChanged = function( self, value )
    
        if math.Round(value) != prevVal then
            prevVal = math.Round(value)
            mdl.Entity:SetAnimation( 1 )
            local model = LocalPlayer():getJobTable()['model'][math.Round(value)]
            mdl.Entity:SetModel(model)
            fromTop = 550
            DeleteBodygroupsSliders()
            DrawBodygroupsSliders()
        end
    
    end

    function mdl:LayoutEntity( ent )
        ent:SetSequence( ent:LookupSequence( 'pose_standing_01' ) )
        mdl:RunAnimation()
    end

    set = vgui.Create( 'DPanel', gen )
    set:Dock(FILL)

    bar:AddSheet( "Персонаж", ch, "icon16/vcard_edit.png", false, false, "Ваш игровой персонаж")
    bar:AddSheet( "Игровые настройки", set, "icon16/cog.png", false, false, "Для вашего комфорта <3")
    bar:AddSheet( "Для разработки", dev, "games/16/garrysmod.png", false, false, "Иконки GMod'a")

    applyBut = vgui.Create( 'DButton', gen )
    applyBut:Dock( BOTTOM )
    applyBut:SetSize(0, 30)
    applyBut:SetText( '' )
    applyBut.DoClick = function( ply )

        applyBut:SetDisabled( true )

        ply:SetNetVar( 'gui.Test', true )

        netstream.Start( 'changeChar2', namName:GetValue(), namDesc:GetValue(), mdl.Entity:GetModel(), mdl.Entity:GetModelScale(), bGrps )

        timer.Create( 'gui.f4-buttonCheck', 5, 1, function()
        
            ply:SetNetVar( 'gui.Test', false )

            applyBut:SetDisabled( false )    
        
        end)
    
    end



    -- 
    -- painting
    --


    -- function applyBut:Paint( w, h )
    --     draw.RoundedBox( 6, 0, 0, w, h, Color( 230, 138, 0, 240 ) )
    --     draw.Text {
    --         font = "lib.notify",
    --         text = "Применить настройки",
    --         pos = { ScrW() / 3.6, 0 },
    --         xalign = TEXT_ALIGN_CENTER,
    --         color = Color(255, 255, 255)
	-- 	}
    -- end

    function gen:Paint( w, h )
        draw.RoundedBox( 2, 0, 0, w, h, Color( 0, 0, 0, 240 ) )
        Derma_DrawBackgroundBlur( self, 5 )    
    end

    function ch:Paint( w, h, ply )

        local txt = LocalPlayer():GetNetVar( 'name' )
        local desc = LocalPlayer():GetNetVar( 'desc' ) or 'Описания нет' 
        draw.RoundedBox( 5, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
        draw.Text {
            font = "lib.name",
            text = txt,
            pos = { ScrW() / 3.85 , ScrH() / 15 - 50 },
            xalign = TEXT_ALIGN_CENTER,
            color = Color(200, 200, 200)
		} draw.Text {
            font = "lib.notify",
            text = desc,
            pos = { ScrW() / 3.85 , ScrH() / 15 - 5 },
            xalign = TEXT_ALIGN_CENTER,
            color = Color(200, 200, 200)
		} draw.Text {
            font = "lib.notify",
            text = "Перепроверяй данные, на смену персонажа действует кулдаун!",
            pos = { ScrW() / 3.85 , ScrH() - 120 },
            xalign = TEXT_ALIGN_CENTER,
            color = Color(200, 200, 200)
		}

    end
    
    function mpnl:Paint( w, h )
        draw.RoundedBox( 5, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
        draw.Text {
            font = "lib.name",
            text = 'Модель персонажа',
            pos = { 250 , 10 },
            xalign = TEXT_ALIGN_CENTER,
            color = Color(200, 200, 200)
		}
    end

    function set:Paint( w, h )
        draw.RoundedBox( 5, -500, 0, w, h, Color( 0, 0, 0, 200 ) )
    end

    function bar:Paint( w, h )
        draw.RoundedBox( 1, 0, -1000, w, h, Color( 230, 138, 0, 200 ) )
    end

end

net.Receive( 'lib.openf4Menu', function( ply )

        openMenu()

    netstream.Start( 'library.loadData' )

end)
