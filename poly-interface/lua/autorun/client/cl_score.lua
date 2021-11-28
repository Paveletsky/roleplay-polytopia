if IsValid( LIBScoreboard ) then LIBScoreboard:Remove() end



surface.CreateFont( "LIB.FontLarge", {

	font = "Calibri",

	size = 48,

	weight = 1000,

	extended = true,

})



surface.CreateFont( "LIB.FontSmall", {

	font = "Calibri",

	size = 22,

	weight = 300,

	extended = true,

})



surface.CreateFont( "LIB.FontSmall_Blur", {

	font = "Calibri",

	size = 22,

	weight = 300,

	extended = true,

	blursize = 3,

})



ALXLogo = Material("gmchan/alx_logo_crown.png", "smooth")



local PANEL = {}

AccessorFunc( PANEL, "Player", "Player" )



function PANEL:Init()

	self:SetTall(30)

	self:SetCursor("hand")



	self.Avatar = self:Add("AvatarImage")

	self.Avatar:SetPos(155, 3)

	self.Avatar:SetSize(24, 24)



	self.Profile = self.Avatar:Add("DButton")

	self.Profile:SetText("")

	self.Profile:Dock(FILL)

	self.Profile.DoClick = function()

		local ply = self:GetPlayer()

		if IsValid(ply) then

			ply:ShowProfile()

		else

			gui.OpenURL( "https://steamcommunity.com/profiles/" .. (self.SteamID or "") )

		end

	end



	self.IconBar = self:Add( "EditablePanel" )

	self.IconBar:SetPos(35, 0)

	self.IconBar:SetTall(30)

	self.Profile.Paint = nil

end



local clr_ok = Color( 0, 200, 0 )

local clr_black = Color( 0, 0, 0, 140 )

local ping_t = 10



function PANEL:Paint(w,h)

	draw.RoundedBox( 0, 150, 0, w, h, Color( 0, 0, 0) )

	draw.RoundedBox( 0, 150, 29, w, h, Color( 230, 138, 0, 200 ) )



	draw.SimpleText( self.PlayerName or "", "LIB.FontSmall", 200 + self.IconBar:GetWide(), h/2, color_white, 0, 1 )

	draw.SimpleText( self.PlayerTeam or "", "LIB.FontSmall", w / 1.88, h / 2, color_white, 1, 1 )



	local ping   = self.PlayerPing or 0

	local ping_x = w - 30



	for i=1, 4 do

		local num  = (i-1)

		local tall = math.ceil( (i/4 * ping_t) + 1 )

		local clr  = ping < 25 + (4 - i) * 25 and clr_ok or clr_black



		draw.RoundedBox( 0, ping_x + num * 4, h/2 + ping_t/2 - tall, 3, tall, clr )

	end



	surface.SetDrawColor(clr_black)

	surface.DrawOutlinedRect( 150, 0, w, h)

end



function PANEL:OnMousePressed(key)

	local meh = LocalPlayer()

	local m = DermaMenu(self)

	local name, sid = self.PlayerName, self.SteamID

	local sid10 = self.SteamID10

	RegisterDermaMenuForClose(m)

	m:AddOption("Открыть профиль", function()

		self.Profile.DoClick()

	end):SetImage("icon16/user.png")

	m:AddOption("Скопировать SteamID", function()

		SetClipboardText(sid10 or "")

	end):SetImage("icon16/user_edit.png")

	m:AddOption("Скопировать Имя", function()

		SetClipboardText(name or "")

	end):SetImage("icon16/user_edit.png")

	m:AddOption("Отправить сообщение", function()

		Derma_StringRequest("Отправить сообщение", "Введите текст", "", function(s)

			RunConsoleCommand("darkrp", "pm", name, s)

		end)

	end):SetImage("icon16/user_comment.png")

	if meh:isCP() then

		m:AddOption("Уволить", function()

			Derma_StringRequest("Уволить", "Введите причину", table.Random{"плохо сосет", "превышение полномочий", "брак", "агрессия", "переведен в ECHO", "код синяя синица"}, function(s)

				RunConsoleCommand("darkrp", "demote", sid10, s)

			end)

		end):SetImage("icon16/user_delete.png")

	end

	if meh:IsAdmin() then 

		m:AddSpacer()

		m:AddOption( 'Телепортироваться к игроку', function() 
			RunConsoleCommand( "sg", "goto", self.SteamID10 )
		end)

	end

	m:Open()

