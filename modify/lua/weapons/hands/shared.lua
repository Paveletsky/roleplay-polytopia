if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName			= "Руки"
SWEP.Author				= ""
SWEP.Purpose				= ""
SWEP.Spawnable				= true
SWEP.Category				= "Бейнбург - Дополнения"
SWEP.Slot				= 1
SWEP.SlotPos         	= 0

SWEP.ViewModel			= "models/weapons/c_medkit.mdl"
SWEP.WorldModel			= ""

SWEP.AnimPrefix	 		= "rpg"

SWEP.Passive			= 'normal'
SWEP.AnimDrag			= 'magic'
SWEP.Active				= "pistol"
SWEP.Weight				= 'duel'

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.AttackState			= false
SWEP.AttackCD 				= CurTime()
SWEP.HitDistance = 50

SWEP.DrawCrosshair = false

SWEP.BlockRange = Vector(50, 50, 50)
SWEP.BlockDist = false

local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )

function SWEP:Initialize()
	self:SetHoldType( "normal" )

	self.Time = 0
	self.Range = 150
	self.Lock = true
end

function SWEP:Deploy()
    if CLIENT or not IsValid(self:GetOwner()) then return true end
    self:GetOwner():DrawWorldModel(false)
    return true
end

function SWEP:Holster()
    return true
end

local phys_pushscale = GetConVar( "phys_pushscale" )

function SWEP:DealDamage()
	if self.AttackCD > CurTime() then return end

	self:EmitSound( SwingSound )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())

	self.Owner:LagCompensation( true )

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( HitSound )
	end

	local hit = false
	local scale = phys_pushscale:GetFloat()

	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		if tr.Entity:Health() < 20 then return end

		local dmginfo = DamageInfo()

		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( math.random( 3, 10 ) )

		if ( anim == "fists_left" ) then
			dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 * scale + self.Owner:GetForward() * 9998 * scale ) -- Yes we need those specific numbers
		end

		SuppressHostEvents( NULL ) -- Let the breakable gibs spawn in multiplayer on client
		tr.Entity:TakeDamageInfo( dmginfo )
		SuppressHostEvents( self.Owner )

		hit = true

	end

	if ( IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 80 * phys:GetMass() * scale, tr.HitPos )
		end
	end


	if self:Health() <= 100 then self.AttackCD = CurTime() + 1 end
	if self:Health() <= 60 then self.AttackCD = CurTime() + 1.9 end
	if self:Health() <= 30 then self.AttackCD = CurTime() + 3 end

	self.Owner:LagCompensation( false )


end



local function lookingAtLockable(ply, ent)
    local eyepos = ply:EyePos()
    return IsValid(ent)             and
        ent:isKeysOwnable()         and
        not ent:getKeysNonOwnable() and
        (
            ent:isDoor()    and eyepos:Distance(ent:GetPos()) < 65
            or
            ent:IsVehicle() and eyepos:Distance(ent:NearestPoint(eyepos)) < 100
        )
end

local function lockUnlockAnimation(ply, snd)
    ply:EmitSound("npc/metropolice/gear" .. math.floor(math.Rand(1,7)) .. ".wav")

    local RP = RecipientFilter()
    RP:AddAllPlayers()

    umsg.Start("anim_keys", RP)
        umsg.Entity(ply)
        umsg.String("usekeys")
    umsg.End()

    ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
end

local function doKnock(ply, sound)
    ply:EmitSound(sound, 100, math.random(90, 110))
    umsg.Start("anim_keys")
        umsg.Entity(ply)
        umsg.String("knocking")
	umsg.End()
	--self:SetHoldType( self.Passive )

    ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)

end

