function library.createFont( id, font, size )
	if not id then print( 'Не указан ID шрифта.' ) return end
    surface.CreateFont( id, {
        font = font or 'Calibri',
        size = size or 18,
    })
	return id
end

surface.CreateFont('lib.namePls', {
	font = 'Calibri',
	extended = true,
	size = 35,
	weight = 0,
	antialias = true,
})

surface.CreateFont('lib.descPls', {
	font = 'Trebuchet24',
	extended = true,
	size = 21,
	weight = 0,
	antialias = true,
})

netstream.Hook( 'polygui.drawAction', function( ent, text, time )

	local ply = ent

	hook.Add('HUDPaint', 'library-hudAction', function()

		local dist = EyePos():DistToSqr( ply:GetPos() )
		if dist < 35000 then
			local baseAl = (35000 - 1) / 8000

			local head = ply:LookupBone('ValveBiped.Bip01_Head1')
			local headPos = ply:GetBonePosition(head)

			local pos = headPos:ToScreen()
			local x, y = math.floor(pos.x), math.floor(pos.y)

			cam.Start2D()
				local tAl = math.Clamp(350 * baseAl - Vector(x,y,0):DistToSqr(Vector(ScrW()/2, ScrH()/2, 0)) / 100, 0, 150)
				draw.Text {
					text = text or 'Не ясно что он делает...',
					font = 'info',
					pos = { x, y + 50 },
					color = Color( 255,255,255, tAl ),
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_TOP,
				}
			
			cam.End2D()
		end

	end)

	timer.Simple( time, function()
		hook.Remove( 'HUDPaint', 'library-hudAction' )
	end)

end)

local offsetA, offsetB = Vector(15,0,0), Angle()
function drawPlrs()
  local pos, ang = EyePos(), EyeAngles()
	for i, ply in ipairs(ents.FindInCone(pos, ang:Forward(), 200, 0.9)) do
		if ply:IsPlayer() and ply:Alive() and ply ~= LocalPlayer() then

			local pos, ang
			local head = ply:LookupBone('ValveBiped.Bip01_Head1')

			if head then
				pos, ang = ply:GetBonePosition(head)
			else
				pos, ang = ply:GetShootPos(), ply:EyeAngles()
			end

			local tr = util.TraceLine({
				start = pos,
				endpos = pos,
				filter = ply,
			})

			if not tr.Hit then

				pos, ang = LocalToWorld(offsetA, offsetB, pos, ang)
				local p = pos:ToScreen()
				p.x, p.y = math.floor(p.x), math.floor(p.y)

				-- local name = ply:GetNetVar('session_name') or 'Загружается...'
				-- local desc = ply:GetNetVar( 'session_desc' )

				-- draw.RoundedBox( 2, p.x - 150, p.y + 5, 300, 5, Color(0, 0, 0, 200))
				-- draw.RoundedBox( 2, p.x - 150, p.y + 10, 300, 1, Color(250, 160, 0, 200))

				-- draw.WordBox(2, p.x, p.y - 60, name, 'lib.namePls', Color( 0, 0, 0, 220), Color( 255, 255, 255 ), TEXT_ALIGN_CENTER)
				-- draw.WordBox(2, p.x, p.y - 21, 'Внешность: ' .. desc, 'lib.descPls', Color( 0, 0, 0, 220), Color( 255, 255, 255, 150 ), TEXT_ALIGN_CENTER)		
			
			end
		end
	end
end

function drawGui()

	local x, y = ScrW() / 300, ScrH() / 125
	local ply = LocalPlayer()
    local top, left = ScrH() - 840, 40	

	draw.RoundedBox( 2, x, y, 245, 100, Color( 0, 0, 0, 240 ))
	draw.RoundedBox( 2, x, y, 245, 5, Color( 250, 160, 0, 180))

	-- draw.RoundedBox( 2, x, y, 245, 85, Color( 0, 0, 0, 240 ))
	-- draw.RoundedBox( 2, x, y, 245, 10, Color( 250, 160, 0, 180))

	local healthStatus
	local hungerStatus

	if ply:Health() <= 100 then healthStatus = 'Здоровье стабильно' end 
	if ply:Health() <= 70 then healthStatus = 'Ухуджение здоровья' end
	if ply:Health() <= 30 and ply:Health() > 0 then healthStatus = 'На грани' end
	if ply:Health() < 1 then healthStatus = 'Вы мертвы...' end

	if ply:getDarkRPVar( 'Energy' ) <= 100 then hungerStatus = 'Полностью сыт' end
	if ply:getDarkRPVar( 'Energy' ) <= 70 then hungerStatus = 'Умеренно голоден' end
	if ply:getDarkRPVar( 'Energy' ) <= 20 then hungerStatus = 'Пора подкрепиться' end

	surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color

		surface.SetMaterial( Material( 'poly/heart-monitor.png', 'noclamp smooth' ) ) -- Use our cached material
	surface.DrawTexturedRect(x + 193, y + 5, 50, 50 ) -- Actually draw the rectangle

		surface.SetMaterial( Material( 'poly/dining-room.png', 'noclamp smooth' ) ) -- Use our cached material
	surface.DrawTexturedRect( x + 193, y + 50, 50, 50 ) -- Actually draw the rectangle

	draw.Text {
		text = healthStatus,
		font = 'lib.notify',
		pos = { x + 5, y + 15 },
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_LEFT,
		color = Color( 255, 255, 255 ),
	} draw.Text {
		text = hungerStatus,
		font = 'lib.notify',
		pos = { x + 5, y + 55 },
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_LEFT,
		color = Color( 255, 255, 255 ),
	}

	if ply:IsAdmin() then
		draw.Text {
			font = "Trebuchet24",
			text = "Ранг администратора",
			pos = { ScrW() / 60 - 15, ScrH() / 1.068 },
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_LEFT,
			color = Color(255, 255, 255, (math.sin(CurTime()) + 0.1) * 155)
		} draw.Text {
			font = "Trebuchet24",
			text = "Не забывайте следить за сервером!",
			pos = { ScrW() / 60 - 15, ScrH() / 1.04 },
			xalign = TEXT_ALIGN_LEFT,
			yalign = TEXT_ALIGN_LEFT,
			color = Color(255, 255, 255, (math.sin(CurTime()) + 0.1) * 155)
		}
	end

end

hook.Add( "HUDDrawTargetID", "HidePlayerInfo", function()

	return false -- or whatever you want

end )

hook.Add('HUDPaint', 'library-hud', function()
	drawPlrs()
	drawGui()
end)

local hideHUDElements = {
	-- CHudCrosshair = true,
	CHudHealth = true,
	CHudBattery = true,
	DarkRP_Hungermod = true,
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
}

hook.Add('HUDShouldDraw', 'library-hud', function(name)
	if hideHUDElements[name] then return false end
end)

