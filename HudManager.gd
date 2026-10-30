extends Node2D

@onready var label: Label = $HUD/Label

var score = -3;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Pipes.spawned.connect(_on_pipes_spawned)

func _on_pipes_spawned() -> void:
	score += 1;
	label.text = str(score if score > 0 else 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
