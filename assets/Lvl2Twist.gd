extends Node
# Level 2 twist: "Flak-alarm"
# Elke FLAK_EVERY pijpen: flak-explosies in de lucht, camera trilt kort
# en de schoorstenen gaan iets sneller.

const FLAK_EVERY := 5
const SHAKE_TIME := 0.8
const SPEED_UP := 20.0
const MAX_SPEED := 450.0
const FLAK_TEX := preload("res://assets/lvl2_flak_puff.png")

# HudManager begint ook op -3 (de eerste pijpen spawnen buiten beeld)
var pipes_passed := -3

@onready var pipes: Node2D = $"../Pipes"
@onready var cam: Camera2D = $"../Camera2D"


func _ready() -> void:
	pipes.spawned.connect(_on_pipe_spawned)


func _on_pipe_spawned() -> void:
	pipes_passed += 1
	if pipes_passed > 0 and pipes_passed % FLAK_EVERY == 0:
		flak_alarm()


func flak_alarm() -> void:
	cam.is_shaking = true
	for i in 6:
		spawn_puff()
	pipes.speed = min(pipes.speed + SPEED_UP, MAX_SPEED)
	await get_tree().create_timer(SHAKE_TIME).timeout
	cam.is_shaking = false


func spawn_puff() -> void:
	var puff := Sprite2D.new()
	puff.texture = FLAK_TEX
	puff.z_index = 2  # achter de schoorstenen (z 3), voor de achtergrond (z 1)
	puff.position = Vector2(randf_range(-400, 500), randf_range(-260, 80))
	puff.scale = Vector2.ZERO
	get_parent().add_child(puff)
	var t := create_tween()
	t.tween_property(puff, "scale", Vector2.ONE * randf_range(0.6, 1.2), 0.15)
	t.tween_property(puff, "modulate:a", 0.0, 0.8)
	t.tween_callback(puff.queue_free)
