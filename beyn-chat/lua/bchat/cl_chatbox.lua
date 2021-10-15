local function font()

	surface.CreateFont( 'ChatBoxFont', {

		font = 'Roboto',

		size = ScreenScale(7),

		weight = 300,

		extended = true,

		shadow = true

	})



	surface.CreateFont( 'ChatHudFont', {

		font = 'Roboto',

		size = ScreenScale(7.5),

		weight = 300,

		extended = true,

		shadow = true

	})

end


for i=1, 2 do font() end



do

	local PANEL = {}



	function PANEL:Init()



		self:SetSize(500,600)

		self:SetPos( ScrW() / 2 + 450, ScrH() * 0.44)

		//self:DockPadding(0,18,0,0)

		self:SetTitle(GetHostName())

		self:SetSizable( false )

		self:SetScreenLock(true)



		self:SetMinWidth(500)

		self:SetMinHeight(300)



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

		self.TextEntry:SetTextColor(Color(255,255,255))

		self.TextEntry:SetHighlightColor(Color(255,120,0))

		self.TextEntry:SetCursorColor(Color(255,120,0))

		self.TextEntry:RequestFocus()



		function self.TextEntry:PaintOver(w,h)

			if self:GetText():Trim() == "" then

				draw.SimpleText( "Сообщение...", "DermaDefault", 5, h/2, color_white, 0, 1 )

			end

		end



		function self.TextEntry:OnEnter()

			RunConsoleCommand( "say",  self:GetValue() )

			-- net.Start("clib.addText")

			-- 	net.WriteString(self:GetValue())

			-- net.SendToServer()

			chat.Toggle()

		end



		function self.TextEntry:OnValueChanged()

			hook.Run( "ChatTextChanged", self:GetValue() )

		end



		self.Chatbox = self:Add("RichText")

		self.Chatbox:Dock(FILL)



		function self.Chatbox:PerformLayout()

			self:SetFontInternal( "ChatBoxFont" )

			self:SetFGColor( Color( 255, 255, 255 ) )

		end





		self:MakePopup()

	end


	function PANEL:Paint( w, h )
		
		draw.RoundedBox( 2, 0, 0, w, h, Color( 0, 0, 0, 150))

		draw.RoundedBox( 2, 0, -575, w, h, Color( 230, 138, 0, 150))

		draw.RoundedBox( 5, 0, h - 29, w, h, Color( 0, 0, 0, 200))


	end


	function PANEL:PaintOver(w,h)

		if input.IsKeyDown( KEY_ESCAPE ) and self:IsVisible() then

			chat.Toggle()

			gui.HideGameUI()

		end

	end



	function PANEL:Toggle()

		self:SetVisible(!self:IsVisible())



		if self:IsVisible() then

			self.TextEntry:SetText("")

			self.TextEntry:RequestFocus()



			hook.Run("StartChat")

		else

			hook.Run("FinishChat")

		end

	end



	vgui.Register( "AlexChatBox", PANEL, "DFrame")

end



function chat.Toggle()

	if !IsValid(chat.Panel) then

		chat.Panel = vgui.Create("AlexChatBox")

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

		chat.Chathud:SetVerticalScrollbarEnabled(false)

		function chat.Chathud:PerformLayout()

			self:SetFontInternal( "ChatHudFont" )

			self:SetFGColor( Color( 255, 255, 255 ) )

		end

	end



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

	if type == "joinleave" or type == "none" then

		chat.InsertColor(Color(255,255,255,255))

		chat.InsertText( text .. "\n" )

	end

end )



oldChatAddText = oldChatAddText or chat.AddText



function chat.InsertColor(col)

	local r,g,b,a = col.r or 255, col.g or 255, col.b or 255, col.a or 255

	if IsValid(chat.Panel) then chat.Panel.Chatbox:InsertColorChange(r, g, b, a) end

	if IsValid(chat.Chathud) then chat.Chathud:InsertColorChange(r, g, b, a) end

end



function chat.InsertText(text)

	if IsValid(chat.Panel) then chat.Panel.Chatbox:AppendText(text) end

	if IsValid(chat.Chathud) then chat.Chathud:AppendText(text) chat.Chathud:InsertFade(10, 1) chat.Chathud:GotoTextEnd() end

end



function chat.AddText(...)

	if IsValid(chat.Panel) then

		local args  = {...}

		local entry = chat.Panel.Chatbox



		for k,v in pairs(args) do

			if type(v) == "table" then

				chat.InsertColor(v)

			elseif type(v) == "string" then

				chat.InsertText(v)

			elseif v:IsPlayer() then

				local col = team.GetColor(v:GetColor()) -- Get the player's team color

				chat.InsertColor( ColorAlpha(col, 255) ) -- Make their name that color

				chat.InsertText( v:GetNetVar( 'name' ) )

			end

		end



		chat.InsertText("\n")

	end



	return oldChatAddText(...)

end



net.Receive("clib.sendMsg", function()

	local act = net.ReadInt(8)

	if act == 1 then

		local ply, text, sayTeam = net.ReadEntity(), net.ReadString(), net.ReadBool()

		hook.Run("OnPlayerChat", ply, text, sayTeam, not ply:Alive())

	end

end)

timer.Simple(1, function()

	chat.Toggle()

	chat.Panel:SetVisible(false)

end)

local function receive()

	local data = net.ReadTable()

	if not istable(data) then return end

	chat.AddText(unpack(data))

end

net.Receive('clib.addText', receive)

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

-- tesa