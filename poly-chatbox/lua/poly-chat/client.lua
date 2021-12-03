polychat.Core = polychat.Core or {}

----------------------------------------------------------------------------
-- core --------------------------------------------------------------------
----------------------------------------------------------------------------

hook.Add('Think', 'polychat.build', function()
    hook.Remove('Think', 'polychat.build')

    timer.Simple( 0.2, function() polychat.Core.font() end)
    polychat.Core.build()

end)

----------------------------------------------------------------------------

function polychat.Core.font()

    surface.CreateFont('polyfont.sm', {
        font = 'Roboto Regular',
        extended = true,
        size = 20,
        weight = 300,
        shadow = true,
    })

end

function chat.GetChatBoxPos()

    if not IsValid(polychat.Core.pnl) then 
        polychat.Core.build()
    end

    if IsValid(polychat.Core.pnl) then
        local x, y = polychat.Core.pnl:GetPos()
        return x, y
    else
        return 10, ScrH() * 0.5
    end
    
end

function chat.GetChatBoxSize()

    if not IsValid(polychat.Core.pnl) then 
        polychat.Core.build()
    end

    if IsValid(polychat.Core.pnl) then
        local x, y = polychat.Core.pnl:GetSize()
        return x, y
    else
        return 650, 400
    end

end

function chat.AddText(...)

    if not IsValid(polychat.Core.pnl) then 
        polychat.Core.build()
    end    
    
    polychat.msg(...)

end
chat.AddNonParsedText = chat.AddText

--------------------------------------------------------------------------
--  hooks   --------------------------------------------------------------
--------------------------------------------------------------------------

hook.Add('HUDShouldDraw', 'clearDefaultChat', function(name)

    if name == 'CHudChat' then return false end

end)

hook.Add('PlayerBindPress', 'polychat', function(ply, bind, press)

    if bind == 'messagemode' or bind == 'messagemode2' then
        if not IsValid(polychat.Core.pnl) then 
            polychat.Core.build()
        end

        polychat.Core.open()
        return true
    end

end)

hook.Add('OnPlayerChat', 'polychat', function(ply, msg, team, dead, prefixText, col1, col2)

    if IsValid(polychat.Core.pnl) then
        chat.AddText(Color( 250, 160, 0 ), ( IsValid(ply) and ply:GetNetVar( 'char.name' ) or 'Неизвестный' ) .. ' говорит: ', Color( 255, 255, 255 ), msg)
        return true
    end

end)

--------------------------------------------------------------------------
--  design  --------------------------------------------------------------
--------------------------------------------------------------------------

function polychat.chatCommands()

    if polychat.cmds then polychat.cmds:Remove() end
    polychat.cmds = vgui.Create 'DFrame'

    local pnl = polychat.cmds
    pnl:SetTitle( '' )
    pnl:SetDraggable(false)
    pnl:SetSize( 400, 200 )
    pnl:ShowCloseButton( false )
    pnl:SetPos( (ScrW() / 1.52) / 1.47, (ScrH() / 1.5955) )
    pnl.Paint = function( self, w, h )

		draw.RoundedBox( 10, 0, 0, w, h, Color( 0, 0, 0, 200))
		draw.RoundedBoxEx(4, 0, h / 500, w, 15, Color(250, 160, 0, 250), false, false, true, true)

    end

    polychat.cmds.lst = pnl:Add 'DPanel' 
    local list = polychat.cmds.lst
    list:Dock( LEFT )
    list:SetSize( 110 )
    list:SetAlpha( 190 )
    list:DockMargin( 0, -5, 0, 0 )
    
    local scroll = list:Add 'DScrollPanel'
    scroll:Dock(FILL)   

    local dsc = pnl:Add 'RichText'
    dsc:Dock(FILL)

    local function openImage(url)
        if image then image:Remove() end
        image = vgui.Create 'HTML'
        image:SetHTML( "<img src="..url.." width=350 height=860 alt=lorem>" )        
        image:SetSize( 500, 900 )
        image:MoveTo( ScrW()/60, pnl:GetPos()/9, 0.3, 0, -1 )   
    end

    local imBut = dsc:Add 'DButton'
    imBut:SetText( 'Показать' ) 
    imBut:Dock(BOTTOM)     
    imBut:SetVisible(false)
    imBut:SetTall(15)
    imBut:DockMargin( 190, 0, 0, 0 )
    
    local bt = list:Add 'DListView'
    bt:Dock(FILL)
    bt:SetMultiSelect( false )    
    bt:AddColumn( 'LL' )
    bt:SetDataHeight( 25 )
    bt:DockMargin( 0, -16, 0, 0)   
    for k, but in pairs( DarkRP.getChatCommands() ) do
        if but.author == 'poly' then
            local lv = bt:AddLine( '/'..but.command )
            lv.Columns[1]:SetFont( 'polyfont.sm' )
            function lv:OnSelect( line, isSel )
                dsc:SetText( '' )
                dsc:AppendText( but.description )     
                if but.command == 'wme' then imBut:SetVisible(true) 
                        imBut.DoClick = function()
                            if not IsValid(image) then openImage( 'https://i.imgur.com/fe5dbqu.gif' ) else image:Remove() end                    
                        end
                    else imBut:SetVisible(false) if IsValid(image) then image:Remove() end
                end           
            end                   
        end
                
    end

	function dsc.PerformLayout(self)
		dsc:SetFontInternal('polyfont.sm')
        dsc:SetFGColor( Color( 255, 255 , 255 ) )
	end

end

function polychat.Core.build()
    
    if polychat.Core.pnl then polychat.Core.pnl:Remove() end
    polychat.Core.font()
    
    polychat.Core.pnl = vgui.Create 'DFrame'

    local pnl = polychat.Core.pnl
    pnl.alpha = 0
    pnl:SetSize( 650, 400 )
    pnl:SetPos( ScrW() / 1.52, ScrH() / 1.6 )
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
    hst.keyDown = false
	hst.Think = function(self)
        if gui.IsGameUIVisible() then
            polychat.Core.close()
			gui.HideGameUI()
        end

        if input.IsKeyDown(KEY_TAB) and self:HasFocus() then
            self:RequestFocus()        

        elseif input.IsKeyDown( KEY_F2 ) then
            if self.keyDown then return end
			self.keyDown = true             
            if not IsValid(polychat.cmds) then polychat.chatCommands() end
            polychat.cmds:SetVisible( not polychat.cmds:IsVisible() )

        elseif input.IsKeyDown(KEY_ESCAPE) then
            if not pnl.entry:IsVisible() then return end
			polychat.Core.close()
			gui.HideGameUI()

        else
            self.keyDown = false 
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

    netstream.Start( 'polychat.sendMessage', text, false )

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
    
    if polychat.cmds then polychat.cmds:SetVisible( false ) end
    if image then image:Remove() end

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