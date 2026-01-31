extends Node3D

var random_range: float = 30

var firework_template_scene = preload("res://Firework/Firework.tscn") as PackedScene
func _unhandled_key_input(event: InputEvent) -> void:
	var key_event = event as InputEventKey
	if(key_event.keycode == Key.KEY_SPACE):
		var firework = firework_template_scene.instantiate() as RigidBody3D
		add_child(firework)
		firework.head_color = Color.from_hsv(randf(), randf_range(0.5, 0.8), randf_range(0.75, 1.0))
		firework.position = Vector3.ZERO
		firework.rotation_degrees.x = randf_range(-random_range, random_range)
		firework.rotation_degrees.y = randf_range(-random_range, random_range)
		firework.fly_time = randf_range(1.0, 2.5)
		firework.fire()
