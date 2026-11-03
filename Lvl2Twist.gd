extends Node
# Level 2 twist: "Flak-alarm"
# Elke FLAK_EVERY pijpen: flak-explosies in de lucht, camera trilt kort
# en de schoorstenen gaan iets sneller.
#
# Eindcutscene: na CUTSCENE_AFTER seconden spelen wordt het beeld overgenomen,
# frame1.png t/m frame6.png worden afgespeeld, daarna staat plankton.jpg 3 seconden
# in beeld en gaat het spel terug naar het hoofdmenu.

const FLAK_EVERY := 1
const SHAKE_TIME := 0.8
const SPEED_UP := 20.0
const MAX_SPEED := 650.0
const FLAK_TEX := preload("res://assets/lvl2_flak_puff.png")

const CUTSCENE_AFTER := 25.0   # seconden spelen voor de cutscene start
const FRAME_COUNT := 6         # frame1.png t/m frame6.png
const FRAME_TIME := 0.5        # seconden per frame (pas dit aan)
const END_IMAGE := "res://assets/plankton.jpg"
const END_IMAGE_TIME := 3.0
const MAIN_MENU := "res://MainMenu.tscn"

# HudManager begint ook op -3 (de eerste pijpen spawnen buiten beeld)
var pipes_passed := -1
var elapsed := 0.0
var cutscene_started := false

@onready var pipes: Node2D = $"../Pipes"
@onready var cam: Camera2D = $"../Camera2D"


func _ready() -> void:
	# Dit script blijft draaien als de rest van het spel gepauzeerd is
	process_mode = Node.PROCESS_MODE_ALWAYS
	pipes.spawned.connect(_on_pipe_spawned)


func _process(delta: float) -> void:
	if cutscene_started:
		return
	elapsed += delta
	if elapsed >= CUTSCENE_AFTER:
		start_cutscene()


func _on_pipe_spawned() -> void:
	pipes_passed += 1
	if cutscene_started:
		return
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


func start_cutscene() -> void:
	cutscene_started = true

	# Camera stilzetten en het spel pauzeren
	cam.is_shaking = false
	cam.offset = Vector2.ZERO
	get_tree().paused = true

	# Beeld overnemen: zwarte achtergrond + afbeelding over het hele scherm
	var layer := CanvasLayer.new()
	layer.layer = 100
	add_child(layer)

	var bg := ColorRect.new()
	bg.color = Color.BLACK
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(bg)

	var pic := TextureRect.new()
	pic.set_anchors_preset(Control.PRESET_FULL_RECT)
	pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	layer.add_child(pic)

	# frame1.png t/m frame6.png
	for i in range(1, FRAME_COUNT + 1):
		pic.texture = _load_image("res://assets/frame%d.png" % i)
		await get_tree().create_timer(FRAME_TIME, true).timeout

	# Eindplaatje
	pic.texture = _load_image(END_IMAGE)
	await get_tree().create_timer(END_IMAGE_TIME, true).timeout

	# Level stoppen: terug naar het hoofdmenu
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU)


func _load_image(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		return load(path) as Texture2D
	push_warning("Afbeelding niet gevonden: " + path)
	return null
