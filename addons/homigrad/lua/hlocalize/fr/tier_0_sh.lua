-- "addons\\homigrad\\lua\\hlocalize\\fr\\tier_0_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
LOCALIZE.fr = LOCALIZE.fr or {}
local l = LOCALIZE.fr

l.spectate_wath = "Observation du joueur"
l.spectate_wathface = "Observation du visage du joueur"
l.spectate_fly = "Vol libre"

l.spectate_waths = "Observé : %s"
l.spectate_health = "Santé : %s"

--

l.nobody_win = "Egalité"

l.unknown = "Inconnu"
l.spectate = "Observateur"

l.construct = "Construire"

l.rtv_force = "Jusqu'au vote forcé %s rounds."

--

l.round_end = "Le tour est terminé"
l.round_winner = "Gagnant"
l.need_2_players = "Besoin d'au moins 2 joueurs"

l.hud_level_active = "Mode actuel : %s"
l.hud_level_next = "Mode suivant : %s"

l.chat_level_active = "Mode actuel : %s"
l.chat_level_next = "Mode suivant : %s"

l.stop_game = "Jeu arrêté"

l.level_start = "Mode de démarrage : %s"
l.special_forces_run = "Les forces spéciales arrivent."
l.police_run = "La police arrive."

l.police_come = "Jusqu'à l'arrivée de la police : %s"

l.you = "Vous %s"
l.you_team = "Votre équipe %s"

l.door = "Porte"
l.button = "Bouton"

l.pulse_0 = "Pas de pouls."
l.pulse_1 = "Pouls fort"
l.pulse_2 = "Pouls normal"
l.pulse_3 = "Pouls faible"
l.pulse_4 = "Pouls à peine perceptible"

updateL(GetConVar("gmod_language"):GetString())