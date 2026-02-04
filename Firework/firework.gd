extends RigidBody3D

@export var head_color: Color = Color.RED:
	get: return $Head.draw_pass_1.material.emission
	set(value): $Head.draw_pass_1.material.emission = value
	
@export var tail_color: Color = Color.RED:
	get: return $Tail.draw_pass_1.material.emission
	set(value): $Tail.draw_pass_1.material.emission = value

const _explose_delay: float = 0.5

@export var fly_time: float:
	get: return $Tail.lifetime + _explose_delay
	set(value): $Tail.lifetime = value - _explose_delay
signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fly_time = 1.5
	$Head.emitting = false
	$Head.one_shot = true
	$Tail.emitting = false
	$Tail.one_shot = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
var should_accelerate: bool = false
func _process(delta: float) -> void:
	if(should_accelerate):
		apply_central_force(basis.y * 12.0 * mass)

func fire() -> void:
	$Tail.emitting = true
	should_accelerate = true
	get_tree().create_timer($Tail.lifetime).timeout.connect(func(): should_accelerate = false)
	get_tree().create_timer(fly_time).timeout.connect(func(): $Head.emitting = true)

func _enter_tree() -> void:
	$Tail.finished.connect(_self_destroy)

func _self_destroy() -> void:
	await get_tree().create_timer($Head.lifetime).timeout
	destroyed.emit()
	queue_free()
