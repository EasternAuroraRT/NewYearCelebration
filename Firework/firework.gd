extends RigidBody3D

@export var head_color: Color = Color.RED:
	get: return $Head.draw_pass_1.material.emission
	set(value): $Head.draw_pass_1.material.emission = value
	
@export var tail_color: Color = Color.RED:
	get: return $Tail.draw_pass_1.material.emission
	set(value): $Tail.draw_pass_1.material.emission = value

@export var fly_time: float = 1.5:
	get: return $Tail.lifetime + 0.2
	set(value): $Tail.lifetime = value - 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Head.emitting = false
	$Head.one_shot = true
	$Tail.emitting = false
	$Tail.one_shot = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#position = Vector3.ZERO
	pass

func fire() -> void:
	var start_speed = fly_time * 9.8
	apply_central_impulse(basis.y * start_speed)
	$Tail.emitting = true
	get_tree().create_timer(fly_time).timeout.connect(func(): $Head.emitting = true)
	pass

func _enter_tree() -> void:
	$Tail.finished.connect(_self_destroy)

func _self_destroy() -> void:
	await get_tree().create_timer($Tail.lifetime).timeout
	queue_free()
