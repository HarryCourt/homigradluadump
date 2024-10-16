-- "addons\\homigrad\\lua\\hlocalize\\ru\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LOCALIZE.ru = LOCALIZE.ru or {}
local l = LOCALIZE.ru

l.spectate_wath = "Наблюдение за игроками."
l.spectate_wathface = "Наблюдение от лица игрока."
l.spectate_fly = "Свободный полёт."

l.spectate_waths = "Наблюдают: %s"
l.spectate_health = "Здоровье: %s"

--

l.nobody_win = "Ничья."

l.unknown = "Неизвестно"
l.spectate = "Наблюдатель"

l.construct = "Construct"

l.rtv_force = "До принудительного голосования %s раундов."

--

l.round_end = "Раунд закончен"
l.round_winner = "Победили"
l.need_2_players = "Нужно минимум 2 игрока"

l.hud_level_active = "Текущий режим: %s"
l.hud_level_next = "Следущий режим: %s"

l.chat_level_active = "Текущий режим: %s"
l.chat_level_next = "Следущий режим: %s"

l.stop_game = "Игра остановлена"

l.level_start = "Запускаем режим: %s"
l.special_forces_run = "Спецназ приезжает."
l.police_run = "Полиция приезжает."

l.police_come = "До прибытие полиции : %s"

l.you = "Вы %s"
l.you_team = "Ваша команда %s"

l.door = "Дверь"
l.button = "Кнопка"

l.pulse_0 = "Нет пульса"
l.pulse_1 = "Сильный пульс"
l.pulse_2 = "Нормальный пульс"
l.pulse_3 = "Слабый пульс"
l.pulse_4 = "Еле ощущаемый пульс"

updateL(GetConVar("gmod_language"):GetString())