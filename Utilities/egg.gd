extends Node3D

var start_area_first_triggered: bool = false
func _on_start_area_body_entered(body: Node3D) -> void:
	if(start_area_first_triggered): return
	if(body.name.contains("Player")):
		start_area_first_triggered = true
		%AnimationPlayer.play("EggStartLabel")

var egg_area_first_triggered: bool = false
func _on_egg_area_body_entered(body: Node3D) -> void:
	if(egg_area_first_triggered): return
	if(body.name.contains("Player")):
		egg_area_first_triggered = true
		%AnimationPlayer.play("EggInfoLabel")


func _on_anti_egg_body_entered(body: Node3D) -> void:
	if(body.name.contains("Player")):
		queue_free()
