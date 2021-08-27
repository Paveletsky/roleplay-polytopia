local GAMEMODE = GAMEMODE or GM


TEAM_DEF = DarkRP.createJob("Житель", {
    color = Color(20, 150, 20, 255),
    model = {
        "models/player/Group01/Female_01.mdl",
        "models/player/breen.mdl",
    },
    description = [[ ]],
    weapons = { 'weapon_medkit' },
    command = "beyn_citizen",
    max = 0,
    salary = GAMEMODE.Config.normalsalary,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens",
})


DarkRP.addHitmanTeam( TEAM_MOB )
GAMEMODE.DefaultTeam = TEAM_DEF

GAMEMODE.CivilProtection = {
    [TEAM_POLICE] = true,
    [TEAM_CHIEF] = true,
    [TEAM_MAYOR] = true,
}
