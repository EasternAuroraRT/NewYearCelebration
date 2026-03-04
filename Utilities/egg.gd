extends Node3D

func _ready() -> void:
	for box in get_tree().get_nodes_in_group("egg_box") as Array[StaticBody3D]:
		box.visible = false
		box.set_meta("TargetPos", box.position)
		box.position.y -= 2
	for platform in get_tree().get_nodes_in_group("egg_platform") as Array[StaticBody3D]:
		platform.visible = false
		platform.set_meta("TargetPos", platform.position)
		platform.position.y -= 1

var start_area_first_triggered: bool = false
func _on_start_area_body_entered(body: Node3D) -> void:
	if(start_area_first_triggered): return
	if(body.name.contains("Player")):
		%UI.set_label_text("You mean you insist going forward?")
		%UI.show(2)
		start_area_first_triggered = true

var egg_area_first_triggered: bool = false
var egg_area_activate: bool = false
func _on_egg_area_body_entered(body: Node3D) -> void:
	if(egg_area_first_triggered): return
	if(body.name.contains("Player")):
		egg_area_first_triggered = true
		%UI.set_label_text("You have found a new challenge!")
		%UI.show(2)
		var egg_boxes = get_tree().get_nodes_in_group("egg_box") as Array[Node3D]
		var count: int  = 0
		var tween = create_tween().set_parallel(true)
		for box in egg_boxes:
			tween.tween_property(box, "position", box.get_meta("TargetPos"), 1.0).set_delay(count * 0.05).set_trans(Tween.TransitionType.TRANS_SPRING)
			box.visible = true
			count += 1

func _on_anti_egg_body_entered(body: Node3D) -> void:
	if(body.name.contains("Player")):
		queue_free()


func _on_fail_area_body_entered(body: Node3D) -> void:
	if body.name.contains("Player") and egg_area_activate:
		%UI.set_label_text("Press R to reset")
		%UI.show(2)


func _on_challenge_start_body_entered(body: Node3D) -> void:
	if body.name.contains("Player"):
		egg_area_activate = true
		%ResetAnchor.global_transform = body.global_transform


func _on_fail_area_body_exited(body: Node3D) -> void:
	if body.name.contains("Player"):
		%UI.label_active = false

var platform_area_first_triggered: bool = false
func _on_platform_start_body_entered(body: Node3D) -> void:
	if(platform_area_first_triggered): return
	if(body.name.contains("Player")):
		platform_area_first_triggered = true
		var egg_platforms = get_tree().get_nodes_in_group("egg_platform") as Array[Node3D]
		var count: int  = 0
		var tween = create_tween().set_parallel(true)
		for box in egg_platforms:
			tween.tween_property(box, "position", box.get_meta("TargetPos"), 1.0).set_delay(count * 0.05).set_trans(Tween.TransitionType.TRANS_SPRING)
			count += 1
		for box in egg_platforms:
			box.visible = true
			await get_tree().create_timer(0.1).timeout
