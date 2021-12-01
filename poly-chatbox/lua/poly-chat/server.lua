local function who_can_hear( performer_pos, range )

    local who_can_hear_table = {}
    local range = range or 100
    for k, v in ipairs(player.GetAll()) do
        local plpos = v:GetPos()
        local diffx, diffy, diffz
        diffx = math.abs(performer_pos.x - plpos.x)
        diffy = math.abs(performer_pos.y - plpos.y)
        diffz = math.abs(performer_pos.z - plpos.z)
        if diffx <= range and diffy <= range and diffz <= range then who_can_hear_table[#who_can_hear_table + 1] = v end
    end
    return who_can_hear_table
end

netstream.Hook( 'polychat.sendMessage', function( ply, text, team )
	
	for k, v in ipairs( who_can_hear(ply:GetPos(), 900 )) do
		hook.Run( "PlayerSay", v, text, team )
	end

end)

-- Entity(2):GiveItem( 'poly_custom_tester' )
