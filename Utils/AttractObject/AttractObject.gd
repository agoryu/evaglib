extends Area2D

@export var drag := 14.0
@export var max_speed := 400.0

var _velocity := Vector2.ZERO

func attract(delta: float):
	var attractors := get_overlapping_areas()

	if attractors:
		var desired_velocity: Vector2 = (
			(attractors[0].global_position - get_parent().global_position).normalized() * max_speed
		)
		var steering := desired_velocity - _velocity
		_velocity += steering / drag
	else:
		_velocity = Vector2.ZERO
	get_parent().position += _velocity * delta
