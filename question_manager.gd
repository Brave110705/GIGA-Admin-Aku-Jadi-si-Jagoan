extends Node

var questions = []

func _ready():
	load_questions()

func load_questions():
	var file = FileAccess.open("res://pertanyaan.json", FileAccess.READ)
	var content = file.get_as_text()
	var parsed = JSON.parse_string(content)
	
	if parsed == null:
		push_error("gagal bg")
	else:
		questions = parsed

func get_question(category = "", difficulty = -1):
	var pool = questions.filter(func(q):
		return (
			(category == "" or q["category"] == category) and
			(difficulty == -1 or q["difficulty"] == difficulty)
		)
	)
	
	if pool.is_empty():
		push_warning("questions empty")
		return null
	
	return pool.pick_random()
