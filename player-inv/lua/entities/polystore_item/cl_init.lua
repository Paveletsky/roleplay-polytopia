include 'shared.lua'

surface.CreateFont( "info", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 40,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

function ENT:Draw()
	
	local A = self:GetNetVar 'item'

	self:DrawModel()

	local pos, ang = EyePos(), EyeAngles()
	for i, ply in ipairs(ents.FindInCone(pos, ang:Forward(), 200, 0.99)) do
		
		cam.Start3D2D( Vector( self:GetPos().x, self:GetPos().y, self:GetPos().z+5 ), Angle( 0, LocalPlayer():EyeAngles().y - 90, 50 ), 0.05 )

			local tx = A.name
			local posz = math.sin( CurTime() * 2 ) * 10
			local w, h = #tx * 10

			-- draw.RoundedBox( 0, -w * 7.5, -100, w * 15, 500, color_black )
			-- draw.RoundedBox( 0, -w * 7.5, -100, w * 15, 50, Color(250, 160, 0) )

			surface.SetDrawColor( color_black )
			surface.DrawRect( -w * 0.5, -10, w, 60 )

			surface.SetDrawColor( 250, 160, 0 )
			surface.DrawRect( -w * 0.5, -10, w, 6 )

			draw.DrawText( tx, "info", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

		cam.End3D2D()

	end

end