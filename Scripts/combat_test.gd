extends Node2D

var current_question = {}
var correct_answer = ""
var player_input = ""

@onready var letter_inputs = $Panel/Letter_inputs
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_new_question()

func load_new_question():
	current_question = Question_Manager.get_question()
	
	if current_question == null:
		push_error("question kosong")
		return
	
	correct_answer = current_question["answer"].to_lower()
	player_input = ""
	
	$Panel/Question_text.text = current_question["question"]

func _input(event):
	if event is InputEventKey and event.pressed:
		
		if event.keycode == KEY_BACKSPACE:
			if player_input.length() > 0:
				player_input = player_input.substr(0, player_input.length() - 1)
		
		elif event.unicode > 0:
			var letter = char(event.unicode).to_lower()
			
			player_input += letter
			add_letter(letter)  # ← THIS is the important line
		
		check_answer()

func add_letter(letter):
	var letter_input = preload("res://Scenes/letter_input.tscn").instantiate()
	letter_input.input = letter
	$Panel/Letter_inputs.add_child(letter_input)

func check_answer():
	# Wrong input → reset
	if not correct_answer.begins_with(player_input):
		set_announcement("Wrong!")
		player_input = ""
		for i in letter_inputs.get_children():
			i.queue_free()
		return
	
	# Correct answer
	if player_input == correct_answer:
		on_correct()

func on_correct():
	set_announcement("Correct!")
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
