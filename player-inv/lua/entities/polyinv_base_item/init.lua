AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include( 'shared.lua' )

function ENT:Initialize()

    self:SetModel( 'models/props_lab/box01a.mdl' )

    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
    self:DropToFloor()

end

function ENT:Register( data )

    self:SetModel( data.model or 'models/props_lab/box01a.mdl' )
    self:SetNetVar( 'item', data )

end

