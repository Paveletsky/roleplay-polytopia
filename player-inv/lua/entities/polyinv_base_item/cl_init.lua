include 'shared.lua'

if dataIt == nil then return end

function ENT:Initialize()

	dataIt = self:GetNetVar 'item'

end

function ENT:Draw()

	self:DrawModel()
	
	cam.Start3D2D( self:GetPos(), self:GetAngles(), 1 )

		draw.SimpleText( dataIt.name, "DermaDefault", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	cam.End3D2D()

end