---

local ply = LocalPlayer()

function polyinv.openCustoms( itemList, charInv )

    PrintTable( itemList )

    if mn then mn:Remove() end
    mn = vgui.Create 'DFrame'
    mn:SetSize( 700, 500 )
    mn:SetTitle( 'Создание предметов' )
    mn:Center()
    mn:MakePopup()
    
    lst = mn:Add 'DPanel'
    lst:SetWide(200)
    lst:Dock(LEFT)

    local function isGun()
        -- wname = mn:Add 'DTextEntry'
        -- wname:Dock( TOP )
        -- wname:
    end
    -- isGun()

    local bt = lst:Add 'DListView'
    bt:Dock(FILL)
    bt:SetMultiSelect( false )    
    bt:AddColumn( 'LL' )
    bt:SetDataHeight( 25 )
    bt:DockMargin( 0, -16, 0, 0)   
    local i = 0
    for k, it in pairs( itemList ) do
        if it.isCustom then continue end

        local lv = bt:AddLine( it.name )
        lv.Columns[1]:SetFont( 'polyfont.sm' )
        function lv:OnSelect( line, isSel )
            if itpanel then itpanel:Remove() end

            itpanel = mn:Add 'DPanel'
            itpanel:Dock( FILL )

            local logo = itpanel:Add 'DPanel'
            logo:Dock(LEFT)
            logo:SetWide(120)
            logo:DockMargin( 10, 0, -160 , 340 )

            local n = itpanel:Add 'DTextEntry'
            n:Dock( TOP )
            n:SetText( it.name )
            n:SetFont( 'lib.notify' )
            n:DockMargin( 250, 5, 5, 0 )
            
            local d = itpanel:Add 'DTextEntry'
            d:Dock( TOP )
            d:SetFont( 'lib.notify' )
            d:SetText( it.desc )
            d:SetMultiline( true )
            d:SetSize( 0, 90 )
            d:DockMargin( 180, 10, 5, 0 )

            local w = itpanel:Add 'DTextEntry'
            w:Dock( TOP )
            w:SetNumeric( true )
            w:SetFont( 'lib.notify' )
            w:SetText( it.weight * 100 )            
            w:DockMargin( 40, 5, 360, 0 )

            local m = itpanel:Add 'DTextEntry'
            m:Dock( TOP )
            m:SetNumeric( true )
            m:SetFont( 'lib.notify' )
            m:SetText( it.max )            
            m:DockMargin( 40, 5, 360, 0 )            

            local b = itpanel:Add 'DButton'
            b:Dock( BOTTOM )
            b:SetText( 'Выдать' )
            b.DoClick = function(self)
        
                if n:GetValue() == it.name and
                   d:GetValue() == it.desc and
                   w:GetValue() / 100 == it.weight then netstream.Start( 'polyinv.give', it.class )                
                else
                    netstream.Start( 'polyinv.createItem', n:GetValue(), d:GetValue(), nil, tonumber(m:GetValue()), tonumber(w:GetValue() / 100) )
                end            
                
            end

            function logo:Paint(w, h)
                if it.logo then
                    draw.RoundedBox( 4, 0, 0, w, h, Color( 184, 53, 64, 10 ))
                        surface.SetDrawColor( 250, 160, 0, 255 )
                        surface.DrawOutlinedRect( 0, 0, w, h, 1.9 )

                    surface.SetMaterial( Material( it.logo, 'smooth' ) )
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
        end      
        i = i + 1
    end    

end

netstream.Start 'polyinv.sv-customOpen'
netstream.Hook( 'polyinv.openCustoms', polyinv.openCustoms )