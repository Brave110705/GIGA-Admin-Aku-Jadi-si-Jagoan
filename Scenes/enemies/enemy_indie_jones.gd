extends Control

@export var base_max_hp:float
@export var spike_hp:float

@export var base_damage: int
@export var spike_damage: int

@export var attack_cooldown_easy: float
@export var attack_cooldown_normal: float
@export var attack_cooldown_hard: float

@export var effect_title: String
@export_multiline var desc: String

var attack_cooldown:
	get:
		match Global.difficulty:
			Global.difficulty_enum.EASY:
				return attack_cooldown_easy
			
			Global.difficulty_enum.NORMAL:
				return attack_cooldown_normal
			
			Global.difficulty_enum.HARD:
				return attack_cooldown_hard
		
		return attack_cooldown_normal

var time_left: float
var dead:bool = false

enum type {NORMAL, ELITE}
@export var  enemy_type:type

enum question_type {Food, Jepang, Movie, Arts, Sports, Any}
@export var enemy_question_type:question_type

var max_hp: float
var hp: float
var damage: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Stats.total_miniboss_fought += 1
	Stats.movie = true
	max_hp = Global.spike*spike_hp + base_max_hp
	hp = max_hp
	damage = Global.spike*spike_damage + base_damage
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
	Stats.reset_status()
	$Timer.one_shot = true
	$Timer.stop()
	$Panel/AnimatedSprite2D/Timer_progress.visible = false
	
	dead = true
	if Global.combat_scene:
		Global.combat_scene.clear()
	var loot_scene = load("res://Scenes/loot_scene.tscn").instantiate()
	
	if enemy_type == type.ELITE:
		var equip_id:String = "DVD"
		loot_scene.add_loot_equipment(equip_id)
	
	loot_scene.add_loot_gold(20)
	loot_scene.add_loot_hint(2, 3)
	loot_scene.global_position.x = 0
	loot_scene.global_position.y = 0
	Global.combat_scene.add_child(loot_scene)

var detail

func _on_texture_rect_mouse_entered() -> void:
	detail = load("res://Scenes/detail_scene.tscn").instantiate()
	detail.title = effect_title
	detail.desc = desc
	detail.position.y += $Panel/AnimatedSprite2D/TextureRect.global_position.y + 24
	detail.position.x = $Panel/AnimatedSprite2D/TextureRect.global_position.x
	detail.scale = Vector2(1,1)
	add_child(detail)

func _on_texture_rect_mouse_exited() -> void:
	if detail:
		detail.queue_free()
