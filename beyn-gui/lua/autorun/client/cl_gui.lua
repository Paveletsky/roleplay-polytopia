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

local offsetA, offsetB = Vector(15,0,0), Angle()
local function drawPlrs()
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

				local name = ply:GetNetVar('name') or 'Загружается...'
				local desc = ply:GetNetVar( 'desc' )

				draw.RoundedBox( 2, p.x - 150, p.y + 5, 300, 5, Color(0, 0, 0, 200))
				draw.RoundedBox( 2, p.x - 150, p.y + 10, 300, 1, Color(250, 160, 0, 200))

				draw.WordBox(2, p.x, p.y - 60, name, 'lib.namePls', Color( 0, 0, 0, 220), Color( 255, 255, 255 ), TEXT_ALIGN_CENTER)
				draw.WordBox(2, p.x, p.y - 21, 'Внешность: ' .. desc, 'lib.descPls', Color( 0, 0, 0, 220), Color( 255, 255, 255, 150 ), TEXT_ALIGN_CENTER)		
			
			end
		end
	end
end

local function drawGui()

	local x, y = ScrW() / 300, ScrH() / 125
	local ply = LocalPlayer()
    local top, left = ScrH() - 840, 40	

	draw.RoundedBox( 2, x, y, 245, 85, Color( 0, 0, 0, 240 ))
	draw.RoundedBox( 2, x, y, 245, 10, Color( 250, 160, 0, 180))

	local healthStatus
	local hungerStatus = ply:getDarkRPVar( 'rpname' )

	if ply:Health() <= 100 then healthStatus = 'Здоровье стабильно' end 
	if ply:Health() <= 70 then healthStatus = 'Ухуджение здоровья' end
	if ply:Health() <= 30 and ply:Health() > 0 then healthStatus = 'На грани' end
	if ply:Health() < 1 then healthStatus = 'Вы мертвы...' end

	-- if ply:getDarkRPVar( 'Energy' ) <= 100 then hungerStatus = 'Полностью сыт' end
	-- if ply:getDarkRPVar( 'Energy' ) <= 70 then hungerStatus = 'Умеренно голоден' end
	-- if ply:getDarkRPVar( 'Energy' ) <= 20 then hungerStatus = 'Пора подкрепиться' end

	surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
		surface.SetMaterial( Material( 'beyn/pulse.png' ) ) -- Use our cached material
	surface.DrawTexturedRect(x + 193, y + 18, 45, 25 ) -- Actually draw the rectangle

	surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
		surface.SetMaterial( Material( 'beyn/tin_can.png' ) ) -- Use our cached material
	surface.DrawTexturedRect( x + 193, y + 46, 45, 35 ) -- Actually draw the rectangle

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
		pos = { x + 5, y + 50 },
		xalign = TEXT_ALIGN_LEFT,
		yalign = TEXT_ALIGN_LEFT,
		color = Color( 255, 255, 255 ),
	} 

	if ply:IsAdmin() then

		draw.Text {
			font = "Trebuchet24",
			text = "Ранг администратора",
			pos = { left * 4.5, top * 4.3 },
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
			color = Color(255, 255, 255, (math.sin(CurTime()) + 0.1) * 155)
		} draw.Text {
			font = "Trebuchet24",
			text = "Не забывайте следить за сервером!",
			pos = { left * 4.5, top * 4.41 },
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
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
	CHudAmmo = true,
	CHudSecondaryAmmo = true,
}

hook.Add('HUDShouldDraw', 'library-hud', function(name)
	if hideHUDElements[name] then return false end
end)