extends Node

var generated: bool = false
var node_data = []
var boss_data
var scroll_vertical = -1
# node_data[row][col] = { position, type, visited }

var current_row: int = -1
var connections = {} 

var current_node: Vector2i = Vector2i(-1, -1)

func reset():
	generated = false
	node_data = []
	current_row = -1
	connections = {}
	current_node = Vector2i(-1, -1)
