extends PathFollow2D
class_name GameVehicle

signal faded_in
signal faded_out

@export var speed := 100

@onready var _sprite := $Sprite
@onready var _animator := $Animator

func flip() -> void:
	_animator.play("flip")

func fade_in() -> void:
	_animator.play("fade_in")
	await _animator.animation_finished
	faded_in.emit()

func fade_out() -> void:
	_animator.play_backwards("fade_in")
	await _animator.animation_finished
	faded_out.emit()

func _flip_sprite() -> void:
	_sprite.flip_h = not _sprite.flip_h
