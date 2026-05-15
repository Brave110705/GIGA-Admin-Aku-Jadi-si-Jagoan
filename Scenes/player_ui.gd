extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	Global.player_ui_scene = self

func _ready() -> void:
	Global.player_ui_scene = self
	visible = true
	refresh_equipment_ui()
	update_item_slots()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HBoxContainer/RichTextLabel.text = "%d / %d" % [Stats.player_hp, Stats.player_max_hp]
	$HBoxContainer/RichTextLabel2.text = "%d" % [Stats.player_gold]

func _on_texture_button_pressed() -> void:
	var existing = get_tree().root.get_node_or_null("ScrollContainer")
	
	if existing:
		return
	
	var map_scene = preload("res://Scenes/map.tscn").instantiate()
	map_scene.name = "ScrollContainer"
	add_child(map_scene)

func _on_texture_button_2_pressed() -> void:
	var book_scene = preload("res://Scenes/Book.tscn").instantiate()
	book_scene.name = "Book"
	add_child(book_scene)

func refresh_equipment_ui():
	for child in $EquipmentContainer.get_children():
		child.queue_free()
	
	for id in Equipment.equipment.keys():
		if Equipment.equipment[id]:
			var eq_node = preload("res://Scenes/equipment_icon.tscn").instantiate()
			eq_node.equip_id = id
			$EquipmentContainer.add_child(eq_node)

func update_item_slots():
	for i in 3:
		var item_id = Items.get_item(i)
		var texture = Items.get_texture(item_id)
		
		$HBoxContainer/Itemslot/Slots.get_child(i).texture_normal = texture

func _on_slot_1_pressed() -> void:
	Items.use_item(0)

func _on_slot_2_pressed() -> void:
	Items.use_item(1)

func _on_slot_3_pressed() -> void:
	Items.use_item(2)

var detail

func _on_slot_1_mouse_entered() -> void:
	if Items.slots[0] == Items.Item_id.EMPTY:
		return
	detail = load("res://Scenes/detail_scene.tscn").instantiate()
	detail.title = Items.get_item_name(Items.slots[0])
	detail.desc = Items.get_item_desc(Items.slots[0])
	detail.position.y += 33
	detail.position.x = $HBoxContainer/Itemslot/Slots/Slot1.global_position.x
	detail.scale = Vector2(1,1)
	add_child(detail)

func _on_slot_1_mouse_exited() -> void:
	if detail:
		detail.queue_free()

func _on_slot_2_mouse_entered() -> void:
	if Items.slots[1] == Items.Item_id.EMPTY:
		return
	detail = load("res://Scenes/detail_scene.tscn").instantiate()
	detail.title = Items.get_item_name(Items.slots[1])
	detail.desc = Items.get_item_desc(Items.slots[1])
	detail.position.y += 33
	detail.position.x = $HBoxContainer/Itemslot/Slots/Slot1.global_position.x
	detail.scale = Vector2(1,1)
	add_child(detail)


func _on_slot_2_mouse_exited() -> void:
	if detail:
		detail.queue_free()


func _on_slot_3_mouse_entered() -> void:
	if Items.slots[2] == Items.Item_id.EMPTY:
		return
	detail = load("res://Scenes/detail_scene.tscn").instantiate()
	detail.title = Items.get_item_name(Items.slots[2])
	detail.desc = Items.get_item_desc(Items.slots[2])
	detail.position.y += 33
	detail.position.x = $HBoxContainer/Itemslot/Slots/Slot1.global_position.x
	detail.scale = Vector2(1,1)
	add_child(detail)

func _on_slot_3_mouse_exited() -> void:
	if detail:
		detail.queue_free()
