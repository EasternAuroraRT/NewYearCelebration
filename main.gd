extends Node3D


func _input(event: InputEvent) -> void:
	if(event.is_action("game_terminate")):
		get_tree().quit()


func _ready() -> void:
	# capture and hide mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta: float) -> void:
	pass
