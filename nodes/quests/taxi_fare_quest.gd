extends GameQuest

@export var whistle_stream : AudioStream
@export var frustration_stream : AudioStream

@onready var _sprite := $Sprite

var current_tween : Tween
var stopped_showing := false

func _ready() -> void:
	_sprite.position.x += 32
	_sprite.playing = false

func show() -> void:
	_sprite.playing = true

	current_tween = get_tree().create_tween()
	current_tween.tween_property(_sprite, "position", Vector2(0, -4), 2)
	current_tween.tween_callback(finish_showing)

func stop_showing() -> void:
	stopped_showing = true

	if current_tween:
		current_tween.stop()

func finish_showing() -> void:
	if not stopped_showing:
		Audio.play_sound(whistle_stream)

	_sprite.playing = false
	did_show.emit()
