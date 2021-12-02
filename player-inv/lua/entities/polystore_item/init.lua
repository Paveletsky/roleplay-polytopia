AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'
include 'shared.lua'

function ENT:Initialize()

    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
    self:SetCollisionGroup(15)
    self:DropToFloor()

end

function ENT:Register( data )

    self:SetNetVar( 'item', data )

    local A = self:GetNetVar 'item'
    self:SetModel( A.model or 'models/props_lab/box01a.mdl' )

end

function ENT:Use( c, a )
   
    local A = self:GetNetVar 'item'
    local data = c:CurrentCharInventory()
    local fraq = 0

    local class = A.class

    for k, v in pairs( data ) do
        local data_inv = polyinv.List[v].weight
        fraq = fraq + data_inv
    end

    if c:GetItemCount( class ) >= polyinv.List[class].max then 
        polychat.sendNotify( c, 1, 'У вас максимальное кол-во "' .. polyinv.List[class].name .. '"' ) 
    
    return elseif fraq > 1.01 or fraq + polyinv.List[class].weight > 1.01 then
        polychat.sendNotify( c, 1, 'Нет места.' )
    
    return else
        c:GiveItem( A.class )
        self:Remove()
    end
    
end
-- PrintTable(Entity(1):CurrentCharInventory())