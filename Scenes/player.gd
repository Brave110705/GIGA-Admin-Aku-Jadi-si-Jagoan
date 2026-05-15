extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_scene = self

var value:float
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HPbar/RichTextLabel.text = "%d / %d" % [Stats.player_hp, Stats.player_max_hp]
	
	if Stats.player_hp < 0:
		Stats.player_hp = 0
		
		value = 0.0
		$HPbar.value = value
	else:
		value = (Stats.player_hp * 100.0 / Stats.player_max_hp)
		$HPbar.value = value

func change_pose(input:String):
	match input:
		"Think":
			$Panel/AnimatedSprite2D.frame = 1
		"Answer":
			$Panel/AnimatedSprite2D.frame = 2
