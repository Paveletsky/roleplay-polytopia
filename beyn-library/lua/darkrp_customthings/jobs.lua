local GAMEMODE = GAMEMODE or GM

local civModels = {

    'models/daemon_alyx/players/male_citizen_01.mdl',
    'models/daemon_alyx/players/male_citizen_02.mdl',
    'models/daemon_alyx/players/male_citizen_03.mdl',
    'models/daemon_alyx/players/male_citizen_04.mdl',
    'models/daemon_alyx/players/male_citizen_05.mdl',
    'models/daemon_alyx/players/male_citizen_06.mdl',
    'models/daemon_alyx/players/male_citizen_07.mdl',
    'models/daemon_alyx/players/male_citizen_08.mdl',
    'models/daemon_alyx/players/male_citizen_09.mdl',
    'models/daemon_alyx/players/male_citizen_10.mdl',
    'models/daemon_alyx/players/male_citizen_11.mdl',
    'models/daemon_alyx/players/male_citizen_12.mdl',
    'models/daemon_alyx/players/male_citizen_13.mdl',
    'models/dizcordum/citizens/playermodels/pm_male_06.mdl',


}

TEAM_DEF = DarkRP.createJob("Житель", {
    color = Color(20, 150, 20, 255),
    model = civModels,
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

TEAM_JUDGE = DarkRP.createJob( "Судья", {
    color = Color(20, 150, 20, 255),
    model = civModels,
    description = [[ ]],
    weapons = { 'weapon_medkit' },
    command = "beyn_judge",
    max = 0,
    salary = 0,
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
