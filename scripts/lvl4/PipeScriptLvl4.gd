extends Node2D

signal spawned

const BOTTOM_TENTACLES = [
	preload("res://assets/lvl4/tentacle_bottom_1.png"),
	preload("res://assets/lvl4/tentacle_bottom_2.png"),
	preload("res://assets/lvl4/tentacle_bottom_3.png"),
]
const TOP_TENTACLES = [
	preload("res://assets/lvl4/tentacle_top_1.png"),
	preload("res://assets/lvl4/tentacle_top_2.png"),
	preload("res://assets/lvl4/tentacle_top_3.png"),
]

@onready var bottom_tentacle: Sprite2D = $PipeUp/Tentacle
@onready var top_tentacle: Sprite2D = $PipeDown/Tentacle

@export var speed := 300.0
@export var spawn_interval := 2.0

var move := false
var time_since_spawn := 0.0


func _ready() -> void:
	bottom_tentacle.texture = BOTTOM_TENTACLES.pick_random()
	top_tentacle.texture = TOP_TENTACLES.pick_random()


func _process(delta: float) -> void:
	if move:
		position.x -= speed * delta
		if position.x < -2500:
			queue_free()
		return

	time_since_spawn += delta
	if time_since_spawn >= spawn_interval:
		time_since_spawn -= spawn_interval
		spawn_clone()


func spawn_clone() -> void:
	var clone: Node2D = duplicate()
	clone.move = true
	clone.z_index = 3
	clone.position.y = randi_range(-450, -250)
	get_parent().add_child(clone)
	spawned.emit()


func _on_pipe_down_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		body.die();


func _on_pipe_up_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		body.die();
