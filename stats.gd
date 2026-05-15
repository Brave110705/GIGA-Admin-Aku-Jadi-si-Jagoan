extends Node

var base_damage:int = 5
var player_damage: int:
	get:
		var dmg = base_damage
		if Equipment.has("Football"):
			dmg += total_miniboss_fought
		return dmg

var total_miniboss_fought:int = 0

var dvd:bool = false

var total_question_answered: int = 0

var player_base_hp:int = 50
var player_max_hp:int:
	get:
		var hp = player_base_hp
		if Equipment.has("equip_max_hp"):
			hp += 5
		return hp

var player_hp:int = player_max_hp
var delay_amount: float = 2

var type_monkey_len:int = 8

var player_gold: int = 20

func take_damage(amount:int):
	if player_hp <= 0:
		return
	
	if Equipment.has("Japanese Fan"):
		if Global.enemy_scene:
			Global.enemy_scene.take_damage(amount)
	
	amount = max(amount, 0)
	
	if Chai:
		base_damage += amount
		Chai_counter += amount
	
	player_hp -= amount
	
	if player_hp <= 0:
		dead()

var died:bool = false
func dead():
	var end_screen = load("res://Scenes/End_screen_dead.tscn").instantiate()
	add_child(end_screen)
	died = true

var eureka_delay: int = 0
var eureka_delay_counter: int = 0

var hint_increase: int = 0

var regeneration: int = 0

var Artist_Slump:bool = false
var Artist_Slump_counter:int = 0

var Chai:bool = false
var Chai_counter:int = 0

var Geisha:bool = false
var Geisha_convert_item_done:bool = false

var playmaker:bool = false
var playmaker_counter:int = 0

var masterchef:bool = false

var movie:bool = false

var climax:bool = false
func reset_status():
	Geisha = false
	
	Artist_Slump = false
	base_damage += Artist_Slump_counter
	Artist_Slump_counter = 0
	
	playmaker = false
	playmaker_counter = 0
	
	masterchef = false
	
	movie = false
	
	climax = false

func reset_Chai():
		Chai = false
		base_damage -= Chai_counter
		Chai_counter = 0
