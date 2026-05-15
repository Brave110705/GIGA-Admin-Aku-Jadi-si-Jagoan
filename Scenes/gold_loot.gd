extends Control

var amount: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/RichTextLabel.text = "[color=orange]%d Gold[/color]" % amount

func _on_button_pressed() -> void:
	Stats.player_gold += amount
	queue_free()

func _on_button_mouse_entered() -> void:
	modulate.a = 0.75

func _on_button_mouse_exited() -> void:
	modulate.a = 1
