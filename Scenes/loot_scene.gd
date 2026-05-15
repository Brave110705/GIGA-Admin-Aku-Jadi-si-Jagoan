extends Control
var progress_ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0
	await get_tree().create_timer(1).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.25)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if progress_ready == true:
		return
	if $Panel/CenterContainer/VBoxContainer.get_child_count() == 1:
		progress_ready = true
		progress()

func add_loot_equipment(equip_id: String):
	var equip_loot = load("res://Scenes/equip_loot.tscn").instantiate()
	equip_loot.equip_id = equip_id
	$Panel/CenterContainer/VBoxContainer.add_child(equip_loot)

func add_loot_gold(amount:int):
	var gold_loot = load("res://Scenes/gold_loot.tscn").instantiate()
	gold_loot.amount = amount
	$Panel/CenterContainer/VBoxContainer.add_child(gold_loot)

func add_loot_hint(hint_amount:int, question_amount:int):
	var hint_loot = load("res://Scenes/hint_loot.tscn").instantiate()
	hint_loot.hint_amount = hint_amount
	hint_loot.question_amount = question_amount
	$Panel/CenterContainer/VBoxContainer.add_child(hint_loot)

func progress():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5)
	await get_tree().create_timer(0.5).timeout
	Global.can_travel = true
	var map_scene = load("res://Scenes/map.tscn").instantiate()
	Global.player_ui_scene.add_child(map_scene)
