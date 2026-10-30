extends Sprite2D

var velocity = 0;

const TEX_IDLE := preload("res://assets/bird_wings_in.png");
const TEX_FLAP := preload("res://assets/bird_wings_out.png");
const FLAP_TIME := 0.15;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	position.y += velocity;
	velocity += 10 * delta;
	
	if (Input.is_action_just_pressed("Jump")):
		velocity = -5;
		flap();
		
func flap() -> void:
	texture = TEX_FLAP;
	await get_tree().create_timer(FLAP_TIME).timeout;
	texture = TEX_IDLE;
