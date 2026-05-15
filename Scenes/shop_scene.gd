extends Node2D


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
	Global.can_travel = true
	
	var player_ui = load("res://Scenes/player_ui.tscn").instantiate()
	add_child(player_ui)
	
	for i in 3:
		var shop_item = load("res://Scenes/shop_item.tscn").instantiate()
		$Panel/CenterContainer/VBoxContainer/Column1.add_child(shop_item)
	
	for i in 3:
		var shop_item = load("res://Scenes/shop_item.tscn").instantiate()
		$Panel/CenterContainer/VBoxContainer/Column2.add_child(shop_item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	Global.can_travel = true
	var map_scene = load("res://Scenes/map.tscn").instantiate()
	Global.player_ui_scene.add_child(map_scene)

func _on_texture_button_mouse_entered() -> void:
	$Panel/TextureButton.modulate.a = 0.7

func _on_texture_button_mouse_exited() -> void:
	$Panel/TextureButton.modulate.a = 1
