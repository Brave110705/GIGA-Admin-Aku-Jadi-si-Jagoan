extends Node

var questions = []

func _ready():
	load_questions()

#func add_permanent_hint(question):
	#var hidden_indices = []
	#
	#for i in question["hint_state"].size():
		#if question["hint_state"][i] == 0:
			#hidden_indices.append(i)
	#
	#if hidden_indices.is_empty():
		#return
	#
	#var index = hidden_indices.pick_random()
	#question["hint_state"][index] = 1

func add_permanent_hint(category: String, amount: int):
	var valid_questions = []
	
	for q in questions:
		if q["category"] == category and not q["answered"]:
			
			var has_hidden = false
			
			for state in q["hint_state"]:
				if state == 0:
					has_hidden = true
					break
			
			if has_hidden:
				valid_questions.append(q)
	
	if valid_questions.is_empty():
		return
	
	var question = valid_questions.pick_random()
	
	for i in range(amount):
		var hidden_indices = []
		
		for j in range(question["hint_state"].size()):
			if question["hint_state"][j] == 0:
				hidden_indices.append(j)
		
		if hidden_indices.is_empty():
			break
		
		var index = hidden_indices.pick_random()
		question["hint_state"][index] = 1

#func load_questions():
	#var file = FileAccess.open("res://pertanyaan.json", FileAccess.READ)
	#var content = file.get_as_text()
	#var parsed = JSON.parse_string(content)
	#
	#if parsed == null:
		#push_error("gagal bg")
	#else:
		#questions = parsed
		#
		#for q in questions:
			#q["answered"] = false
			#
			#var answer_len = q["answer"].length()
			#
			#for i in answer_len:
				#q["hint_state"].append(0)

func load_questions():
	var file = FileAccess.open("res://pertanyaan.json", FileAccess.READ)
	var content = file.get_as_text()
	var parsed = JSON.parse_string(content)
	
	if parsed == null:
		push_error("gagal bg")
		return
	
	questions = parsed
	
	for q in questions:
		q["answered"] = false
		
		var answer_len = q["answer"].length()
		
		if not q.has("hint_state"):
			q["hint_state"] = []
		
		while q["hint_state"].size() < answer_len:
			q["hint_state"].append(0)
		
		while q["hint_state"].size() > answer_len:
			q["hint_state"].pop_back()
	
	questions = parsed
	
	for q in questions:
		if not q.has("answered"):
			q["answered"] = false
		
		var answer_len = q["answer"].length()
		
		if not q.has("hint_state"):
			q["hint_state"] = []
		
		while q["hint_state"].size() < answer_len:
			q["hint_state"].append(0)

#func get_question(question_type):
	#var category_name = ""
#
	#match question_type:
		#0:
			#category_name = "Food"
		#1:
			#category_name = "Jepang"
		#2:
			#category_name = "Movie"
		#3:
			#category_name = "Art"
		#4:
			#category_name = "Sports"
#
	#var valid_questions = []
#
	#for q in questions:
		#if q["category"] == category_name and not q["answered"]:
			#valid_questions.append(q)
#
	#if valid_questions.is_empty():
		#return null
#
	#return valid_questions.pick_random()

func get_question(question_type):
	var category_name = ""
	
	match question_type:
		0:
			category_name = "Food"
		1:
			category_name = "Jepang"
		2:
			category_name = "Movie"
		3:
			category_name = "Art"
		4:
			category_name = "Sports"
		5:
			category_name = "Any"
	
	var weighted_questions = []
	
	for q in questions:
		if (category_name == "Any" or q["category"] == category_name) and q["answered"] == false:
			
			var weight = 1
			
			# Base difficulty weight
			match q["difficulty"]:
				1:
					weight = 40
				2:
					weight = 20
				3:
					weight = 20
				4:
					weight = 10
				5:
					weight = 10
			
			if Global.fight == Global.fight_type.Boss:
				
				var category = q["category"]
				
				var answered = Global.answered_stats[category]
				var wrong = Global.wrong_stats[category]
				
				match Global.difficulty:
					
					Global.difficulty_enum.EASY:
						weight += wrong * 5
					
					Global.difficulty_enum.NORMAL:
						pass
					
					Global.difficulty_enum.HARD:
						weight -= answered * 5
						
						if weight < 1:
							weight = 1
			
			for i in range(weight):
				weighted_questions.append(q)
	
	if weighted_questions.is_empty():
		push_error("No valid questions found")
		return null
	
	return weighted_questions.pick_random()
