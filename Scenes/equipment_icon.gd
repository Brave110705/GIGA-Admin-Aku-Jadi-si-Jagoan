extends TextureRect

var equip_id: String

var desc
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	desc = Equipment.get_equip_desc(equip_id)
	match equip_id:
		"Magic Pen":
			texture = load("res://Assets/item_sprites/Canvas.png")
		"Japanese Fan":
			texture = load("res://Assets/item_sprites/JP_Cat.png")
		"Football":
			texture = load("res://Assets/item_sprites/Football.png")
		"Rice Cooker":
			texture = load("res://Assets/item_sprites/RiceCooker.png")
		"DVD" :
			texture = load("res://Assets/item_sprites/DVD.png")

var detail
func _on_mouse_exited() -> void:
	if detail:
		detail.queue_free()

func _on_mouse_entered() -> void:
	if equip_id == null:
		return
	detail = load("res://Scenes/detail_scene.tscn").instantiate()
	detail.title = equip_id
	detail.desc = desc
	detail.position.y += global_position.y + 33
	detail.position.x = get_global_mouse_position().x
	detail.scale = Vector2(1,1)
	Global.player_ui_scene.add_child(detail)
