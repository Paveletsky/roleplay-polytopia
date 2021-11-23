    local lastBody

    local function MyCalcView( ply, pos, angles, fov )
        local body = ply

            local hat = body:LookupBone("ValveBiped.Bip01_Head1") or 6
            body:ManipulateBoneScale(hat, Vector(0, 0, 0))

            local view = {}
            hatpos, hatang = body:GetBonePosition(hat)
            hatpos = hatpos or ply:GetShootPos()
            if body:Crouching() then
                view.origin = hatpos + body:GetForward() * 3
            else
                view.origin = hatpos + angles:Up() * 5
            end
            viewpos = view.origin
            --view.angles = realang
            --view.zfar = 100
            return view

        
    end
    
    -- hook.Add( 'CalcView', 'MyCalcView', MyCalcView )
    hook.Remove( 'CalcView' , 'MyCalcView' )