extends Control

var equip_id:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var equip_icon = load("res://Scenes/equipment_icon.tscn").instantiate()
	equip_icon.equip_id = equip_id
	$HBoxContainer/RichTextLabel.text = equip_id
	$HBoxContainer.add_child(equip_icon)
	$HBoxContainer.move_child(equip_icon, 0)

func _on_button_pressed() -> void:
	Equipment.add_equipment(equip_id)
	queue_free()

func _on_button_mouse_entered() -> void:
	modulate.a = 0.75

func _on_button_mouse_exited() -> void:
	modulate.a = 1
