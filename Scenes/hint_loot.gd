extends Control

var hint_amount = 2
var question_amount = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	var hint_choose = load("res://Scenes/choose_hint.tscn").instantiate()
	hint_choose.hint_amount = hint_amount + Stats.hint_increase
	hint_choose.question_amount = question_amount
	Global.combat_scene.add_child(hint_choose)
	queue_free()

func _on_button_mouse_entered() -> void:
	modulate.a = 0.75

func _on_button_mouse_exited() -> void:
	modulate.a = 1
