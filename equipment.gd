extends Node

var count:int = 0

var equipment = {
	"Magic Pen" = false,
	"Japanese Fan" = false,
	"Football" = false,
	"Rice Cooker" = false,
	"DVD" = false
}

func get_equip_desc(id: String):
	match id:
		"Magic Pen" : return "Start Every Turn with 1 Hint for the ongoing question"
		"Japanese Fan" : return ": Everytime Player is taking damage, apply the same amount to the enemy"
		"Football" : return "Increases Attack By total number of miniboss fought"
		"Rice Cooker" : return "Heals HP by the total amount of question answered throughout the battle"
		"DVD" : return "Every Third Turn, Delays Attack By 1 Turn"

func add_equipment(id: String):
	equipment[id] = true
	count += 1
	if Global.player_ui_scene:
		Global.player_ui_scene.refresh_equipment_ui()

func has(id: String) -> bool:
	return equipment.has(id) and equipment[id]

func remove_equipment(id: String):
	equipment.erase(id)
	count -= 1

func get_random_unowned() -> String:
	var pool = []
	
	for id in equipment.keys():
		if not equipment[id]:
			pool.append(id)
	
	if pool.is_empty():
		return "equip_dmg"
	
	return pool.pick_random()
