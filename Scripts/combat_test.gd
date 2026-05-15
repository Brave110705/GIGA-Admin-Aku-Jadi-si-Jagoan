extends Node2D

var current_question = {}
var correct_answer = ""
var player_input = ""
var answer_length: int
var last_question = null

var temporary_reveal_state = []

enum mode {answer, think}
var current_mode:mode = mode.answer

var eureka_delay = 0
var eureka_delay_counter = 0

@onready var letter_inputs = $Panel/Control/Letter_inputs
@onready var center = $Control
var letter_states
var enemy

var miniboss_list: EnemyList = load("res://Assets/Enemy_list.tres")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var random = randi_range(1,2)
	match random:
		1:
			$bg1.visible = true
			$bg2.visible = false
		2:
			$bg1.visible = false
			$bg2.visible = true
	Global.spike -= 1
	Global.combat_scene = self
	Global.can_travel = false
	match Global.fight:
		Global.fight_type.Normal:
			enemy = preload("res://Scenes/enemies/enemy_minion.tscn").instantiate()
			Global.enemy_scene = enemy
		Global.fight_type.Miniboss:
			var random_enemy = miniboss_list.enemies.pick_random()
			enemy = random_enemy.instantiate()
			Global.enemy_scene = enemy
		Global.fight_type.Boss:
			enemy = load("res://Scenes/enemies/enemy_boss.tscn").instantiate()
			Global.enemy_scene = enemy
	$Panel/Control/Letter_inputs.visible = true
	$Panel/Letter_think.visible = false
	add_child(enemy)
	load_new_question()
	
	call_deferred("_load_player_ui")

func _load_player_ui():
	var player_ui = load("res://Scenes/player_ui.tscn").instantiate()
	add_child(player_ui)

func damage_enemy():
	enemy.take_damage(Stats.player_damage)
	delay_enemy(Stats.delay_amount)

func delay_enemy(amount):
	enemy.delay_timer(amount)

var counter = 0
func load_new_question():
	if Equipment.has("DVD"):
		counter += 1
		if counter == 3:
			Global.enemy_scene.delay = true
			counter = 0
	
	if Stats.masterchef == true:
		var amount_m = 3 + (2*Global.spike)
		Global.enemy_scene.hp += amount_m
		if Global.enemy_scene.hp > Global.enemy_scene.max_hp:
			Global.enemy_scene.hp = Global.enemy_scene.max_hp
		Stats.player_hp += amount_m
		if Stats.player_hp > Stats.player_max_hp:
			Stats.player_hp = Stats.player_max_hp
		Stats.player_gold -= amount_m
		if Stats.player_gold < 0:
			Stats.dead()
		
	if Stats.playmaker == true:
		if Stats.playmaker_counter >= 1:
			for i in range(Stats.playmaker_counter):
				Stats.base_damage -= 10
				if Global.enemy_scene:
					Global.enemy_scene.damage -= 10
	if Stats.Geisha == true:
		Stats.reset_Chai()
	
	if Stats.Artist_Slump == true:
		Stats.base_damage += Stats.Artist_Slump_counter
		Stats.Artist_Slump_counter = 0
	
	if Stats.Chai == true:
		Stats.reset_Chai()
	
	if Stats.regeneration > 0:
		Stats.player_hp += 3
		if Stats.player_hp > Stats.player_max_hp:
			Stats.player_hp = Stats.player_max_hp
		Stats.regeneration -= 1
	eureka_delay = 0
	eureka_delay_counter = 0
	for i in letter_inputs.get_children():
		i.queue_free()
	
	var new_question = null
	
	while true:
		new_question = Question_Manager.get_question(enemy.enemy_question_type)
		
		if last_question == null:
			break
		
		if new_question["question"] != last_question["question"]:
			break
			
	current_question = new_question
	last_question = new_question
	
	if current_question == null:
		push_error("question kosong")
		return
	
	correct_answer = current_question["answer"].to_lower()
	answer_length = correct_answer.length()
	player_input = ""
	input_count = 0
	
	temporary_reveal_state = []
	for i in range(answer_length):
		temporary_reveal_state.append(0)
	
	$Panel/Question_text.text = current_question["question"]
	
	if current_question.has("hint_state"):
		letter_states = current_question["hint_state"]
	
	for i in answer_length:
		add_letter_empty()
	
	await get_tree().process_frame
	rebuild_from_states()
	
	if Equipment.has("Magic Pen"):
		call_deferred("apply_initial_reveal")