function SWEP:Think()
	if self.Drag and (not self.Owner:KeyDown(IN_ATTACK) or not IsValid(self.Drag.Entity)) then
		self.Drag = nil
	end

	if self:GetOwner():KeyPressed( IN_ATTACK ) and self.Owner:KeyDown(IN_ATTACK2) then
		if self.AttackState then
			self:DealDamage()
		end
	end
    
    if self.AttackState then
		if !self.Owner:KeyDown(IN_ATTACK2) then
            self.AttackState = false
            self:SetHoldType(self.Passive)
        end
    end

	if self.Hand and self.Owner:KeyReleased(IN_ATTACK) then
		self.Hand = nil
	end

	if self.AttackState and self.Owner:KeyReleased(IN_ATTACK2) then
		self.AttackState = false
		self:SetHoldType(self.Passive)
	elseif !self.AttackState and self.Owner:KeyDown(IN_ATTACK2) then
		timer.Simple(0.00001, function()
			self.AttackState = true
			self:SetHoldType( "fist" )
		end )
	end

	if self.AttackState then return end

	local HitEnt = self:GetOwner():GetEyeTrace().Entity

	if self:GetOwner():KeyDown( IN_ATTACK ) then
		if self.Drag then
			self:SetHoldType( self.AnimDrag )
		elseif !HitEnt:isDoor() then
			if self.Hand == nil and !HitEnt:IsValid() then
				self.Hand = true
			end
			self:SetHoldType( self.Active )
		end
	end

	if self:GetOwner():KeyReleased( IN_ATTACK ) then
		self:SetHoldType( self.Passive )
	end

	if self:GetOwner():KeyDown( IN_ATTACK ) and self.lock == true then
		local HitEnt = self:GetOwner():GetEyeTrace().Entity

		if HitEnt:isDoor() and !self.Drag and !self.Hand then

			local trace = self:GetOwner():GetEyeTrace()

			if not lookingAtLockable(self:GetOwner(), trace.Entity) then return end

			if self.LimitDown and self.LimitDown > CurTime() then return end


			if CLIENT then return end

			self.LimitDown = CurTime() + 0.4
			if !self.Owner:GetNetVar('goverment') then
				if self:GetOwner():canKeysLock(trace.Entity) then
					trace.Entity:keysLock() -- Lock the door immediately so it won't annoy people
					lockUnlockAnimation(self:GetOwner(), self.Sound)
				elseif trace.Entity:IsVehicle() then
					DarkRP.notify(self:GetOwner(), 1, 3, DarkRP.getPhrase("do_not_own_ent"))
				elseif self.Hand != true and trace.Entity:isDoor() then
					doKnock(self:GetOwner(), "physics/wood/wood_crate_impact_hard2.wav")
				end
			elseif self.Owner:GetNetVar('goverment') then
				if trace.Entity:getDoorData().groupOwn == ' ' then
					trace.Entity:keysLock() -- Lock the door immediately so it won't annoy people
					lockUnlockAnimation(self:GetOwner(), self.Sound)
				else
					if self:GetOwner():canKeysLock(trace.Entity) then
						trace.Entity:keysLock() -- Lock the door immediately so it won't annoy people
						lockUnlockAnimation(self:GetOwner(), self.Sound)
					elseif trace.Entity:IsVehicle() then
						DarkRP.notify(self:GetOwner(), 1, 3, DarkRP.getPhrase("do_not_own_ent"))
					elseif self.Hand != true and trace.Entity:isDoor() then
						doKnock(self:GetOwner(), "physics/wood/wood_crate_impact_hard2.wav")
					end
				end
			end

		end
		self.lock = false
	end

	if self:GetOwner():KeyReleased( IN_ATTACK ) then
		self.lock = true
	end

	if self:GetOwner():KeyPressed( IN_ATTACK ) then
		if tostring(HitEnt:GetPhysicsObject()) != '[NULL PhysObject]' and HitEnt:GetClass() == 'magnet' then
			local pos = HitEnt:GetPos()
			HitEnt:GetPhysicsObject():EnableMotion(true)
			HitEnt:SetParent(nil)
			HitEnt:SetPos(pos)
		end
	end

end

if SERVER then
	local muscle
end

