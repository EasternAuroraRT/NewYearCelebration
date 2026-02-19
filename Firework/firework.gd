extends RigidBody3D

@export_group("Visual")
@export var head_color: Color = Color.RED:
	get: return $Head.draw_pass_1.material.emission
	set(value): $Head.draw_pass_1.material.emission = value
	
@export var tail_color: Color = Color.RED:
	get: return $Tail.draw_pass_1.material.emission
	set(value): $Tail.draw_pass_1.material.emission = value

const _explose_delay: float = 0.1

@export_group("Physics")
@export var fly_time: float = 1.5:
	get: return $Tail.lifetime + _explose_delay
	set(value): $Tail.lifetime = value - _explose_delay

@export var acceleration: float = 15.0

signal destroyed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Head.emitting = false
	$Head.one_shot = true
	$Tail.emitting = false
	$Tail.one_shot = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
var should_accelerate: bool = false
var queue_explose: bool = false
func _process(_delta: float) -> void:
	if(should_accelerate):
		apply_central_force(basis.y * acceleration * mass)
	if(queue_explose):
		$Head.emitting = true
		queue_explose = false

func fire() -> void:
	$Tail.emitting = true
	should_accelerate = true
	await get_tree().create_timer($Tail.lifetime).timeout
	should_accelerate = false
	await get_tree().create_timer(_explose_delay).timeout
	sleeping = true
	queue_explose = true

func _enter_tree() -> void:
	$Tail.finished.connect(_self_destroy)

func _self_destroy() -> void:
	await get_tree().create_timer($Head.lifetime).timeout
	destroyed.emit()
	queue_free()
