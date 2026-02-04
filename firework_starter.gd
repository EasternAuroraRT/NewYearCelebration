extends Node3D

@export_range(0.0, 180.0) var random_range: float = 30
@export var max_firework_count: int = 10

var firework_count: int = 0
var firework_template_scene = preload("res://Firework/Firework.tscn") as PackedScene
func _unhandled_key_input(event: InputEvent) -> void:
	if(firework_count >= max_firework_count): return
	var key_event = event as InputEventKey
	if(key_event.is_pressed() and key_event.keycode == Key.KEY_SPACE):
		var firework = firework_template_scene.instantiate() as RigidBody3D
		add_child(firework)
		firework.head_color = Color.from_hsv(randf(), randf_range(0.5, 0.8), randf_range(0.75, 1.0))
		firework.position = Vector3.ZERO
		firework.rotation_degrees.x = randf_range(-random_range, random_range)
		firework.rotation_degrees.y = randf_range(-random_range, random_range)
		firework.fly_time = randf_range(1.5, 2.0)
		firework.destroyed.connect(func(): firework_count -= 1)
		firework_count += 1
		firework.fire()
