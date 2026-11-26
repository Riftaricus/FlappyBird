extends CharacterBody2D

const TEX_IDLE := preload("res://assets/bird_wings_in.png")
const TEX_FLAP := preload("res://assets/bird_wings_out.png")
const FLAP_TIME := 0.15

const GRAVITY := 900.0
const FLAP_FORCE := -300.0

@onready var sprite: Sprite2D = $Sprite2D

var alive := true
var flap_id := 0

func _process(delta: float) -> void:
	if position.y < -300 or position.y > 300:
		# die()
		print("ded")

func _physics_process(delta: float) -> void:
	if not alive:
		return

	velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("Jump"):
		velocity.y = FLAP_FORCE
		flap()

	move_and_slide()

func flap() -> void:
	flap_id += 1
	var my_id := flap_id
	sprite.texture = TEX_FLAP
	await get_tree().create_timer(FLAP_TIME).timeout
	if my_id == flap_id:
		sprite.texture = TEX_IDLE

func die() -> void:
	if not alive:
		return
	alive = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
