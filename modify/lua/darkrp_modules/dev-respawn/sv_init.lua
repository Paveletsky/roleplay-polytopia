-- CFGspPos = {
--     '964, 623, -144',
--     '880, 253, -144',
--     '801, -215, -144',
--     '872, -631, -144',
-- }

-- local function randSpawn()

--     local pls = parseCoords( CFGspPos[math.random( #CFGspPos )] )
--     local position = Vector( tonumber(pls[1]), tonumber(pls[2]), tonumber(pls[3]) )
--     return position
-- -- :SetPos( Vector( tonumber(pls[1]), tonumber(pls[2]), tonumber(pls[3]) ) )

-- end

-- local deathpos

-- local DeathRagdoll= {}

-- function DeathRagdoll:new(ply,dpos)

--     local drag = ents.Create('prop_ragdoll') 
    
--     local obj= {}
--         obj.drag = ents.Create('prop_ragdoll')
--         obj.model = ply:GetModel()
--         obj.pos = Vector(ply:GetAimVector().x,ply:GetAimVector().y,0)
--         obj.angles = ply:GetAttachment(1).Ang

    
--     function obj:init()
--         self.drag:SetPos(dpos+self.pos)
--         self.drag:SetModel(self.model)
--         self.drag:SetCollisionGroup(5)
--         self.drag:SetAngles(self.angles)
--         self.drag:Spawn()
--         timer.Simple(5, function () self.drag:Remove() end)
--     end

    
--     setmetatable(obj, self)
--     self.__index = self; return obj
-- end

-- hook.Add("PostPlayerDeath", "ServerDeathRagdoll", 
--     function(ply)
--         deathpos = ply:GetPos()
--         print(iskilled)
--         local rag = DeathRagdoll:new(ply, deathpos)
--         rag:init()
--         ply:Spawn()   
--         ply:SetPos(randSpawn())
--     end)  

-- print( randSpawn() )