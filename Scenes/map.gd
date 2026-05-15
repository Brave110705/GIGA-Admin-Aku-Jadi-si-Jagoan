extends ScrollContainer

var map_node = load("res://Scenes/map_node.tscn")
var nodes_by_row = []
var boss_node = null

@onready var panel = $Panel
@onready var lines = $Panel/Line2D

const ROWS = 10
const COLS = 4

const PANEL_WIDTH = 960
const PANEL_HEIGHT = 1300

var row_height
var col_width
var y_offset

func _ready() -> void:
	modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.25)
	row_height = PANEL_HEIGHT / ROWS
	col_width = PANEL_WIDTH / COLS
	y_offset = row_height 
	panel.custom_minimum_size = Vector2(PANEL_WIDTH, PANEL_HEIGHT + row_height * 2)
	
	randomize()
	if MapState.generated:
		rebuild_nodes()
	else:
		generate_nodes()
		save_to_state()
		hide_unconnected_nodes()
		MapState.generated = true
	
	if MapState.current_row == -1:
		unlock_initial_row()
	else:
		unlock_connected_nodes(MapState.current_node.x, MapState.current_node.y)

var node_coords = {}

func save_to_state():
	MapState.node_data = []
	MapState.current_row = -1
	for row in ROWS:
		MapState.node_data.append([])
		for col in COLS:
			var node = nodes_by_row[row][col]
			MapState.node_data[row].append({
				"position": node.position,
				"type": node.map_type,
				"visited": false,
				"hidden": false
			})
	
	if boss_node:
		MapState.boss_data = {
			"position": boss_node.position,
			"type": boss_node.map_type,
			"visited": false,
			"hidden": false
		}

func rebuild_nodes():
	for child in panel.get_children():
		if child != lines:
			child.queue_free()
	for child in lines.get_children():
		child.queue_free()
	nodes_by_row.clear()
	boss_node = null

	for row in ROWS:
		nodes_by_row.append([])
		for col in COLS:
			var node = map_node.instantiate()
			var data = MapState.node_data[row][col]
			node.position = data["position"]
			node.map_type = data["type"]
			node.row = row
			node.col = col
			node.node_selected.connect(_on_node_selected)
			if data["visited"]:
				node.set_visited()
			panel.add_child(node)
			nodes_by_row[row].append(node)
	
	if MapState.boss_data:
		boss_node = map_node.instantiate()
		var data = MapState.boss_data
		boss_node.position = data["position"]
		boss_node.map_type = data["type"]
		boss_node.row = ROWS 
		boss_node.col = 0
		boss_node.node_selected.connect(_on_node_selected)
		if data["visited"]:
			boss_node.set_visited()
		panel.add_child(boss_node)
	
	for key in MapState.connections:
		var parts = key.split(",")
		var from_row = parts[0].to_int()
		var from_col = parts[1].to_int()
		var a = nodes_by_row[from_row][from_col]
		for b_coord in MapState.connections[key]:
			var b
			if b_coord.x == ROWS:
				b = boss_node
			else:
				b = nodes_by_row[b_coord.x][b_coord.y]
			draw_connection(a, b)
	
	for row in range(1, ROWS):
		for col in COLS:
			var data = MapState.node_data[row][col]
			if data["hidden"]:
				var node = nodes_by_row[row][col]
				node.modulate.a = 0.0
				node.pressable = false

func _enter_tree():
	if MapState.scroll_vertical != -1:
		set_deferred("scroll_vertical", MapState.scroll_vertical)
		return
	set_deferred("scroll_vertical", 10000)

func _process(delta: float) -> void:
	pass

func generate_nodes():
	MapState.connections = {}
	MapState.boss_data = null
	for child in panel.get_children():
		if child != lines:
			child.queue_free()
	for child in lines.get_children():
		child.queue_free()
	nodes_by_row.clear()
	boss_node = null
	node_coords.clear()
	var shop_positions = []
	var candidates = []
	for row in range(2, 10):
		for col in range(COLS):
			candidates.append(Vector2i(row, col))
	candidates.shuffle()
	shop_positions = candidates.slice(0, 3)
	for row in ROWS:
		nodes_by_row.append([])
		for col in COLS:
			var node = map_node.instantiate()
			
			var coord = Vector2i(row, col)
			if row == 0:
				node.map_type = node.type.Combat
			elif shop_positions.has(coord):
				node.map_type = node.type.Shop
			else:
				var roll = randf()
				if roll < 0.50:
					node.map_type = node.type.Combat
				elif roll < 0.75:
					node.map_type = node.type.Miniboss
				else:
					node.map_type = node.type.Rest
			
			var x = col * col_width + col_width / 2
			var y = PANEL_HEIGHT - (row * row_height) - row_height / 2 + y_offset
			x += randf_range(-40, 40)
			y += randf_range(-20, 20)
			
			node.position = Vector2(x, y)
			node.row = row
			node.col = col
			node.node_selected.connect(_on_node_selected)
			node_coords[node] = Vector2i(row, col)
			
			panel.add_child(node)
			nodes_by_row[row].append(node)
	
	boss_node = map_node.instantiate()
	boss_node.map_type = boss_node.type.Boss
	var boss_x = PANEL_WIDTH / 2
	var boss_y = row_height / 2
	boss_node.position = Vector2(boss_x, boss_y)
	boss_node.row = ROWS
	boss_node.col = 0
	boss_node.node_selected.connect(_on_node_selected)
	node_coords[boss_node] = Vector2i(ROWS, 0)
	panel.add_child(boss_node)
	
	connect_nodes()

