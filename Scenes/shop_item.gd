extends TextureButton

var item_id
var cost: int
var bought: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_id = Items.get_random_item()
	texture_normal = Items.get_texture(item_id)
	cost = randi_range(50,100)
	
	match item_id:
		Items.Item_id.REVEAL:
			cost = 5
		Items.Item_id.LIGHTBULB:
			cost = 15
		Items.Item_id.G_MEDICINE:
			cost = 0
		Items.Item_id.HEADBAND:
			cost = 10
		Items.Item_id.MBG:
			cost = 20
		Items.Item_id.SLEEP_CAP:
			cost = 10
		Items.Item_id.TUMPENG:
			cost = 15
		Items.Item_id.STOPWATCH:
			cost = 10
		Items.Item_id.SWORD:
			cost = 10
		_:
			cost = 20
	$RichTextLabel.text = "%d G" % cost

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	if Stats.player_gold >= cost:
		if Items.slots[0] == Items.Item_id.EMPTY or Items.slots[1] == Items.Item_id.EMPTY or Items.slots[2] == Items.Item_id.EMPTY:
			buy()
	else:
		not_enough()

func buy():
	if bought:
		return
	Stats.player_gold -= cost
	Items.set_item(item_id)
	item_id = Items.get_item_empty()
	texture_normal = Items.get_texture(item_id)
	$RichTextLabel.text = ""
	bought = true

func not_enough():
	return

var detail
func _on_mouse_entered() -> void:
	if item_id == Items.Item_id.EMPTY:
		return
	detail = load("res://Scenes/detail_scene.tscn").instantiate()
	detail.title = Items.get_item_name(item_id)
	detail.desc = Items.get_item_desc(item_id)
	detail.position.y += 33
	add_child(detail)

func _on_mouse_exited() -> void:
	if detail != null:
		detail.queue_free()
		detail = null
