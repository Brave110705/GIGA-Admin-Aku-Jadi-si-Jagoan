extends CanvasLayer

var hint_amount = 1
var question_amount = 1
var pressed:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property($VBoxContainer, "modulate:a", 1, 0.25)
	$Panel.modulate.a = 0
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Panel, "modulate:a", 1, 0.25)

func _on_arts_pressed() -> void:
	if pressed:
		return
	pressed = true
	for i in range(question_amount):
		Question_Manager.add_permanent_hint("Art", hint_amount)
	var tween = get_tree().create_tween()
	tween.tween_property($VBoxContainer, "modulate:a", 0, 0.125)
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Panel, "modulate:a", 0, 0.125)
	await get_tree().create_timer(0.125).timeout
	queue_free()

func _on_food_pressed() -> void:
	if pressed:
		return
	pressed = true
	for i in question_amount:
		Question_Manager.add_permanent_hint("Food", hint_amount)
	var tween = get_tree().create_tween()
	tween.tween_property($VBoxContainer, "modulate:a", 0, 0.125)
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Panel, "modulate:a", 0, 0.125)
	await get_tree().create_timer(0.125).timeout
	queue_free()

func _on_japan_pressed() -> void:
	if pressed:
		return
	pressed = true
	for i in question_amount:
		Question_Manager.add_permanent_hint("Jepang", hint_amount)
	var tween = get_tree().create_tween()
	tween.tween_property($VBoxContainer, "modulate:a", 0, 0.125)
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Panel, "modulate:a", 0, 0.125)
	await get_tree().create_timer(0.125).timeout
	queue_free()

func _on_movie_pressed() -> void:
	if pressed:
		return
	pressed = true
	for i in question_amount:
		Question_Manager.add_permanent_hint("Movie", hint_amount)
	var tween = get_tree().create_tween()
	tween.tween_property($VBoxContainer, "modulate:a", 0, 0.125)
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Panel, "modulate:a", 0, 0.125)
	await get_tree().create_timer(0.125).timeout
	queue_free()

func _on_sports_pressed() -> void:
	if pressed:
		return
	pressed = true
	for i in question_amount:
		Question_Manager.add_permanent_hint("Sports", hint_amount)
	var tween = get_tree().create_tween()
	tween.tween_property($VBoxContainer, "modulate:a", 0, 0.125)
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Panel, "modulate:a", 0, 0.125)
	await get_tree().create_timer(0.125).timeout
	queue_free()
