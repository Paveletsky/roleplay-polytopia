local pl = LocalPlayer()

LIB_CONFIG_RANDNAMES = {
	'Джэк Старший',
    'Винсент Лейн',
    'Винчензо Чили',
	'Йозеф Чарк',
    'Рэнди Армстронг',
    'Кристофер Уайтфилд',
    'Джон Мэтьюс',
    'Джеймс Кейтфилд',
    'Дин Йеванс',
	'Пол Роланд',
	'Джимми Стюарт',
	'Клифолд Бэверли',
	'Брайан Феллер',
	'Ларри Бэнсон',
	'Рудольф Тэйту',
	'Луис Нельсон',
	'Грант Шультц',
	'Джон Бёрс',
	'Стивен Дайк',
}

LIB_CONFIG_RANDDESCRIPTIONS = {
    'Парень, лицо побитое, на вид ему около 27 лет.',
    'Молодой человек низкого роста, худощавого телосложения, с редкими короткими курчавыми волосами рыжего цвета.',
    'Мужчина высокого роста, стройный, вдоль глаза имеется шрам.',
    'Измученный парень, под глазами мешки.',
    'Мужчина 30-ти лет, большие выразительные глаза с ироническим взглядом.',
}

local tempModel, tSkin = 1, 1

function library.openMenu( owner, data )
    hook.Remove( 'HUDPaint', 'library-hud')
    -- hook.Add( 'CalcView', 'lib-flycam', flycam )
    netstream.Start( 'lib-lockplayer' )

    if IsValid(MENU) then MENU:Remove() end

    mainFr = vgui.Create 'DFrame'
        MENU = mainFr

    mainFr:SetSize( 500, 700 )
    mainFr:Center()
    mainFr:ShowCloseButton( true  )
    mainFr:MakePopup()
    mainFr:SetDraggable( false )
    mainFr:SetTitle('Меню персонажей')

    local bar = mainFr:Add 'DPropertySheet'
    bar:Dock(FILL)

    local set = bar:Add 'DPanel'

    local but1 = bar:Add 'DButton'
    but1:Dock( BOTTOM )
    but1:SetText( 'Обновить страницу' )
    but1:SetSize( 120, 22)

    local but2 = bar:Add 'DButton'
    but2:Dock( BOTTOM )
    but2:SetText( 'Создать' )
    
    
    lst = set:Add 'DListView'
    lst:Dock( FILL )
    lst:DockMargin( 0, 0, 0, 30)
    lst:AddColumn( 'Модель' )
    lst:SetMultiSelect( false )
    lst:AddColumn( 'Имя персонажа' )
    lst:AddColumn( 'Описание' )

    local y = 15

    local lore = [[Вы можете создать всего три персонажа, основные данные должны соответствовать нашему лору и сеттингу. Настоятельно рекомендуем прочесть его, а также правила сервера. Надеюсь, вам понравится у нас. Зови друзей чтобы было веселей. Удачи =) ]]

    local goText = bar:Add 'RichText'
    goText:Dock( FILL )
    goText:SetVisible( false )
    goText:AppendText( lore )
    goText:DockMargin(0, 0, 0, 0)

    function goText:PerformLayout()
        self:SetFontInternal( 'lib.notify' )
        self:SetFGColor( Color( 255, 255, 255 ) )            
    end

    for k, v in pairs( data ) do
        local charList = pon.decode( v.chars )
        local glList = pon.decode( v.chars )

        if #charList == 3 then
            but2:SetDisabled( true )
        end

        if #charList == 0 then
            goText:SetVisible( true  )
            lst:SetVisible( false )         
        end

        for k, v in pairs( charList ) do
            mdl = lst:Add 'DModelPanel'
            mdl:SetSize( 50, 50 )
            mdl:SetPos( 0, y )
            mdl:SetFOV( 10 )
            mdl:SetLookAt( Vector( 0, -2, 67 ) )
            mdl:SetModel( v.skin )
            mdl.Entity:SetSkin( v.mdskin )
            for k, v in pairs( v.bg ) do
                mdl.Entity:SetBodygroup( k, v )
            end

            y = y + mdl:GetTall()
            
            lst:AddLine( '', v.rpname, v.desc )
            lst:SetDataHeight( 50 )
            lst.Columns[1]:SetFixedWidth( 50 )
            lst.Columns[1]:SetFixedWidth( 50 )
            lst.OnRowRightClick = function( lineID, line )
                local m = DermaMenu()
                m:AddOption("Взять персонажа", function()
                    netstream.Start( 'polychars.Pick', line )
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
                            netstream.Start 'polychars.open'
                        end, 'Отменить' )
                end):SetImage("icon16/user_delete.png")
                m:Open()
            end
        end
    end      
            
    bar:AddSheet( "Персонаж", set, "icon16/cog.png", false, false, "Для вашего комфорта <3")

    function but2:DoClick()
        library.charMenu()
    end

    function but1:DoClick()
        netstream.Start( 'polychars.Open' )
    end

