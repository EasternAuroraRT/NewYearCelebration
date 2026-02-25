extends Node3D

func _ready() -> void:
	for box in get_tree().get_nodes_in_group("egg_box") as Array[StaticBody3D]:
		box.visible = false
	for platform in get_tree().get_nodes_in_group("egg_platform") as Array[StaticBody3D]:
		platform.visible = false

var start_area_first_triggered: bool = false
func _on_start_area_body_entered(body: Node3D) -> void:
	if(start_area_first_triggered): return
	if(body.name.contains("Player")):
		start_area_first_triggered = true
		%AnimationPlayer.play("EggStartLabel")

var egg_area_first_triggered: bool = false
var egg_area_activate: bool = false
func _on_egg_area_body_entered(body: Node3D) -> void:
	if(egg_area_first_triggered): return
	if(body.name.contains("Player")):
		egg_area_first_triggered = true
		%AnimationPlayer.play("EggInfoLabel")
		var egg_boxes = get_tree().get_nodes_in_group("egg_box") as Array[Node3D]
		var count: int  = 0
		var tween = create_tween().set_parallel(true)
		for box in egg_boxes:
			var target_pos = box.position
			var start_pos = box.position + Vector3(0, -1, 0)
			box.position = start_pos
			box.visible = true
			tween.tween_property(box, "position", target_pos, 0.5).set_delay(count * 0.2)
			count += 1

func _on_anti_egg_body_entered(body: Node3D) -> void:
	if(body.name.contains("Player")):
		queue_free()


func _on_fail_area_body_entered(body: Node3D) -> void:
	if body.name.contains("Player") and egg_area_activate:
		%UI.set_label_text("Press R to reset")
		%UI.label_active = true


func _on_challenge_start_body_entered(body: Node3D) -> void:
	if body.name.contains("Player"):
		egg_area_activate = true
		%ResetAnchor.global_transform = body.global_transform


func _on_fail_area_body_exited(body: Node3D) -> void:
	if body.name.contains("Player"):
		%UI.label_active = false
