polychat.Core = polychat.Core or {}

--
--  fonts
--

	library.createFont( 'polyfont.sm', 'Roboto', 21 )

--
-- core
--

hook.Add('HUDShouldDraw', 'clearDefaultChat', function(name)

    if name == 'CHudChat' then return false end

end)

hook.Add( "PlayerBindPress", "overrideChatbind", function( ply, bind, pressed )
    local bTeam = false
    if bind == "messagemode" then
        polychat.Core.open()
    elseif bind == "messagemode2" then
        bTeam = true
    else
        return
    end

    polychat.Core.open( bTeam )

    return true
end )

function chat.GetChatBoxPos()

    if IsValid(polychat.Core.pnl) then
        local x, y = polychat.Core.pnl:GetPos()
        return x, y
    else
        return 10, ScrH() * 0.5
    end
    
end

function chat.GetChatBoxSize()

    if IsValid(polychat.Core.pnl) then
        local x, y = polychat.Core.pnl:GetSize()
        return x, y
    else
        return 650, 400
    end

end

function chat.AddText( ... )

	local args = {...}

	for _, obj in ipairs( args ) do
		if type( obj ) == "table" then -- We were passed a color object
			polychat.Core.pnl.chat:InsertColorChange( obj.r, obj.g, obj.b, 255 )
		elseif type( obj ) == "string"  then -- This is just a string
			polychat.Core.pnl.chat:AppendText( obj )
		elseif obj:IsPlayer() then
			local col = GAMEMODE:GetTeamColor( obj ) -- Get the player's team color
			polychat.Core.pnl.chat:InsertColorChange( col.r, col.g, col.b, 255 ) -- Make their name that color
			polychat.Core.pnl.chat:AppendText( obj:Nick() )
		end
	end

	polychat.Core.pnl.chat:AppendText( "\n" )

end

-- hook.Add('OnPlayerChat', 'polyHandler', function(ply, msg, team, dead, prefixText, col1, col2)

--     if IsValid(chat.Panel) then
--         chat.AddText(col1, (prefixText or IsValid(ply) and ply:Name() or 'Голос из ниоткуда') .. ': ', col2, msg)
--         return true
--     end

-- end)

function polychat.Core.build()

    if polychat.Core.pnl then polychat.Core.pnl:Remove() end
    polychat.Core.pnl = vgui.Create 'DFrame'

    local pnl = polychat.Core.pnl
    pnl.alpha = 0
    pnl:SetSize( 650, 400 )
    pnl:AlignRight( 5 )
    pnl:AlignBottom( 5 )
    pnl:SetMinWidth(500)
    pnl:SetMinHeight(200)
    pnl:ShowCloseButton( false )
    pnl:SetTitle( '' )
    pnl:SetSizable( true )
    pnl:MakePopup()
    pnl.Paint = function( self, w, h )

		draw.RoundedBox( 10, 0, 0, w, h, Color( 0, 0, 0, 200 * self.alpha))
		draw.RoundedBoxEx(4, 0, h / 500, w, 15, Color(250, 160, 0, 200 * self.alpha), false, false, true, true)
		draw.RoundedBoxEx(50, 0, h - 30, w, 30, Color(0, 0, 0, 200 * self.alpha), false, false, true, true)  
		self.alpha = math.Approach(self.alpha, polychat.isOpen and 1 or 0, FrameTime() * 5)

    end

    polychat.Core.pnl.entry = pnl:Add 'DTextEntry'
    local hst = pnl.entry
    hst:Dock(BOTTOM)
    hst:DockMargin(1,1,1,1)
    hst:SetTall(22)
    hst:SetPaintBackground(false)
    hst:SetFont( 'polyfont.sm' )
    hst:SetTextColor(Color(255,255,255))
    hst:SetHighlightColor(Color(255,120,0))
    hst:SetCursorColor(Color(255,120,0))
    hst:RequestFocus()
    hst:SetHistoryEnabled( true )
	hst.Think = function(self)
        if gui.IsGameUIVisible() then
            polychat.Core.close()
			gui.HideGameUI()
        end

        if input.IsKeyDown(KEY_TAB) and self:HasFocus() then
            self:RequestFocus()
        end

        if input.IsKeyDown(KEY_ESCAPE) then
			polychat.Core.close()
			gui.HideGameUI()
		end
	end

    hst.OnEnter = function(self)
		polychat.Core.close()
    end

    polychat.Core.pnl.chat = pnl:Add 'RichText'
    local chat = pnl.chat
    chat:Dock(FILL)
	function chat.PerformLayout(self)
		self:SetFontInternal('polyfont.sm')
	end

end

function polychat.Core.close()

    local pnl = polychat.Core.pnl

	pnl:SetKeyboardInputEnabled(false)
	pnl:SetMouseInputEnabled(false)
	pnl.chat:SetVerticalScrollbarEnabled(false)
	pnl.chat:ResetAllFades(false, true, 0)

	hook.Run( "FinishChat" )
    polychat.isOpen = false

end

function polychat.Core.open()

    if not IsValid(polychat.Core.pnl) then polychat.Core.build() end
    
    local pnl = polychat.Core.pnl

	pnl:SetKeyboardInputEnabled(true )
	pnl:SetMouseInputEnabled(false)

    gamemode.Call('ChatTextChanged', '') 
    polychat.Core.pnl:SetVisible( true )
    polychat.Core.pnl.entry:RequestFocus()
    -- if IsValid(pnl.entry.Menu) then pnl.entry.Menu:Remove() end

	hook.Run( "StartChat" )
    polychat.isOpen = true

end

polychat.Core.build()

-- netstream.Hook( 'polychat.Emote', function( txt )
-- 	chat.AddText( txt )
-- end)
