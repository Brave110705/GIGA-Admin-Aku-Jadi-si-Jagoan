extends NinePatchRect

var title: String
var desc: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Title.text = title
	$Desc.text = desc
	var line_count = $Desc.get_line_count()
	size.y = 39 + 9*line_count