func apply_initial_reveal():
	reveal_random_letter()

var input_count: int
func _input(event):
	if Stats.died == true:
		return
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_BACKSPACE:
			if player_input.length() > 0:
				var index = player_input.length() - 1
				
				player_input = player_input.substr(0, index)
				
				var node = letter_inputs.get_children()[index]
				
				if letter_states[index] == 1 or temporary_reveal_state[index] == 1:
					node.input = correct_answer[index]
					node.dim = true
				else:
					node.input = "none"
					node.dim = true
				
				node.apply_texture()
				input_count -= 1
		
		elif event.keycode == KEY_ENTER:
			check_answer()
		
		elif event.keycode == KEY_SPACE:
			toggle_mode()
			return
		
		elif event.unicode > 0:
			var letter = char(event.unicode).to_lower()
			
			if current_mode == mode.answer:
				handle_answer_input(letter)
			
			elif current_mode == mode.think:
				handle_think_input(letter)

func handle_answer_input(letter):
	input_count += 1
	if input_count > answer_length:
		input_count -= 1
		return
		
	player_input += letter
	add_letter(letter)

func handle_think_input(letter: String):
	
	if Stats.Geisha == true && Items.get_item(0) != Items.Item_id.EMPTY:
		set_announcement("Blocked by Geisha!")
		return
	
	if think_input.length() >= think_string.length():
		return
	
	var expected = think_string[think_input.length()]
	
	if letter != expected:
		fail_think()
		return
	
	think_input += letter
	
	var index = think_input.length() - 1
	var node = $Panel/Letter_think.get_children()[index]
	
	node.dim = false
	node.apply_texture()
	
	if think_input.length() == think_string.length():
		check_think_answer()

func fail_think():
	set_announcement("Mistake!")
	await get_tree().create_timer(0.3).timeout
	think_input = ""
	initiate_type_monkey()

func check_think_answer():
	set_announcement("Think Success!")
	
	if Stats.climax == true:
		Global.enemy_scene.damage += 1
		Global.enemy_scene.delay_timer(-1)
	if Stats.Geisha == true && Stats.Geisha_convert_item_done == false:
		Items.geisha_set()
		Stats.Geisha_convert_item_done = true
	
	if eureka_delay > 0:
		eureka_delay_counter += 1
		
		if eureka_delay_counter >= 2:
			Stats.player_hp -= 1
			eureka_delay_counter = 0
	else:
		Stats.take_damage(1)
	
	if Stats.Artist_Slump == true:
		Stats.Artist_Slump_counter += 1
		Stats.base_damage -= 1
	reveal_random_letter()
	think_input = ""
	initiate_type_monkey()

func reveal_random_letter():
	var hidden_indices = []
	
	for i in range(answer_length):
		
		var permanent = false
		var temporary = false
		
		if i < letter_states.size():
			permanent = letter_states[i] == 1
		
		if i < temporary_reveal_state.size():
			temporary = temporary_reveal_state[i] == 1
		
		if not permanent and not temporary:
			hidden_indices.append(i)
	
	if hidden_indices.is_empty():
		return
	
	var index = hidden_indices.pick_random()
	
	temporary_reveal_state[index] = 1
	
	var node = letter_inputs.get_children()[index]
	node.input = correct_answer[index]
	node.dim = true
	node.apply_texture()

func add_letter(letter):
	var index = player_input.length() - 1
	var children = letter_inputs.get_children()
	
	if index >= children.size():
		return
	
	var node = children[index]
	node.input = letter
	node.dim = false
	node.apply_texture()

