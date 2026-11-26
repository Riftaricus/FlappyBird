extends Node2D

@export var LEVEL_NAME = "base"

@onready var label: Label = $HUD/Label
@onready var highscore: Label = $HUD/highScore

var score = -3
var high_score = 0

func _get_save_path() -> String:
	return "user://" + LEVEL_NAME + "-savegame.cfg"

func _ready() -> void:
	load_high_score()
	highscore.text = str(high_score)
	$Pipes.spawned.connect(_on_pipes_spawned)

func _on_pipes_spawned() -> void:
	score += 1
	if score >= high_score:
		high_score = score
		save_high_score()
	label.text = str(max(score, 0))
	highscore.text = str(high_score)

func save_high_score() -> void:
	var config := ConfigFile.new()
	config.set_value("game", "high_score", high_score)
	config.save(_get_save_path())

func load_high_score() -> void:
	var config := ConfigFile.new()
	if config.load(_get_save_path()) == OK:
		high_score = config.get_value("game", "high_score", 0)
