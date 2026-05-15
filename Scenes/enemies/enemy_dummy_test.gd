extends Control

@export var max_hp:float = 100
var hp:float = max_hp
@export var damage = 5
@export var attack_cooldown:float = 20.00
var time_left: float
var dead:bool = false

enum type {NORMAL, ELITE}
@export var  enemy_type:type

enum question_type {Food, Jepang, Movie, Arts, Sports}
@export var enemy_question_type:question_type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.enemy_scene = self
	$Timer.wait_time = attack_cooldown
	$Timer.start()
	time_left = attack_cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Panel/AnimatedSprite2D/HPbar/RichTextLabel.text = "%d / %d" % [hp, max_hp]
	
	if hp < 0:
		hp = 0
		$Panel/AnimatedSprite2D/HPbar.value = 0
	else:
		$Panel/AnimatedSprite2D/HPbar.value = (hp / max_hp) * 100.0
	
	if not $Timer.is_stopped():
		var ratio: float = $Timer.time_left / attack_cooldown
		$Panel/AnimatedSprite2D/Timer_progress.value = ratio * 1000.0

func _on_timer_timeout() -> void:
	time_left = attack_cooldown
	attack()

var delay: bool = false
func attack():
	if delay:
		delay = false
		if Global.combat_scene:
			Global.combat_scene.load_new_question()
		return
	if dead:
		return
	Stats.take_damage(damage)
	if Global.combat_scene:
		Global.combat_scene.load_new_question()

func delay_timer(amount_sec: float):
	time_left += amount_sec
	time_left = min(time_left, attack_cooldown)
	
	$Timer.stop()
	$Timer.start(time_left)

func take_damage(amount:int):
	if dead:
		return
	if hp <= 0:
		return
	hp -= amount
	if hp <= 0:
		die()

func die():
	if Equipment.has("Rice Cooker"):
		Stats.player_hp += Stats.total_question_answered
		if Stats.player_hp > Stats.player_max_hp:
			Stats.player_hp = Stats.player_max_hp
			Stats.total_question_answered = 0
	$Timer.one_shot = true
	$Timer.stop()
	$Panel/AnimatedSprite2D/Timer_progress.visible = false
	
	dead = true
	if Global.combat_scene:
		Global.combat_scene.clear()
	var loot_scene = load("res://Scenes/loot_scene.tscn").instantiate()
	
	if enemy_type == type.ELITE:
		var equip_id:String = Equipment.get_random_unowned()
		loot_scene.add_loot_equipment(equip_id)
	
	loot_scene.add_loot_gold(20)
	loot_scene.add_loot_hint(2, 3)
	loot_scene.global_position.x = 0
	loot_scene.global_position.y = 0
	Global.combat_scene.add_child(loot_scene)