func add_letter_empty():
	var letter_input = preload("res://Scenes/letter_input.tscn").instantiate()
	letter_input.input = "none"
	letter_input.dim = true
	$Panel/Control/Letter_inputs.add_child(letter_input)

func check_answer():
	input_count = 0
	
	if not correct_answer.begins_with(player_input):
		set_announcement("Wrong!")
		player_input = ""
		rebuild_from_states()
		return
	
	if player_input == correct_answer:
		on_correct()

func rebuild_from_states():
	var children = letter_inputs.get_children()
	
	for i in range(answer_length):
		var node = children[i]
		
		var permanent = false
		var temporary = false
		
		if i < letter_states.size():
			permanent = letter_states[i] == 1
		
		if i < temporary_reveal_state.size():
			temporary = temporary_reveal_state[i] == 1
		
		if permanent or temporary:
			node.input = correct_answer[i]
		else:
			node.input = "none"
		
		node.dim = true
		node.apply_texture()

func on_correct():
	Stats.total_question_answered += 1

	Global.add_answered(current_question["category"])

	set_announcement("Correct!")

	current_question["answered"] = true 

	damage_enemy()
	await get_tree().create_timer(1).timeout

	for i in letter_inputs.get_children():
		i.queue_free()

	load_new_question()

func set_announcement(announcement: String):
	$Panel/Announcement.modulate.a = 0
	$Panel/Announcement.text = announcement
	var tween = get_tree().create_tween()
	tween.tween_property($Panel/Announcement, "modulate:a", 1, 0.5)
	await get_tree().create_timer(1.01).timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Panel/Announcement, "modulate:a", 0, 0.25)

func toggle_mode():
	if current_mode == mode.answer:
		Global.player_scene.change_pose("Think")
		current_mode = mode.think
		$Panel/RichTextLabel.text = "(Eureka)"
		player_input = ""
		input_count = 0
		rebuild_from_states()
	else:
		Global.player_scene.change_pose("Answer")
		current_mode = mode.answer
		$Panel/RichTextLabel.text = "(Answer)"
	
	update_mode_ui()

var pos_temp
func update_mode_ui():
	match current_mode:
		mode.answer:
			$Panel/Control/Letter_inputs.scale = Vector2(1,1)
			$Panel/Control/Letter_inputs.position = pos_temp
			$Panel/Control/Letter_inputs.visible = true
			$Panel/Letter_think.visible = false
		mode.think:
			pos_temp = $Panel/Control/Letter_inputs.position
			initiate_type_monkey()
			$Panel/Control/Letter_inputs.scale = Vector2(0.5, 0.5)
			$Panel/Control/Letter_inputs.position.y -= 48
			$Panel/Letter_think.visible = true

var think_string = ""
var think_input = ""

func initiate_type_monkey():
	for child in $Panel/Letter_think.get_children():
		child.queue_free()
	
	think_input = ""
	think_string = generate_think_string(Stats.type_monkey_len)
	
	for letter in think_string:
		var letter_monkey = preload("res://Scenes/letter_input.tscn").instantiate()
		letter_monkey.input = letter
		letter_monkey.dim = true
		$Panel/Letter_think.add_child(letter_monkey)

func generate_think_string(length: int) -> String:
	var chars = "abcdefghijklmnopqrstuvwxyz"
	var result = ""
	
	for i in length:
		var rand_index = randi() % chars.length()
		result += chars[rand_index]
	
	return result

func clear():
	var tween1 = get_tree().create_tween()
	tween1.tween_property($Panel/Question_text, "modulate:a", 0, 1)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Panel/Control, "modulate:a", 0, 1)
	
	var tween3 = get_tree().create_tween()
	tween3.tween_property($Panel/Letter_think, "modulate:a", 0, 1)
	
	var tween4 = get_tree().create_tween()
	tween4.tween_property($Panel/RichTextLabel, "modulate:a", 0, 1)
