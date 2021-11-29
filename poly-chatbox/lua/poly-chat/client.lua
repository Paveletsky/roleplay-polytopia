hook.Add( 'polylib.init', 'chatinit', function()

	surface.CreateFont( 'ChatBoxFont', {
		font = 'Roboto',
		size = ScreenScale(7.4),
		weight = 350,
		extended = true,
		shadow = true
	})

	surface.CreateFont( 'ChatHudFont', {
		font = 'Roboto',
		size = ScreenScale(7.5),
		weight = 350,
		extended = true,
		shadow = true
	})

	library.createFont( 'lol', 'Calibri', 24 )

	local PANEL = {}
	local Message

    -- chat.Panel:Remove()

	function PANEL:Init()
		self:SetSize( 650, 400 )
		self:SetPos( ScrW() / 1.52, ScrH() / 1.60 )
		self:SetTitle('')
		self:SetSizable( true )
		self:SetScreenLock(true)
		self:ShowCloseButton( false )		
		self:SetMinWidth(500)
		self:SetMinHeight(200)

		if self.CloseButton then
			self.CloseButton.DoClick = function()
				self:Toggle()
			end
		end

		self.TextEntry = self:Add( "DTextEntry" )
		self.TextEntry:Dock(BOTTOM)
		self.TextEntry:DockMargin(1,1,1,1)
		self.TextEntry:SetTall(22)
		self.TextEntry:SetPaintBackground(false)
		self.TextEntry:SetFont( 'lol' )
		self.TextEntry:SetTextColor(Color(255,255,255))
		self.TextEntry:SetHighlightColor(Color(255,120,0))
		self.TextEntry:SetCursorColor(Color(255,120,0))
		self.TextEntry:RequestFocus()
		self.TextEntry:SetHistoryEnabled( true )
		
		function self.TextEntry:OnEnter()

			local text = self:GetText()       
			
			if self:GetText():Trim() == '' then
				chat.Toggle()
				return
			end

			Message = text

			LocalPlayer():ConCommand( 'say '.. text )
			chat.Toggle()
			self:RequestFocus()
			self:AddHistory( text )
			self:SetText("")    

		end	

		self.TextEntry.OnTextChanged = function(t, noMenuRemoval)

			local txt = t:GetText()
			gamemode.Call("ChatTextChanged", txt)
			t:OnValueChange(txt)

			if IsValid(t.Menu) and not noMenuRemoval then
				t.Menu:Remove()
			end

			t:OnChange()
			if t.usingHistory then t.usingHistory = nil return end

			local words = string.Explode(' ', txt)
			if not words and #words == 0 then return end

			local ac = {}
			local fl = words[1]:sub(1,1)
			if #words == 1 then
				if fl == '!' or fl == '~' then
					local rankData = serverguard.ranks:GetRank(serverguard.player:GetRank(LocalPlayer()))
					local commands = serverguard.command:GetTable()
					for unique, data in pairs(commands) do
						if (data.command and (not data.permissions or serverguard.player:HasPermission(LocalPlayer(), data.permissions)))
						and data.command:lower():find(words[1]:sub(2):lower(), 1, true) then
							table.insert(ac, fl .. data.command .. ' ')
						end
					end
				elseif fl == '/' and DarkRP then
					for unique, data in pairs(DarkRP.getChatCommands()) do
						if data.command:lower():find(words[1]:sub(2):lower(), 1, true) then
							table.insert(ac, fl .. data.command .. ' ')
						end
					end
				end
			end

			if #ac > 0 then
				t.Menu = DermaMenu(t)
				for k, v in pairs(ac) do
					t.Menu:AddOption(v, function() t:SetText(v) t:SetCaretPos(utf8.len(v)) t:RequestFocus() end)
				end

				local x, y = t:LocalToScreen(0, 0)
				t.Menu:SetMinimumWidth(t:GetWide())
				t.Menu:Open(x, y - t.Menu:GetTall(), true, t)
				t.Menu:SetMaxHeight(self:GetTall() - 35)
				t.Menu:SetPos(x, y - math.min(t.Menu:GetTall(), self:GetTall() - 35))
			end

		end


		self.Chatbox = self:Add("RichText")
		self.Chatbox:Dock(FILL)
		self.Chatbox:SetVerticalScrollbarEnabled(true)

		function self.Chatbox:PerformLayout()
			self:SetFontInternal( "ChatBoxFont" )
		end
		self:MakePopup()
		self.Chatbox:AppendText('\n')
		self.Chatbox:InsertFade(5, 2)
	end


	function PANEL:Paint( w, h )

		draw.RoundedBox( 10, 0, 0, w, h, Color( 0, 0, 0, 150))
		draw.RoundedBoxEx(4, 0, h / 500, w, 15, Color(250, 160, 0, 190), false, false, true, true)
		draw.RoundedBoxEx(50, 0, h - 30, w, 30, Color(0, 0, 0, 150), false, false, true, true)

	end

	function PANEL:PaintOver(w,h)
		if input.IsKeyDown( KEY_ESCAPE ) and self:IsVisible() then
			gui.HideGameUI()
			chat.Toggle()
		end
	end

	function PANEL:Toggle()
		self:SetVisible(!self:IsVisible())

		if self:IsVisible() then
			self.TextEntry:RequestFocus()	
			hook.Run("StartChat")
		else
			chat.Chathud:ResetAllFades(false, true, 0)
			hook.Run("FinishChat")
		end
	end

	vgui.Register( "polychat.frame", PANEL, "DFrame")

	function chat.Toggle()

		if !IsValid(chat.Panel) then
			chat.Panel = vgui.Create("polychat.frame")
			return
		end
		chat.Panel:Toggle()

	end

	function chat.GetChatBoxPos()
		if IsValid(chat.Panel) then
			local x,y = chat.Panel:GetPos()
			return x,y
		else
			return 10, ScrH() * 0.5
		end
	end

	function chat.GetChatBoxSize()
		if IsValid(chat.Panel) then
			local x,y = chat.Panel:GetSize()
			return x,y
		else
			return 600,300
		end
	end

	hook.Add("HUDPaint", "ChatHud", function()
		if not IsValid(chat.Chathud) then
			chat.Chathud = vgui.Create("RichText")
			function chat.Chathud:PerformLayout()
				self:SetFontInternal( "ChatHudFont" )
			end
		end

		chat.Chathud:SetVerticalScrollbarEnabled(false)

		chat.Chathud:SetPos(chat.GetChatBoxPos())
		chat.Chathud:SetSize(chat.GetChatBoxSize())

		if IsValid(chat.Panel) then chat.Chathud:SetVisible(not chat.Panel:IsVisible()) end
	end)

	hook.Add( 'PlayerBindPress', 'ChatBox', function(ply,bind,pressed)
		if pressed and bind:lower():find("messagemode")  then
			chat.Toggle()
			return true
		end
	end)

	hook.Add( 'HUDShouldDraw', 'HideChatbox', function(name)
		if name == 'CHudChat' then
			return false
		end
	end)


	hook.Add( "ChatText", "serverNotifications", function( index, name, text, type )
		if type == "joinleave" then return false end
		if type == 'none' then
			polychat.polyMsg( 1, text )
		end
	end)

	oldChatAddText = oldChatAddText or chat.AddText

	function chat.InsertColor(col)
		local r,g,b,a = col.r or 255, col.g or 255, col.b or 255, col.a or 255
		if IsValid(chat.Panel) then chat.Panel.Chatbox:InsertColorChange(r, g, b, a) end
		if IsValid(chat.Chathud) then chat.Chathud:InsertColorChange(r, g, b, a) end
	end

	function chat.InsertText(text)
		if IsValid(chat.Panel) then chat.Panel.Chatbox:AppendText(text) end
		if IsValid(chat.Chathud) then chat.Chathud:AppendText(text) chat.Chathud:InsertFade(3, 1) end
	end

	function chat.AddText(...)
		if IsValid(chat.Panel) then
			local args  = {...}
			local entry = chat.Chathud

			-- chat.InsertColor( Color( 200,200,200, 255) )
			-- chat.InsertText(os.date('%H:%M:%S - ', os.time()))

			for k,v in pairs(args) do
				if type(v) == "table" then
					chat.InsertColor(v)
				elseif type(v) == "string" then
					chat.InsertText(v)
				elseif v:IsPlayer() then
					chat.InsertColor( Color( 250, 160, 0 ) ) -- Make their name that color
					chat.InsertText( v:GetNetVar( 'char.name' ) .. ' говорит:' )
				end
			end
			chat.InsertText("\n")
		end

		return oldChatAddText(...)
	end

	hook.Add("OnPlayerChat", "aChatHandle", function(ply, msg, team, dead, prefixText, col1, col2)

		if chat.Panel then
		
			if string.find(string.lower(GAMEMODE.FolderName), "rp") then

				if prefixText and Message != nil then
					prefixText = prefixText .. ": "
					prefixText = string.Replace(prefixText, ply:Nick() .. ": ", " ")
					chat.InsertColor( Color( 200,200,200, 255) )
					chat.InsertText(os.date('%H:%M:%S - ', os.time()))				
					chat.AddText(ply, col1, prefixText, col2, Message)
				else
					chat.AddText(Color(143, 218, 230), Message)
				end

				Message = nil
				return true
			end

		end

	end)

	chat.Toggle()
	chat.Panel:SetVisible(false)

	local icon = Material("poly/roll.png", 'smooth' )
	local function iconfunc()

		draw.Text {
			text = 'Говорите...',
			font = 'lib.namePls',
			pos = { ScrW() / 2 + 875, ScrH() / 15 - 45 },
			xalign = TEXT_ALIGN_RIGHT,
			yalign = TEXT_ALIGN_RIGHT,
			color = Color( 255, 255, 255 ),
		}

		surface.SetDrawColor(255, 255, 255 )
		surface.SetMaterial(icon)
		surface.DrawTexturedRect( ScrW() / 2 + 880, ScrH() / 15 - 50, 60, 50)

	end

	hook.Add("PlayerStartVoice", "ImageOnVoice", function( ply )
		if ply:Team() != TEAM_JUDGE then
			return false
		else		
				hook.Add("HUDPaint", "ImageOnVoice", iconfunc)
			return true
		end
	end)

	hook.Add("PlayerEndVoice", "ImageOnVoice", function()
		hook.Remove("HUDPaint", "ImageOnVoice")
	end)

	hook.Add( "PlayerBindPress", "PlayerBindPressExample", function( ply, bind, pressed )
		if ( string.find( bind, "+voicerecord" ) ) and ply:Team() != TEAM_JUDGE then
			return true
		end
	end )

	netstream.Hook( 'polychat.Emote', function( txt )
		chat.AddText( txt )
	end)

end)