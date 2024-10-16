-- "addons\\homigrad\\lua\\hlocalize\\en\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LOCALIZE.en = LOCALIZE.en or {}
local l = LOCALIZE.en

l.spectate_wath = "Наблюдение за игроками."
l.spectate_wathface = "Наблюдение от лица игрока."
l.spectate_fly = "Свободный полёт."

l.spectate_waths = "Наблюдают: %s"
l.spectate_health = "Здоровье: %s"

--

l.nobody_win = "Nobody win."

l.unknown = "Unknown"
l.spectate = "Spectate"

l.construct = "Construct"

l.rtv_force = "Before forced voting %s rounds."

--

l.round_end = "Round's over"
l.round_winner = "Winner"
l.need_2_players = "We need at least 2 players"

l.hud_level_active = "Current game: %s"
l.hud_level_next = "Next game: %s"

l.chat_level_active = "Current режим: %s"
l.chat_level_next = "Next game: %s"

l.stop_game = "Game is stoped!"

l.level_start = "Starting the level: %s"
l.special_forces_run = "SWAT is coming."
l.police_run = "The police are coming."

l.police_come = "Until the police arrive. : %s"

l.you = "You %s"
l.you_team = "You team %s"

l.door = "Door"
l.button = "Button"

l.pulse_0 = "None pulse"
l.pulse_1 = "Strong pulse"
l.pulse_2 = "Medium pulse"
l.pulse_3 = "Low pulse"
l.pulse_4 = "Very low pulse"

updateL(GetConVar("gmod_language"):GetString())
