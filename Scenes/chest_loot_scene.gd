extends Sprite2D
var equip_id: String
signal loot_selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match equip_id:
		"equip_dmg":
			pass
		"equip_reduce_dmg_taken":
			pass
		"equip_max_hp":
			pass
		"equip_reveal":
			pass
	$RichTextLabel.text = equip_id

func _on_texture_button_pressed() -> void:
	Equipment.add_equipment(equip_id)
	emit_signal("loot_selected")
