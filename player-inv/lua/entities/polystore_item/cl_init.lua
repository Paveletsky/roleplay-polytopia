include 'shared.lua'

surface.CreateFont( "info", {
	font = "Calibri", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 20,
	weight = 400,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false ,
	strikeout = false,
	symbol = false,
	rotary = false ,
	shadow = false,
	additive = false,
	outline = true  ,
})

function ENT:Draw()
	
	local A = self:GetNetVar 'item'

	self:DrawModel()

    local dist = EyePos():DistToSqr(self:GetPos())
    if dist < 15000 then
        local baseAl = (15000 - dist) / 8000

		local pos = self:GetPos():ToScreen()
        local x, y = math.floor(pos.x), math.floor(pos.y)

        cam.Start2D()
            draw.RoundedBox(9, x - 35, y - 45, 70, 70, Color(22, 22, 22, baseAl * 230))
            draw.RoundedBox(9, x - 35, y - 45, 70, 2.5, Color(250, 160, 0, baseAl * 230))
            surface.SetDrawColor(255,255,255, baseAl * 255)
            surface.SetMaterial(Material( A.logo or 'poly/button.png', 'smooth' ) )
            surface.DrawTexturedRect(x - 30, y - 40, 60, 60)

			local tAl = math.Clamp(350 * baseAl - Vector(x,y,0):DistToSqr(Vector(ScrW()/2, ScrH()/2, 0)) / 100, 0, 255)
			draw.Text {
                text = A.name,
                font = 'info',
                pos = {x, y + 30},
                color = Color(255,255,255, 190),
                xalign = TEXT_ALIGN_CENTER,
                yalign = TEXT_ALIGN_TOP,
            }
		
        cam.End2D()
    end

	-- local pos, ang = EyePos(), EyeAngles()
	-- for i, ply in ipairs(ents.FindInCone(pos, ang:Forward(), 200, 0.99)) do
		
	-- 	cam.Start3D2D( Vector( self:GetPos().x, self:GetPos().y, self:GetPos().z+5 ), Angle( 0, LocalPlayer():EyeAngles().y - 90, 50 ), 0.05 )

	-- 		local tx = A.name
	-- 		local posz = math.sin( CurTime() * 2 ) * 10
	-- 		local w, h = #tx * 10

	-- 		-- draw.RoundedBox( 0, -w * 7.5, -100, w * 15, 500, color_black )
	-- 		-- draw.RoundedBox( 0, -w * 7.5, -100, w * 15, 50, Color(250, 160, 0) )

	-- 		surface.SetDrawColor( color_black )
	-- 		surface.DrawRect( -w * 0.5, -10, w, 60 )

	-- 		surface.SetDrawColor( 250, 160, 0 )
	-- 		surface.DrawRect( -w * 0.5, -10, w, 6 )

	-- 		draw.DrawText( tx, "info", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

	-- 	cam.End3D2D()

	-- end

end