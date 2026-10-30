extends CharacterBody2D

const TEX_IDLE := preload("res://assets/bird_wings_in.png")
const TEX_FLAP := preload("res://assets/bird_wings_out.png")
const FLAP_TIME := 0.15

const GRAVITY := 900.0
const FLAP_FORCE := -300.0

var last_press = 0

@onready var sprite: Sprite2D = $Sprite2D

var alive := true
var flap_id := 0

func _process(delta: float) -> void:
	if position.y < -300 or position.y > 200:
		die()

func _physics_process(delta: float) -> void:
	if not alive:
		return

	velocity.y += GRAVITY * delta

	last_press -= 1

	if Input.is_action_pressed("Jump"):
		
		
		if last_press < 0:
			velocity.y = FLAP_FORCE
			flap()
			last_press = 15

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
	get_tree().reload_current_scene()
