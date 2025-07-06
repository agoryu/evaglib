extends Node2D

@onready var animation = $AnimatedSprite
@onready var audio_explosion = $AudioExplosion

func _ready():
	animation.play("default")
	audio_explosion.play()

func _on_audio_explosion_finished() -> void:
	queue_free()
