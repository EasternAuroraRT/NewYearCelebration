extends Node3D

@onready var path = $Path.curve as Curve3D
@onready var guide = $Path/Guide
@onready var guide_anchor = $Path/GuideAnchor
@onready var shape = $Path/RoadCollision/CollisionShape3D.shape as ConcavePolygonShape3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path.bake_interval = 2
	var baked_points = path.get_baked_points() as PackedVector3Array
	# var baked_up = path.get_baked_up_vectors() as PackedVector3Array
	var section_count: int = baked_points.size() - 1
	var leftVectors = PackedVector3Array()
	leftVectors.resize(section_count+1)
	for i in section_count:
		var left: Vector3 = Vector3.UP.cross(baked_points[i+1] - baked_points[i]).normalized()
		leftVectors[i] = ((left + leftVectors[i]) * 0.5).normalized()
	leftVectors[section_count] = Vector3.UP.cross(baked_points[section_count] - baked_points[section_count-1]).normalized()
	var vertices = PackedVector3Array()
	vertices.resize(section_count*6)
	for i in section_count:
		var base_count: int = i * 6
		vertices[base_count+0] = baked_points[i+0] - leftVectors[i+0]
		vertices[base_count+1] = baked_points[i+0] + leftVectors[i+0]
		vertices[base_count+2] = baked_points[i+1] + leftVectors[i+1]
		vertices[base_count+3] = baked_points[i+0] - leftVectors[i+0]
		vertices[base_count+4] = baked_points[i+1] + leftVectors[i+1]
		vertices[base_count+5] = baked_points[i+1] - leftVectors[i+1]
	shape.set_faces(vertices)
	guide.visible = false

var guide_start: bool = false
var guide_progress_ratio: float = 0.025

func _process(delta: float) -> void:
	if guide_start:
		guide_anchor.progress_ratio += delta * guide_progress_ratio
		var vec_back = guide_anchor.transform.basis.z.normalized()
		var vec_right = Vector3.UP.cross(vec_back).normalized()
		guide.transform = Transform3D(vec_right, Vector3.UP, vec_back, guide_anchor.transform.origin)
		if(guide_anchor.progress_ratio == 1):
			guide_start = false
			await get_tree().create_timer(3*2).timeout
			guide.visible = false


func _on_detect_area_body_entered(body: Node3D) -> void:
	if(body.name.contains("Player") and not guide_start):
		guide.position = Vector3.ZERO
		guide_anchor.progress_ratio = 0.0
		guide.visible = true
		guide_start = true
		
