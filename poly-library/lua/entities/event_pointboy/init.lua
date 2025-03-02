AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
 
	self:SetModel( "models/props_interiors/corkboardverticle01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
        local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Sleep()
		end
end

function ENT:Use( a, c, useType )

		netstream.Start( c, 'entlib.createJobMenu', a, c )

	self:SetUseType(SIMPLE_USE)

end
 
function ENT:Think()
    -- We don't need to think, we are just a prop after all!
end