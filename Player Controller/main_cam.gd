extends Camera3D


@export_range(0.01, 2.0) var mouse_sensitivity: float = 1.0
@export var reverse_mouse_input: bool = false

var mouse_move_base_fac: float = 0.001

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(OS.get_name() == "Android" or OS.get_name() == "iOS"):
		mouse_move_base_fac *= 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_transform = $"../CameraControllerAnchor".get_global_transform_interpolated()
	mouse_delta_processed = .02 * -Input.get_vector("game_move_mouse_left", "game_move_mouse_right", "game_move_mouse_up", "game_move_mouse_down")
	get_parent().rotate(Vector3.UP, mouse_delta_processed.x);
	$"../CameraControllerAnchor".rotate(Vector3.RIGHT, mouse_delta_processed.y);
	

var mouse_delta_processed: Vector2
func _unhandled_input(event: InputEvent) -> void:
	if event.as_text().contains("game_move_mouse_"): return
	if (event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED) or (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) or (event is InputEventScreenDrag)):
		if(not (event is InputEventMouseMotion or InputEventScreenDrag)): return
		mouse_delta_processed = -event.relative * mouse_sensitivity * mouse_move_base_fac * (-1 if reverse_mouse_input else 1)
		get_parent().rotate(Vector3.UP, mouse_delta_processed.x);
		$"../CameraControllerAnchor".rotate(Vector3.RIGHT, mouse_delta_processed.y);
	
