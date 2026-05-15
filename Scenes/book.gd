extends TextureRect

@onready var question_log = $ScrollContainer/VBoxContainer/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.25)
	show_questions("Art")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#var scroll = $ScrollContainer
	#
	#var max_scroll = scroll.get_v_scroll_bar().max_value
	#var current_scroll = scroll.scroll_vertical
	#
	#var ratio = current_scroll / max_scroll if max_scroll > 0 else 0.0
	#
	#var alpha = 1.0
	#
	#if ratio < 0.15:
		#alpha = lerp(0.4, 1.0, ratio / 0.15)
	#elif ratio > 0.85:
		#alpha = lerp(1.0, 0.4, (ratio - 0.85) / 0.15)
	#
	#question_log.modulate.a = alpha

func show_questions(category_name:String):
	var text = ""
	
	for q in Question_Manager.questions:
		if q["category"] != category_name:
			continue
	
		var question_text = q["question"]
		var answer = q["answer"]
		var hint_state = q["hint_state"]
	
		var hint_progress = ""
	
		for i in range(answer.length()):
	
			if i < hint_state.size() and hint_state[i] == 1:
				hint_progress += answer[i]
			else:
				hint_progress += "_"
	
			hint_progress += " "
	
		if q["answered"]:
			text += "[s]" + question_text + "[/s]\n"
		else:
			text += question_text + "\n"

		text += "Hint   " + hint_progress + "\n\n"

	question_log.text = text


func _on_arts_pressed() -> void:
	show_questions("Art")

func _on_food_pressed() -> void:
	show_questions("Food")

func _on_jepang_pressed() -> void:
	show_questions("Jepang")

func _on_movie_pressed() -> void:
	show_questions("Movie")

func _on_sports_pressed() -> void:
	show_questions("Sports")

var exit_pressed:bool = false
func _on_texture_button_2_pressed() -> void:
	if exit_pressed:
		return
	exit_pressed = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.125)
	await get_tree().create_timer(0.25).timeout
	self.queue_free()
