polychat.Core = polychat.Core or {}

hook.Add('HUDShouldDraw', 'clearDefaultChat', function(name)

    if name == 'CHudChat' then return false end

end)

function polychat.Core.build()

    if polychat.Core.pnl then polychat.Core.pnl:Remove() end
    polychat.Core.pnl = vgui.Create 'DFrame'

    local pnl = polychat.Core.pnl
    pnl:SetSize( 650, 400 )
    pnl:AlignRight( 5 )
    pnl:AlignBottom( 5 )
    pnl:SetTitle( '' )
    pnl:SetSizable( true )
    pnl.Paint = function( self, w, h )

		draw.RoundedBox( 10, 0, 0, w, h, Color( 0, 0, 0, 150))
		draw.RoundedBoxEx(4, 0, h / 500, w, 15, Color(250, 160, 0, 190), false, false, true, true)
		draw.RoundedBoxEx(50, 0, h - 30, w, 30, Color(0, 0, 0, 150), false, false, true, true)  

    end

end

polychat.Core.build()

-- netstream.Hook( 'polychat.Emote', function( txt )
-- 	chat.AddText( txt )
-- end)
