extends Node3D

var firework_template = preload("res://Firework/Firework.tscn").instantiate()

func _unhandled_key_input(event: InputEvent) -> void:
	var key_event = event as InputEventKey
	if(key_event.keycode == Key.KEY_SPACE):
		var firework = firework_template.duplicate()
		add_child(firework)
		firework.head_color = Color.from_hsv(randf(), randf_range(0.5, 0.8), randf_range(0.75, 1.0))
		firework.position = Vector3.ZERO
		firework.fire()
