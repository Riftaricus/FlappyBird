extends VisibleOnScreenEnabler2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_screen_exited() -> void:
	print("You have lost!");
	return_to_home();
	
func return_to_home() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn");