end

function library.charMenu()

    if charFr then charFr:Remove() end
    
    charFr = vgui.Create 'DFrame'
    charFr:SetSize( 800, ScrH() / 1.02 )
    charFr:ShowCloseButton(false)
    charFr:SetDraggable(false)
    charFr:SetTitle( '' )
    charFr:Center()
    charFr:MakePopup()
    charFr.Paint = function( self, w, h )

        draw.RoundedBox( 1, 0, 0, w, h, Color( 20, 20, 20, 220 ))
        draw.RoundedBoxEx(10, 0, h / 150-9, w, 10, Color(250, 160, 0, 200 ), false, false, true, true)

    end

    -- mdl:SetLookAt( Vector( 0,10,0 ) )

    mpnl = charFr:Add 'DPanel'
    mpnl:SetSize( 0, 0 )
    mpnl:DockMargin( 2, 5, 2, 0 )
    mpnl:Dock(FILL)
    mpnl:SetAlpha(220)

	modelPreview = mpnl:Add('DModelPanel')
	modelPreview:SetFont('lib.notify')
    modelPreview:SetSize( 750, 950 )
    -- modelPreview:SetTall( mpnl:GetTall()  )
    modelPreview:SetFOV(40)
    modelPreview:SetModel( polychars.Models[tempModel] )
	modelPreview:SetCamPos(Vector(100,0,34))
	modelPreview:SetLookAng(Angle(0,180,0))
    modelPreview:SetAnimated(true)
	modelPreview.vRawCamPos = Vector(0,0,5.5)
	modelPreview.tgtLookAngle = Angle(0,180,0)

    namName = charFr:Add 'DTextEntry'
    namName:Dock( TOP )    
    namName:DockMargin( 0, 0, charFr:GetSize() / 1.8, 5 )
    namName:SetFont('lib.notify')
    namName:SetText( table.Random(LIB_CONFIG_RANDNAMES) )
    namName:SetPlaceholderText( 'Имя персонажа' )
    namName.OnEnter = function( self )
        chat.AddText( self:GetValue() )
    end

    --
    --  MODEL PROPERTIES
    --

    local tbl = {}
    local t1 = {}

    function getParams( model )
        
        for _, v in pairs( tbl ) do
            v:InvalidateParent( true )
            v:Remove()            
        end

        for _, v in pairs( t1 ) do
            v:InvalidateParent( true )
            v:Remove()            
        end    

        table.Empty(tbl)
        table.Empty(t1)

        for k, v in pairs( modelPreview.Entity:GetBodyGroups() ) do                        
            if string.find( v['submodels'][0], 'reference.smd' ) or v['submodels'][0] == 'pm_male_06_male_06_body0_model0.smd' then continue end            

            PrintTable( v )   
            local bodyGroupID = 1
            
            local cr = table.insert( tbl, mpnl:Add 'DPanel' )
            local ct = table.insert( t1, mpnl:Add 'DLabel' )

            local pnl = tbl[#tbl]
            local t = t1[#t1]

            pnl:Dock( TOP )
            pnl:SetTall( 40 )
            pnl:DockMargin( 200, 60, 200, 50 )
            -- pnl:Remove()
            pnl.Paint = function(self)
                
            end
            
            local b = pnl:Add 'DButton'
            b:Dock( LEFT )
            b:SetText '<'
            b:SetFont 'lib.notify'
            b.Paint = function( self, w, h )
            end
            b.DoClick = function( self )
                if v['submodels'][bodyGroupID] == '' then
                    -- bodyGroupID = -1
                end
                if bodyGroupID != -1 then
                    bodyGroupID = bodyGroupID - 1
                    modelPreview.Entity:SetBodygroup( v['id'], bodyGroupID )
                else 
                    bodyGroupID = #v['submodels']
                end
            end

            local b = pnl:Add 'DButton'
            b:Dock( RIGHT )
            b:SetText '>'
            b:SetFont 'lib.notify'
            b.Paint = function( self, w, h )
            end
            b.DoClick = function( self )
                if polychars.BlockedBg[v['submodels'][bodyGroupID + 1]] then
                    bodyGroupID = -1
                end        
                if bodyGroupID != #v['submodels'] then
                    bodyGroupID = bodyGroupID + 1
                    modelPreview.Entity:SetBodygroup( v['id'], bodyGroupID )
                else
                    bodyGroupID = -1
                end
            end  
            
            t:Dock( TOP )
            t:DockMargin( 30, -80, 0, 0 )
            t:SetText(polychars.Lang[v['name']])    
            t:SetFont 'lib.notify'    

        end
        
    end

    local pnl = mpnl:Add 'DPanel'
    pnl:Dock( TOP )
    pnl:SetTall( 40 )
    pnl:DockMargin( 150, 10, 150, 50 )
    -- pnl:Remove()
    pnl.Paint = function(self)
        draw.SimpleText( 'Типаж', 'lib.notify', pnl:GetSize() / 2, 6, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
    end

    local pnl2 = mpnl:Add 'DPanel'
    pnl2:Dock( TOP )
    pnl2:SetTall( 40 )
    pnl2:DockMargin( 150, -50, 150, 50 )
    -- pnl:Remove()
    pnl2.Paint = function(self)
        draw.SimpleText( 'Лицо', 'lib.notify', pnl:GetSize() / 2, 6, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
    end

    local b = pnl2:Add 'DButton'
    b:Dock( LEFT )
    b:DockMargin( 0, 0, 0, 0 )
    b:SetText '<'
    b:SetFont 'lib.notify'
    b.Paint = function( self, w, h )
    end
    b.DoClick = function( self )
        if tSkin != 1 then
            tSkin = tSkin - 1 
            modelPreview.Entity:SetSkin( tSkin )   
        else
            tSkin = modelPreview.Entity:SkinCount() + 1   
        end
    end

    local b = pnl2:Add 'DButton'
    b:Dock( RIGHT )
    b:DockMargin( 0, 0, 0, 0 )
    b:SetText '>'
    b:SetFont 'lib.notify'
    b.Paint = function( self, w, h )
    end
    b.DoClick = function( self )
        if tSkin ~= modelPreview.Entity:SkinCount() then
            tSkin = tSkin + 1
            modelPreview.Entity:SetSkin( tSkin )
        end
        if tSkin == modelPreview.Entity:SkinCount() then
            tSkin = 1
        end
    end 

    local b = pnl:Add 'DButton'
    b:Dock( LEFT )
    b:DockMargin( 0, 0, 0, 0 )
    b:SetText '<'
    b:SetFont 'lib.notify'
    b.Paint = function( self, w, h )
    end
    b.DoClick = function( self )
        if tempModel != 1 then
            tempModel = tempModel - 1 
            modelPreview:SetModel( polychars.Models[tempModel] )    
        else
            tempModel = #polychars.Models + 1   
        end
        tSkin = 1
    end

    local b = pnl:Add 'DButton'
    b:Dock( RIGHT )
    b:DockMargin( 0, 0, 0, 0 )
    b:SetText '>'
    b:SetFont 'lib.notify'
    b.Paint = function( self, w, h )
    end
    b.DoClick = function( self )
        modelPreview.Entity:SetBodyGroups( '000000000' )
        if tempModel ~= #polychars.Models then
            tempModel = tempModel + 1
            modelPreview:SetModel( polychars.Models[tempModel] )
        end
        if tempModel == #polychars.Models then
            tempModel = 1
        end
        tSkin = 1
        getParams( modelPreview.Entity )
    end 

    --
    --  TEXT ENTRIES
    --

    namDesc = charFr:Add 'DTextEntry'
    namDesc:Dock(TOP)
    namDesc:SetTall( 50 )
    namDesc:SetFont('lib.notify')
    namDesc:SetText( table.Random(LIB_CONFIG_RANDDESCRIPTIONS) )
    namDesc:SetPlaceholderText( 'Описание внешности' )
    namDesc:SetMultiline( true )
    function namDesc.AllowInput( self, stringValue )
        if string.len( namDesc:GetValue() ) > 150 then
            return true
        end
    end

    local crtBut = charFr:Add 'DButton'
    crtBut:SetText( 'Сохранить' )
    crtBut:SetSize( 100, 26 )
    crtBut:AlignBottom( 5 )	crtBut:AlignLeft( 5 )
    crtBut.DoClick = function( ply )
        if namName:GetValue() == '' then polychat.polyMsg( 1, 'Укажите имя персонажа!' ) return end

        local bgs = {}
        for k, v in pairs( modelPreview.Entity:GetBodyGroups() ) do                    
            table.insert( bgs, modelPreview.Entity:GetBodygroup( k ) )
        end
                  
        netstream.Start( 'polychars.Create', namName:GetValue(), namDesc:GetValue(), modelPreview.Entity:GetModelScale(), modelPreview.Entity:GetModel(), tSkin, bgs )
        timer.Simple( 0.3, function()
            netstream.Start 'polychars.Open'
        end)
        charFr:Remove()
    end

    function modelPreview:LayoutEntity( ent )
        ent:SetSequence( ent:LookupSequence( 'pose_standing_01' ) )
        modelPreview:RunAnimation()
    end

end

-- library.charMenu()
netstream.Start 'polychars.Open'

netstream.Hook( 'polychars.open', library.openMenu )