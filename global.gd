extends Node

var main_scene_file = preload("res://Scenes/main.tscn")
var main_scene

var initial_scene_file = preload("res://Scenes/Initial_scene.tscn")

var can_travel:bool = true

var combat_scene
var player_ui_scene
var enemy_scene

func rest():
	Stats.player_hp += 30
	if Stats.player_hp > Stats.player_max_hp:
		Stats.player_hp = Stats.player_max_hp

var spike: int = 1
enum difficulty_enum{EASY,NORMAL,HARD}
var difficulty:difficulty_enum = difficulty_enum.EASY

enum fight_type{Normal, Miniboss, Boss}
var fight:fight_type = fight_type.Boss

var dead:bool = false

var player_scene

var answered_stats = {
	"Art": 0,
	"Food": 0,
	"Movie": 0,
	"Jepang": 0,
	"Sports": 0
}

var wrong_stats = {
	"Art": 0,
	"Food": 0,
	"Movie": 0,
	"Jepang": 0,
	"Sports": 0
}

func add_answered(category: String):
	if answered_stats.has(category):
		answered_stats[category] += 1

func add_wrong(category: String):
	if wrong_stats.has(category):
		wrong_stats[category] += 1
