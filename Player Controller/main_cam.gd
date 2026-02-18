extends Camera3D


@export_range(0.01, 2.0) var mouse_sensitivity: float = 1.0
@export var reverse_mouse_input: bool = false

var mouse_move_base_fac: float = 0.001


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED) or (Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
		var mouse_delta_processed: Vector2 = -event.relative * mouse_sensitivity * mouse_move_base_fac * (-1 if reverse_mouse_input else 1)
		get_parent().rotate(Vector3.UP, mouse_delta_processed.x);
		rotate(Vector3.RIGHT, mouse_delta_processed.y);
