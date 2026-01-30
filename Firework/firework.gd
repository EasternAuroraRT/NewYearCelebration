extends RigidBody3D

@export var head_color: Color = Color.RED:
	get: return $Head.draw_pass_1.material.emission
	set(value): $Head.draw_pass_1.material.emission = value
	
@export var tail_color: Color = Color.RED:
	get: return $Tail.draw_pass_1.material.emission
	set(value): $Tail.draw_pass_1.material.emission = value

@export var fly_time: float = 1.5:
	get: return $Tail.lifetime
	set(value): $Tail.lifetime = value

@onready var start_velocity: Vector3 = Vector3(0, (fly_time + 1) * 9.8, 0)

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
	apply_impulse(start_velocity, Vector3(0,0,0))
	$Tail.emitting = true
	get_tree().create_timer(fly_time + 1).timeout.connect(func(): $Head.emitting = true)
	pass

func _enter_tree() -> void:
	$Tail.finished.connect(self_destroy)

func self_destroy() -> void:
	await get_tree().create_timer($Tail.lifetime).timeout
	queue_free()
