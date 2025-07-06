extends ShapeCast2D

@export var damage: int = 2

@onready var tween: Tween
@onready var fill_line: Line2D = $FillLine2D
@onready var fill_line2: Line2D = $FillLine2D2
@onready var casting_particles: GPUParticles2D = $CastingParticles2D
@onready var beam_casting: GPUParticles2D = $BeamParticles2D
@onready var collision_particules: GPUParticles2D = $CollisionParticles2D
@onready var audio_streamer: AudioStreamPlayer2D = $AudioStreamPlayer

@onready var color_rect: ColorRect = $ColorRect

var size: int = 0
var colliding_execute: bool = false

var is_casting := false:
	set = set_is_casting

func _ready():
	set_physics_process(false)
	fill_line.points[1] = Vector2.ZERO
	fill_line2.points[1] = Vector2.ZERO
	size = fill_line.width

func _physics_process(_delta: float) -> void:
	var cast_point := target_position
	force_shapecast_update()

	if is_colliding():
		cast_point = to_local(get_collision_point(0))
		cast_point.y = 0
		collision_particules.global_rotation = get_collision_normal(0).angle()
		collision_particules.position = cast_point
		collision_particules.emitting = true
		if not colliding_execute:
			for i in range(get_collision_count()):
				get_collider(i).health.loose_health(damage)
				colliding_execute = true

	fill_line.points[1] = cast_point
	fill_line2.points[1] = cast_point
	beam_casting.position = cast_point * 0.5
	beam_casting.process_material.emission_box_extents.x = cast_point.length() * 0.5

func set_is_casting(cast: bool) -> void:
	is_casting = cast
	set_physics_process(is_casting)

	beam_casting.emitting = is_casting
	casting_particles.emitting = is_casting
	if is_casting:
		appear()
	else:
		dissappear()

func appear() -> void:
	if is_instance_valid(tween):
		tween.kill()

	tween = create_tween()
	tween.tween_property(fill_line, "width", size, 0.2)
	tween.set_parallel()
	tween.tween_property(fill_line2, "width", size/4, 0.2)
	audio_streamer.play()

func dissappear() -> void:
	if is_instance_valid(tween):
		tween.kill()

	collision_particules.emitting = false
	colliding_execute = false
	tween = create_tween()
	tween.tween_property(fill_line, "width", 0, 0.2)
	tween.set_parallel()
	tween.tween_property(fill_line2, "width", 0, 0.2)

func increase_width(value : int):
	size += value
	shape.size.y += value
