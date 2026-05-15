extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	$Panel/VBoxContainer.visible = false
	$Panel/HBoxContainer.visible = true
	$Panel/Text.visible = true
	#get_tree().change_scene_to_packed(Global.main_scene_file)

func _on_start_button_mouse_entered() -> void:
	$Panel/VBoxContainer/Start.modulate.a = 170.00/255.00

func _on_start_button_mouse_exited() -> void:
	$Panel/VBoxContainer/Start.modulate.a = 1

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_exit_button_mouse_entered() -> void:
	$Panel/VBoxContainer/Exit.modulate.a = 170.00/255.00

func _on_exit_button_mouse_exited() -> void:
	$Panel/VBoxContainer/Exit.modulate.a = 1

func _on_easy_button_pressed() -> void:
	Global.difficulty = Global.difficulty_enum.EASY
	get_tree().change_scene_to_packed(Global.initial_scene_file)

func _on_medium_button_pressed() -> void:
	Global.difficulty = Global.difficulty_enum.NORMAL
	get_tree().change_scene_to_packed(Global.initial_scene_file)

func _on_hard_button_pressed() -> void:
	Global.difficulty = Global.difficulty_enum.HARD
	get_tree().change_scene_to_packed(Global.initial_scene_file)