function SWEP:PrimaryAttack()
	self.BlockDist = false
	local HitEnt = self:GetOwner():GetEyeTrace().Entity

	if self.AttackState then return end

	if HitEnt:isDoor() and !self.Drag and !self.Hand then

	else

		local Pos = self.Owner:GetShootPos()
		local Aim = self.Owner:GetAimVector()

		local Tr = util.TraceLine{
			start = Pos,
			endpos = Pos +Aim *self.Range,
			filter = player.GetAll(),
		}

		local HitEnt = Tr.Entity

		if self.Drag then
			HitEnt = self.Drag.Entity
		else
			if not IsValid( HitEnt ) or HitEnt:GetMoveType() != MOVETYPE_VPHYSICS
				or HitEnt:GetNWBool( "NoDrag", false ) or
				HitEnt.BlockDrag or
				IsValid( HitEnt:GetParent() ) or HitEnt:GetClass() == 'gmod_sent_vehicle_fphysics_wheel' then
				return
			end
			if not self.Drag and self.Hand == nil then
				self.Drag = {
					OffPos = HitEnt:WorldToLocal(Tr.HitPos),
					Entity = HitEnt,
					Fraction = Tr.Fraction,
				}
			end
		end

		local Phys = HitEnt:GetPhysicsObject()

		if IsValid( Phys ) and self.BlockDist == false and self.Drag then
			if Phys:GetMass() > 55 then
				muscle = 10 * 200 / Phys:GetMass()
			else
				muscle = 10 * 500 / Phys:GetMass()
			end
			local Pos2 = Pos +Aim *self.Range *self.Drag.Fraction -- позиция пропа
			local OffPos = HitEnt:LocalToWorld( self.Drag.OffPos )	-- позиция переноса
			local Dif = Pos2 -OffPos
			local Nom = (Dif:GetNormal() *math.min(1, Dif:Length() /555) *500 -Phys:GetVelocity()) * muscle
			if Pos2:Distance(OffPos) > 80	 then
				self.Drag = nil
					Entity(1):ChatPrint( 'Упал' )
				self:SetHoldType( 'passive' )
			end
			if CLIENT or not IsValid( HitEnt ) then return end

			Phys:ApplyForceOffset( Nom, OffPos )
			Phys:AddAngleVelocity( -Phys:GetAngleVelocity() / 4 )

		end

	end

end



function SWEP:SecondaryAttack()

	local trace = self:GetOwner():GetEyeTrace()
	local HitEnt = self:GetOwner():GetEyeTrace().Entity

	if self.AttackState then return end

		if not lookingAtLockable(self:GetOwner(), trace.Entity) then return end

		self:SetNextSecondaryFire(CurTime() + 0.4)

end

if CLIENT then

	local x, y = ScrW() /2, ScrH() /2
	local MainCol = Color( 255, 255, 255 )
	local Col = Color( 255, 255, 255, 255 )

	function SWEP:DrawHUD()
		
		if IsValid( self.Owner:GetVehicle() ) then return end
		local Pos = self.Owner:GetShootPos()
		local Aim = self.Owner:GetAimVector()

		local Tr = util.TraceLine{
			start = Pos,
			endpos = Pos +Aim *self.Range,
			filter = player.GetAll(),
		}

		local HitEnt = Tr.Entity
		if IsValid( HitEnt ) and HitEnt:GetMoveType() == MOVETYPE_VPHYSICS and
			not self.rDag and
			not HitEnt:IsVehicle() and
			not IsValid( HitEnt:GetParent() ) and
			not HitEnt:GetNWBool( "NoDrag", false ) then

			self.Time = math.min( 1, self.Time +2 *FrameTime() )
		else
			self.Time = math.max( 0, self.Time -2 *FrameTime() )
		end

		if self.Time > 0 then
			Col.a = MainCol.a *self.Time
		end

		local ply = LocalPlayer()
		local td = {}

		td.start = ply:GetShootPos()
		td.endpos = td.start + ply:GetAimVector() * 9999999999
		td.filter = ply

		local hitpos = self.Owner:GetEyeTrace().HitPos

		tr = util.TraceLine(td)
		local data2D = tr.HitPos:ToScreen()
		draw.RoundedBox( 15, data2D.x,  data2D.y, 5, 5, Color(231, 231, 231) )
		
	end
end

function SWEP:PreDrawViewModel( vm, pl, wep )
	return true
end
