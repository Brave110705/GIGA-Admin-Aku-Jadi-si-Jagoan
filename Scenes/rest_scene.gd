extends Node2D

var pressed:bool = false

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
	Global.spike += 1
	Global.combat_scene = self
	Global.can_travel = false
	
	var player_ui = load("res://Scenes/player_ui.tscn").instantiate()
	add_child(player_ui)

func _process(delta: float) -> void:
	if pressed:
		$Panel/HBoxContainer/TextureButton/Sprite2D.modulate.a = 0.5
		$Panel/HBoxContainer/TextureButton2/Sprite2D.modulate.a = 0.5

func _on_texture_button_pressed() -> void:
	if pressed:
		return
	pressed = true
	Global.rest()
	var tween = get_tree().create_tween()
	tween.tween_property($Panel/HBoxContainer/TextureButton/Sprite2D, "modulate:a", 0, 1)
	await get_tree().create_timer(0.5).timeout
	progress()

func _on_texture_button_mouse_entered() -> void:
	if pressed:
		return
	$Panel/HBoxContainer/TextureButton/Sprite2D.modulate.a = 0.7

func _on_texture_button_mouse_exited() -> void:
	if pressed:
		return
	$Panel/HBoxContainer/TextureButton/Sprite2D.modulate.a = 1

func progress():
	Global.can_travel = true
	var map_scene = load("res://Scenes/map.tscn").instantiate()
	Global.player_ui_scene.add_child(map_scene)

func _on_texture_button_2_mouse_entered() -> void:
	if pressed:
		return
	$Panel/HBoxContainer/TextureButton2/Sprite2D.modulate.a = 0.7

func _on_texture_button_2_mouse_exited() -> void:
	if pressed:
		return
	$Panel/HBoxContainer/TextureButton2/Sprite2D.modulate.a = 1

func _on_texture_button_2_pressed() -> void:
	if pressed:
		return
	pressed = true
	var choose_hint = load("res://Scenes/choose_hint.tscn").instantiate()
	choose_hint.hint_amount = 3
	choose_hint.question_amount = 5
	add_child(choose_hint)
	var tween = get_tree().create_tween()
	tween.tween_property($Panel/HBoxContainer/TextureButton2/Sprite2D, "modulate:a", 0, 1)
	await get_tree().create_timer(0.5).timeout
	progress()
