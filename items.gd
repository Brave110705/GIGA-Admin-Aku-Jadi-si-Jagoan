extends Node

enum Item_id{
	EMPTY,
	REVEAL,
	LIGHTBULB,
	G_MEDICINE,
	SLEEP_CAP,
	TUMPENG,
	STOPWATCH,
	SWORD,
	HEADBAND,
	MBG,
	G_TEA,
	R_TEA,
	CHAI
}

var slots = [
	Item_id.EMPTY,
	Item_id.EMPTY,
	Item_id.EMPTY
]

func geisha_set():
	delete_item(0)
	delete_item(1)
	delete_item(2)
	set_item(Item_id.G_TEA)
	set_item(Item_id.R_TEA)
	set_item(Item_id.CHAI)

func set_item(item_id: int) -> bool: #bwt nambahin item
	for i in range(slots.size()):
		if slots[i] == Item_id.EMPTY:
			slots[i] = item_id
			if Global.player_ui_scene:
				Global.player_ui_scene.update_item_slots()
			return true 
	
	return false

func delete_item(slot_index: int):
	var item = get_item(slot_index)
	if item == Item_id.EMPTY:
		return
	else:
		slots[slot_index] = Item_id.EMPTY
		if Global.player_ui_scene:
			Global.player_ui_scene.update_item_slots()

func get_item(slot_index: int) -> int:
	if slot_index < 0 or slot_index >= slots.size():
		return Item_id.EMPTY
	return slots[slot_index]

var item_textures = {
	Item_id.EMPTY: load("res://Assets/item_empty.png"),
	Item_id.REVEAL: load("res://Assets/item_sprites/MagGlass.png"),
	Item_id.LIGHTBULB: load("res://Assets/item_sprites/LightBulb.png"),
	Item_id.G_MEDICINE: load("res://Assets/item_sprites/Grandma_Soup.png"),
	Item_id.SLEEP_CAP: load("res://Assets/item_sprites/SleepingCap.png"),
	Item_id.TUMPENG: load("res://Assets/item_sprites/BCake.png"),
	Item_id.STOPWATCH: load("res://Assets/item_sprites/StopWatch.png"),
	Item_id.SWORD: load("res://Assets/item_sprites/Sword.png"),
	Item_id.HEADBAND: load("res://Assets/item_sprites/Headband.png"),
	Item_id.MBG: load("res://Assets/item_sprites/MBG.png"),
	Item_id.G_TEA: load("res://Assets/item_sprites/tea_green.png"),
	Item_id.R_TEA: load("res://Assets/item_sprites/tea_red.png"),
	Item_id.CHAI: load("res://Assets/item_sprites/tea_chai.png"),
}

func get_texture(item_id: int) -> Texture2D:
	return item_textures.get(item_id, null)

func use_item(slot_index: int):
	if Stats.playmaker == true:
		Stats.base_damage += 10
		Global.enemy_scene.damage += 10
		Stats.playmaker_counter += 1
	
	if Stats.movie == true:
		Global.enemy_scene.damage += 2
		Global.enemy_scene.delay = true
	
	var item = get_item(slot_index)
	match item:
		Item_id.EMPTY:
			pass
		Item_id.REVEAL:
			if Global.combat_scene:
				delete_item(slot_index)
				Global.combat_scene.reveal_random_letter()
				await get_tree().create_timer(0.2).timeout
				Global.combat_scene.reveal_random_letter()
				await get_tree().create_timer(0.2).timeout
				Global.combat_scene.reveal_random_letter()
		Item_id.LIGHTBULB:
			if Global.combat_scene:
				delete_item(slot_index)
				Global.combat_scene.eureka_delay = 1
		Item_id.G_MEDICINE:
			delete_item(slot_index)
			Stats.player_hp += 10
			if Stats.player_hp > Stats.player_max_hp:
				Stats.player_hp = Stats.player_max_hp
		Item_id.SLEEP_CAP:
			if Global.combat_scene:
				delete_item(slot_index)
				Global.combat_scene.load_new_question()
		Item_id.TUMPENG:
			delete_item(slot_index)
			Stats.player_hp += Stats.player_max_hp*0.5
			if Stats.player_hp > Stats.player_max_hp:
				Stats.player_hp = Stats.player_max_hp
		Item_id.STOPWATCH:
			if Global.combat_scene && Global.enemy_scene:
				delete_item(slot_index)
				Global.enemy_scene.delay_timer(5)
		Item_id.SWORD:
			if Global.combat_scene:
				delete_item(slot_index)
				Stats.base_damage += 5
				await get_tree().create_timer(30).timeout
				Stats.base_damage -= 5
		Item_id.HEADBAND:
			if Global.combat_scene:
				delete_item(slot_index)
				Stats.hint_increase += 3
		Item_id.MBG:
			if Global.combat_scene:
				delete_item(slot_index)
				Stats.regeneration += 5
		Item_id.G_TEA:
			if Global.combat_scene:
				delete_item(slot_index)
				Stats.player_hp += 2
				if Stats.player_hp > Stats.player_max_hp:
					Stats.player_hp = Stats.player_max_hp
		Item_id.R_TEA:
			if Global.combat_scene:
				delete_item(slot_index)
				Stats.player_hp -= 10
		Item_id.CHAI:
			if Global.combat_scene:
				delete_item(slot_index)
				Stats.Chai = true

func get_random_item() -> int:
	var pool = []
	
	for item in Item_id.values():
		if item != Item_id.EMPTY:
			pool.append(item)
	
	return pool.pick_random()

func get_item_empty():
	return Item_id.EMPTY

func get_item_desc(id):
	match id:
		Item_id.REVEAL:
			return "Reveal 3 random letters on combat"
		Item_id.LIGHTBULB:
			return "For the rest of this turn “Eureka” reduces your hp every other time instead"
		Item_id.G_MEDICINE:
			return "Heals 10 HP"
		Item_id.SLEEP_CAP:
			return "Randomizes the question within the same category"
		Item_id.TUMPENG:
			return "Heals 50% HP of Max HP"
		Item_id.STOPWATCH:
			return "Increases Timer By 5 Seconds"
		Item_id.SWORD:
			return "Increases Base Attack by 5 for 30 seconds"
		Item_id.HEADBAND:
			return "Increases the amount of Hint you get by 3 from this battle"
		Item_id.MBG:
			return "Heals 3 HP every turn for 5 turns"
		Item_id.G_TEA:
			return "Heals 2 HP"
		Item_id.R_TEA:
			return "Take 10 Damage"
		Item_id.CHAI:
			return "Increases Attack by 1 For every damage taken during this turn"

func get_item_name(id):
	match id:
		Item_id.REVEAL:
			return "Magnifying Glass"
		Item_id.LIGHTBULB:
			return "Lightbulb"
		Item_id.G_MEDICINE:
			return "Grandma's Medicine"
		Item_id.SLEEP_CAP:
			return "Sleeping Cap"
		Item_id.TUMPENG:
			return "Nasi Tumpeng"
		Item_id.STOPWATCH:
			return "Stopwatch"
		Item_id.SWORD:
			return "Sword"
		Item_id.HEADBAND:
			return "Encouraging Headband"
		Item_id.MBG:
			return "My Bento is Great"
		Item_id.G_TEA:
			return "Green Tea"
		Item_id.R_TEA:
			return "Red Tea"
		Item_id.CHAI:
			return "Chai Tea"
