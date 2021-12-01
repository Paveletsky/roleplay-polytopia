polychat.Core = polychat.Core or {}

--
--  fonts
--

	library.createFont( 'polyfont.sm', 'Calibri', 21 )

--
-- core
--

hook.Add('HUDShouldDraw', 'clearDefaultChat', function(name)

    if name == 'CHudChat' then return false end

end)

hook.Add('PlayerBindPress', 'octochat', function(ply, bind, press)

    if bind == 'messagemode' or bind == 'messagemode2' then
        if not IsValid(polychat.Core.pnl) then polychat.Core.build() end
        polychat.Core.open()
        polychat.team = bind == 'messagemode2'

        local text, now = hook.Run('octochat.chatOpenText', bind), polychat.Core.pnl.entry:GetText()
        if isstring(text) and now:sub(1, text:len()) ~= text then
            local new = text .. now
            polychat.Core.pnl.entry:SetText(new)
            polychat.Core.pnl.entry:SetCaretPos(utf8.len(new))
        end

        return true
    end

end)

hook.Add('OnPlayerChat', 'octochat', function(ply, msg, team, dead, prefixText, col1, col2)

    if IsValid(polychat.Core.pnl) then
        chat.AddText(col1, (prefixText or IsValid(ply) and ply:Name() or 'Кто-то говорит') .. ': ', col2, msg)
        return true
    end

end)

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

function chat.AddText(...)

    if not IsValid(polychat.Core.pnl) then polychat.build() end
    polychat.msg(...)

end
chat.AddNonParsedText = chat.AddText

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
            if not pnl.entry:IsVisible() then return end
			polychat.Core.close()
			gui.HideGameUI()

		end
	end

    hst.OnEnter = function(self)
		polychat.send()
        polychat.Core.close()
    end

    polychat.Core.pnl.chat = pnl:Add 'RichText'
    local chat = pnl.chat
    chat:Dock(FILL)
	function chat.PerformLayout(self)
		self:SetFontInternal('polyfont.sm')
	end

    pnl.chat:AppendText('\n')
	pnl.chat:InsertFade(5, 2)
    polychat.Core.close()

end

function polychat.send()

    local pnl = polychat.Core.pnl
    local text = pnl.entry:GetText()
    if string.Trim(text) == '' then
        pnl.entry:SetText('')
        pnl.entry:RequestFocus()
        polychat.Core.close()
        return
    end

	pnl.entry:AddHistory(text)
    pnl.entry:SetText('')
    pnl.entry:RequestFocus()
    polychat.Core.close() 

    netstream.Start( 'chat', text, false )

end

function polychat.msg(...)

    if not IsValid(polychat.Core.pnl) then polychat.build() end

	local pnl = polychat.Core.pnl.chat
	local args = { ... }

	if type(args[1]) ~= 'table' then
		table.insert(args, 1, Color(235,235,235))
	end

	for _, arg in pairs(args) do
		if type(arg) == 'table' then
			pnl:InsertColorChange(arg.r, arg.g, arg.b, 255)
		elseif type(arg) == 'string' then
			pnl:AppendText(arg)
			pnl:InsertFade(5, 1)
		end
	end

	pnl:AppendText('\n')
    chat.PlaySound()

end

function polychat.Core.close()

    local pnl = polychat.Core.pnl
    
	pnl:SetKeyboardInputEnabled(false)
	pnl:SetMouseInputEnabled(false)
	pnl.chat:SetVerticalScrollbarEnabled(false)
	pnl.chat:ResetAllFades(false, true, 0)
    pnl.entry:SetVisible(false)

	hook.Run( "FinishChat" )
    polychat.isOpen = false

end

function polychat.Core.open()

    if not IsValid(polychat.Core.pnl) then polychat.Core.build() end
    
    local pnl = polychat.Core.pnl

	pnl:SetKeyboardInputEnabled(true )
	pnl:SetMouseInputEnabled(true )
    pnl.entry:SetVisible(true)
	pnl.chat:SetVerticalScrollbarEnabled(true)
	pnl.chat:ResetAllFades(true, true, -1)

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
