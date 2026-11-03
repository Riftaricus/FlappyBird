extends Sprite2D

enum Type { SHIELD, MAGNET, SLOW_MOON, SHRINK, COMET }

var options = [
	"res://assets/powerups/1_spore_shield.svg",
	"res://assets/powerups/2_firefly_magnet.svg",
	"res://assets/powerups/3_slow_moon.svg",
	"res://assets/powerups/4_shrink_shroom.svg",
	"res://assets/powerups/5_comet_dash.svg",
]

var powerup_type: int = Type.SHIELD

func _ready() -> void:
	if randi() % 100 > 50:
		randomize_texture()
	else:
		self.visible = false

func randomize_texture() -> void:
	powerup_type = randi() % options.size()
	texture = load(options[powerup_type])
	print(options[powerup_type])
