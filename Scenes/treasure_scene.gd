extends Node2D

signal loot_selected

var opened:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.combat_scene = self
	Global.can_travel = false
	
	var player_ui = load("res://Scenes/player_ui.tscn").instantiate()
	add_child(player_ui)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_texture_button_pressed() -> void:
	show_equip_selection()
	opened = true
	$Panel/RichTextLabel.text = "Chest (opened)"

func show_equip_selection():
	if opened == true:
		return
	
	var center = $Panel/Center
	var radius = 180
	var count = 3
	
	for child in center.get_children():
		child.queue_free()
	
	for i in count:
		var equip_loot = load("res://Scenes/chest_loot_scene.tscn").instantiate()
		equip_loot.equip_id = Equipment.get_random_unowned()
		equip_loot.connect("loot_selected", Callable(self, "_on_loot_selected"))
		center.add_child(equip_loot)
		
		var angle = (TAU / count) * i - PI / 2
		
		var offset = Vector2(cos(angle), sin(angle)) * radius
		
		equip_loot.position = center.size / 2 + offset
	
	var tween = get_tree().create_tween()
	center.modulate.a = 0
	tween.tween_property(center, "modulate:a", 1, 0.5)

func _on_loot_selected():
	clear()

func clear():
	$Panel/Center.queue_free()
	progress()

func progress():
	Global.can_travel = true
	var map_scene = load("res://Scenes/map.tscn").instantiate()
	Global.player_ui_scene.add_child(map_scene)
