extends Node2D

@export var LEVEL_NAME = "base"

var SAVE_PATH = ("user://"  + LEVEL_NAME + "-savegame.cfg")

@onready var label: Label = $HUD/Label
@onready var highscore: Label = $HUD/highScore

var score = -3;
var high_score = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_high_score()
	highscore.text = str(high_score)
	$Pipes.spawned.connect(_on_pipes_spawned)

func _on_pipes_spawned() -> void:
	score += 1;
	if (score >= high_score):
		high_score = score
		save_high_score()
	label.text = str(max(score, 0))
	highscore.text = str(high_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func save_high_score() -> void:
	var config := ConfigFile.new()
	config.set_value("game", "high_score", high_score)
	config.save(SAVE_PATH)

func load_high_score() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		high_score = config.get_value("game", "high_score", 0)
