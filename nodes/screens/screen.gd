extends MarginContainer
class_name GameScreen

signal prepared_to_show
signal prepared_to_hide
signal did_show
signal did_hide

@export var action_stream : AudioStream

func prepare_to_show(_new_screen : int, _current_screen : int) -> void:
	prepared_to_show.emit()

func prepare_to_hide(_current_screen : int, _new_screen : int) -> void:
	prepared_to_hide.emit()

func do_show(_new_screen : int, _current_screen : int) -> void:
	did_show.emit()

func do_hide(_current_screen : int, _new_screen : int) -> void:
	did_hide.emit()

func play_action_sound() -> void:
	Audio.play_sound(action_stream)
