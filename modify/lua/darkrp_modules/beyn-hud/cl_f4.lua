--
-- hello world 
--

-- function openMenu()

    if IsValid(MENU) then MENU:Remove() end

    gen = vgui.Create 'DFrame'
        MENU = gen
    gen:SetSize( 500,700 )
    gen:AlignTop(5)
    gen:AlignLeft(5)
    gen:SetTitle('')
    gen:MakePopup()
    gen:SetDraggable( false )
    gen:SetKeyBoardInputEnabled( false )
    gen:ShowCloseButton( false )

    bar = vgui.Create( 'DPropertySheet', gen)
    bar:Dock(FILL)

    dev = vgui.Create( 'DIconBrowser', gen )
    dev.OnChange = function(self)
        SetClipboardText( self:GetSelectedIcon() )
        chat.AddText( Color( 255, 0, 0, 0), "Выбрано: ", self:GetSelectedIcon() )
    end

    bar:AddSheet( "Для разработки", dev, "games/16/garrysmod.png", false, false, "Иконки GMod'a")

-- end

netstream.Hook( 'startMenu', function()
    
    if gen:IsVisible() == false then gen:SetVisible( true ) gen:SlideDown( 0.2 ) else gen:SetVisible( false ) end

end)
