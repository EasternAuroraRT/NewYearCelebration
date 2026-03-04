extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

enum PlayerState{
	Walking,
	Jumping,
	Idling,
}
var player_state: PlayerState = PlayerState.Walking

func _ready() -> void:
	# Debug
	if get_node("/root/Game").get_meta("debug"):
		global_transform = %Debug/DebugStart.global_transform
		%ResetAnchor.transform = global_transform

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("game_jump") and is_on_floor():
		player_state = PlayerState.Jumping
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("game_left", "game_right", "game_forward", "game_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if is_on_floor():
			player_state = PlayerState.Walking
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		player_state = PlayerState.Idling
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("game_reset")):
		global_transform = %ResetAnchor.transform
	if(event.is_action_pressed("game_restart")):
		get_tree().reload_current_scene()