func connect_nodes():
	for row in range(ROWS - 1):
		var blocked_cols = {}
		var planned = {}
		
		for col in COLS:
			var candidates = []
			for offset in [-1, 0, 1]:
				var target_col = col + offset
				if target_col >= 0 and target_col < COLS:
					candidates.append(Vector2i(row + 1, target_col))
			candidates.shuffle()
			planned[col] = candidates
		
		for col in COLS:
			var targets = []
			
			if row == 0 || blocked_cols.has(col):
				targets.append(Vector2i(row + 1, col))
			else:
				var candidates = planned[col]
				var connect_count = randi_range(1, candidates.size())
				
				if connect_count == 1:
					targets.append(Vector2i(row + 1, col))
				else:
					for i in connect_count:
						targets.append(candidates[i])
					
					if targets.size() > 1:
						for target in targets:
							var neighbor_col = target.y
							if neighbor_col != col:
								blocked_cols[neighbor_col] = true
			
			var a = nodes_by_row[row][col]
			var key = "%d,%d" % [row, col]
			if not MapState.connections.has(key):
				MapState.connections[key] = []
			
			for b_coord in targets:
				var b = nodes_by_row[b_coord.x][b_coord.y]
				draw_connection(a, b)
				if not MapState.connections[key].has(b_coord):
					MapState.connections[key].append(b_coord)
	
	for col in COLS:
		var a = nodes_by_row[ROWS - 1][col]
		var b = boss_node
		var boss_coord = Vector2i(ROWS, 0)
		
		draw_connection(a, b)
		
		var key = "%d,%d" % [ROWS - 1, col]
		if not MapState.connections.has(key):
			MapState.connections[key] = []
		if not MapState.connections[key].has(boss_coord):
			MapState.connections[key].append(boss_coord)

func draw_connection(a, b, trim: float = 30.0):
	var line = Line2D.new()
	line.width = 2
	line.default_color = Color.BLACK
	
	var dir = (b.global_position - a.global_position).normalized()
	var start = a.global_position + dir * trim
	var end = b.global_position - dir * trim
	
	line.add_point(start)
	line.add_point(end)
	lines.add_child(line)

var exit_pressed:bool = false
func _on_texture_button_pressed() -> void:
	if exit_pressed:
		return
	exit_pressed = true
	MapState.scroll_vertical = scroll_vertical
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.125)
	await get_tree().create_timer(0.25).timeout
	queue_free()

func unlock_initial_row():
	for col in COLS:
		if not MapState.node_data[0][col]["hidden"]:
			nodes_by_row[0][col].set_pressable(true)

func unlock_connected_nodes(from_row: int, from_col: int):
	for row in ROWS:
		for col in COLS:
			if not MapState.node_data[row][col]["hidden"]:
				nodes_by_row[row][col].set_pressable(false)
	
	if boss_node and not MapState.boss_data["hidden"]:
		boss_node.set_pressable(false)
	
	var key = "%d,%d" % [from_row, from_col]
	if MapState.connections.has(key):
		for coord in MapState.connections[key]:
			if coord.x == ROWS:
				boss_node.set_pressable(true)
			else:
				nodes_by_row[coord.x][coord.y].set_pressable(true)

func _on_node_selected(row: int, col: int) -> void:
	unlock_connected_nodes(row, col)


func hide_unconnected_nodes():
	var changed = true
	
	while changed:
		changed = false
		
		var connected_targets = {}
		for key in MapState.connections:
			for coord in MapState.connections[key]:
				connected_targets[coord] = true
		
		for row in range(1, ROWS):
			for col in COLS:
				var coord = Vector2i(row, col)
				var node = nodes_by_row[row][col]
				
				if node.modulate.a == 0.0:
					continue
				
				if not connected_targets.has(coord):
					node.modulate.a = 0.0
					node.pressable = false
					MapState.node_data[row][col]["hidden"] = true
					var key = "%d,%d" % [row, col]
					MapState.connections.erase(key)
					changed = true
	
	for child in lines.get_children():
		child.queue_free()
	
	for key in MapState.connections:
		var parts = key.split(",")
		var from_row = parts[0].to_int()
		var from_col = parts[1].to_int()
		var a = nodes_by_row[from_row][from_col]
		for b_coord in MapState.connections[key]:
			var b
			if b_coord.x == ROWS:
				b = boss_node
			else:
				b = nodes_by_row[b_coord.x][b_coord.y]
			draw_connection(a, b)

func _exit_tree():
	MapState.scroll_vertical = scroll_vertical