end





local function PaintIcon( self, w, h )

	-- surface.SetMaterial( self.Icon )

	surface.SetDrawColor( color_white )

	surface.DrawTexturedRect( w/2 - 8, h/2 - 8, 16, 16 )

end



function PANEL:SetPlayer( ply )

	self.Player = ply

	self.Avatar:SetPlayer( self.Player, 64 )



	self.IconBar:Clear()



	local x = 0

	for k,v in pairs( LIB_Icons or {} ) do

		local res, mat, text = v( ply )



		if res then

			local meme = self.IconBar:Add( "EditablePanel" )

			meme:SetSize(16,30)

			meme:SetPos(x, 0)

			meme:SetTooltip( text )

			meme:SetCursor( "hand" )

			meme.Icon = mat

			meme.Paint = PaintIcon



			x = x + meme:GetWide()

		end

	end



	self.IconBar:SetWide( #self.IconBar:GetChildren() * 16 )

end



function PANEL:Think()

	local ply = self:GetPlayer()



	if IsValid( ply ) then

		local plteam = ply:Team()


		self.PlayerName  = ply:GetName()

		self.PlayerTeam  = team.GetName(plteam)

		self.PlayerColor = team.GetColor(plteam)

		self.SteamID	 = ply:SteamID64()

		self.SteamID10	 = ply:SteamID()

	end



	self:SetWide( self:GetParent():GetWide() - 150 )

end

vgui.Register( "LIB.ScoreboardPlayer", PANEL, "EditablePanel" )



local Scoreboard = {}



function Scoreboard:Init()

	self:MakePopup()

	self:SetKeyboardInputEnabled(false)

	self:Dock(FILL)

	self:Center()



	self.Top = self:Add("EditablePanel")

	self.Top:Dock(TOP)

	self.Top:DockMargin(0,50,0,5)

	self.Top:SetTall(200)



	self.Scroll = self:Add("DScrollPanel")

	self.Scroll:Dock(FILL)

	self.Scroll:DockMargin( 10, 0, 10, 10 )



	function self.Top:Paint(w,h)

        Derma_DrawBackgroundBlur( self, 0 )  

		surface.SetFont( "LIB.FontLarge" )


		local pic = h * 0.6

		local x = w / 2


		surface.SetMaterial( Material( 'poly/logo.png', 'smooth' ) )

		surface.SetDrawColor( 255,255,255, 255 )

		surface.DrawTexturedRect(x - pic - 70, 40, pic + 200, pic + 20 )


	end

end


function Scoreboard:UpdatePlayers()

	self.Scroll:Clear()



	local players = player.GetAll()

	table.sort( players, function( f, l )

		return f:Team() > l:Team()

	end )



	local y = 0



	for _, ply in ipairs( players ) do

		local panel = self.Scroll:Add("LIB.ScoreboardPlayer")

		panel:SetPos(0, y)

		panel:SetPlayer( ply )



		y = y + panel:GetTall() + 15

	end

end



vgui.Register( "LIB.Scoreboard", Scoreboard, "EditablePanel" )



hook.Add( "ScoreboardShow", "LIB.Scoreboard", function()

	if !IsValid( LIBScoreboard ) then

		LIBScoreboard = vgui.Create( "LIB.Scoreboard" )

	end



	LIBScoreboard:SetVisible(true)

	LIBScoreboard:UpdatePlayers()



	return true

end )



hook.Add( "ScoreboardHide", "LIB.Scoreboard", function()

	if IsValid( LIBScoreboard ) then

		LIBScoreboard:SetVisible(false)

		CloseDermaMenus()

	end



	return true

end )



hook.Remove( "ScoreboardShow", "CustomScoreboard" )

hook.Remove( "ScoreboardHide", "CustomScoreboard" )


