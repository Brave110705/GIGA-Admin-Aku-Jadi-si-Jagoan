extends Control
enum type { Combat, Treasure, Rest, Boss, Shop, Miniboss }
@export var map_type: type
var pressable: bool = false
var row: int = -1
var col: int = -1

var useless:bool = false

signal node_selected(row, col)

func _ready() -> void:
	match map_type:
		type.Combat:
			$RichTextLabel.text = ""
			$TextureRect.texture = load("res://Assets/icon_combat.png")
			if pressable == false:
				$TextureRect.texture = load("res://Assets/icon_combat_no_outline.png")
		type.Treasure:
			$RichTextLabel.text = "Treasure"
		type.Rest:
			$RichTextLabel.text = ""
			$TextureRect.texture = load("res://Assets/icon_rest.png")
			if pressable == false:
				$TextureRect.texture = load("res://Assets/icon_rest_no_outline.png")
		type.Boss:
			$RichTextLabel.text = ""
			$TextureRect.texture = load("res://Assets/icon_miniboss.png")
			if pressable == false:
				$TextureRect.texture = load("res://Assets/icon_miniboss_no_outline.png")
		type.Shop:
			$RichTextLabel.text = ""
			$TextureRect.texture = load("res://Assets/icon_shop.png")
			if pressable == false:
				$TextureRect.texture = load("res://Assets/icon_shop_no_outline.png")
		type.Miniboss:
			$RichTextLabel.text = ""
			$TextureRect.texture = load("res://Assets/icon_miniboss.png")
			if pressable == false:
				$TextureRect.texture = load("res://Assets/icon_miniboss_no_outline.png")
	set_pressable(false)
	if useless:
		self.modulate.a = 0
		pressable = false

func set_pressable(value: bool) -> void:
	pressable = value
	self.modulate.a = 1.0 if pressable else 0.5
	if pressable:
		match map_type:
			type.Combat:
				$TextureRect.texture = load("res://Assets/icon_combat.png")
			type.Rest:
				$TextureRect.texture = load("res://Assets/icon_rest.png")
			type.Shop:
				$TextureRect.texture = load("res://Assets/icon_shop.png")
			type.Miniboss:
				$TextureRect.texture = load("res://Assets/icon_miniboss.png")

func set_visited() -> void:
	self.modulate.a = 0.3

func _on_button_pressed() -> void:
	if Stats.died == true:
		return
	if not pressable or Global.can_travel == false:
		return
	
	if row == 10:
		MapState.boss_data["visited"] = true
	else:
		MapState.node_data[row][col]["visited"] = true
	MapState.current_node = Vector2i(row, col)
	MapState.current_row = row
	emit_signal("node_selected", row, col)
	match map_type:
		type.Combat:
			var combat_scene = preload("res://Scenes/combat_test.tscn")
			Global.fight = Global.fight_type.Normal
			get_tree().change_scene_to_packed(combat_scene)
		type.Treasure:
			var treasure_scene = load("res://Scenes/treasure_scene.tscn")
			get_tree().change_scene_to_packed(treasure_scene)
		type.Rest:
			var rest_scene = load("res://Scenes/rest_scene.tscn")
			get_tree().change_scene_to_packed(rest_scene)
		type.Boss:
			var combat_scene = preload("res://Scenes/combat_test.tscn")
			Global.fight = Global.fight_type.Boss
			get_tree().change_scene_to_packed(combat_scene)
		type.Shop:
			var shop_scene = load("res://Scenes/shop_scene.tscn")
			get_tree().change_scene_to_packed(shop_scene)
		type.Miniboss:
			var combat_scene = preload("res://Scenes/combat_test.tscn")
			Global.fight = Global.fight_type.Miniboss
			get_tree().change_scene_to_packed(combat_scene)

func _on_button_mouse_entered() -> void:
	if pressable == false:
		return
	$TextureRect.modulate.a = 0.7

func _on_button_mouse_exited() -> void:
	if pressable == false:
		return
	$TextureRect.modulate.a = 1
