extends Camera2D

const shake_strength := 20.0;
var is_shaking = false;

func toggle_shake() -> void:
	is_shaking = !is_shaking;
	
func _ready() -> void:
	pass
	#toggle_shake();

func _process(delta: float) -> void:
	if is_shaking:
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
	else:
		offset = Vector2.ZERO
