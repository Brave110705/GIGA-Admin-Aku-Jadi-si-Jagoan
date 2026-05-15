extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	var menu_screen = load("res://Scenes/start_menu.tscn")
	get_tree().change_scene_to_packed(menu_screen)
	Global.can_travel = true
	Stats.player_hp = Stats.player_max_hp
	Stats.player_gold = 20
	self.queue_free()
