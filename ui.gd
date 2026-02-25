extends Node


var label_active: bool = false
var inactive_color: Color = Color(1.0, 1.0, 1.0, 0.0)
var active_color: Color = Color(1.0, 1.0, 1.0, 1.0)
var gradiant_duration: float = 0.8
var gradiant_time: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.self_modulate = inactive_color
	#label_active = true
	if(OS.get_name() != "Android" and OS.get_name() != "iOS"):
		$Buttons.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	gradiant_time = clampf(gradiant_time + delta * (1 if label_active else -1), 0.0, gradiant_duration)
	$Label.self_modulate = lerp(inactive_color, active_color, gradiant_time / gradiant_duration)

var entering_dangerous_zone: bool = false
func _on_warning_body_entered(body: Node3D) -> void:
	if(body.name.contains("Player")):
		entering_dangerous_zone = true
		$Label.text = "Are you escaping from the boundry?\nGet back before this get out of control."
		label_active = true
		await get_tree().create_timer(gradiant_duration+3).timeout
		label_active = false
		await get_tree().create_timer(gradiant_duration+5).timeout
		if(entering_dangerous_zone):
			$Label.text = "If you insist, that will be what happens to you..."
			label_active = true
			await get_tree().create_timer(gradiant_duration+2).timeout
			label_active = false
			await get_tree().create_timer(gradiant_duration+0.2).timeout
			%Floor.queue_free()
			await get_tree().create_timer(5).timeout
			get_tree().reload_current_scene()


func _on_should_reset_area_body_entered(body: Node3D) -> void:
	if(body.name.contains("Player")):
		$Label.text = "Press R to reset"
		label_active = true


func _on_should_reset_area_body_exited(body: Node3D) -> void:
	if(body.name.contains("Player")):
		label_active = false

func set_label_text(txt: String):
	$Label.text = txt
