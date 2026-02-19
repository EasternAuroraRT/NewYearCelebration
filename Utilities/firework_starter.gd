extends Node3D

@export_range(0.0, 180.0) var random_range: float = 15
@export var max_firework_count: int = 10

var firework_count: int = 0
var can_interact: bool = false
var firework_template_scene = preload("res://Firework/Firework.tscn") as PackedScene
func _unhandled_key_input(event: InputEvent) -> void:
	if(firework_count >= max_firework_count): return
	if(not can_interact): return
	var key_event = event as InputEventKey
	if(key_event.is_action_pressed("game_interact")):
		var firework = firework_template_scene.instantiate() as RigidBody3D
		add_child(firework)
		firework.head_color = Color.from_hsv(randf(), randf_range(0.5, 0.8), randf_range(0.75, 1.0))
		firework.global_position = global_position
		firework.rotation_degrees.y = randf_range(0, 360)
		firework.rotation_degrees.x = randf_range(0.0, random_range)
		firework.fly_time = randf_range(1.2, 1.5)
		firework.destroyed.connect(func(): firework_count -= 1)
		firework_count += 1
		firework.fire()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body.name.contains("Player")):
		print("player entered!")
		#%UI/Label.text = "Press F to interact."
		can_interact = true
		%UI.label_active = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if(body.name.contains("Player")):
		print("player exited!")
		can_interact = false
		%UI.label_active = false
