extends MarginContainer
class_name GameScreen

signal prepared_to_show
signal prepared_to_hide
signal did_show
signal did_hide

func prepare_to_show() -> void:
	prepared_to_show.emit()

func prepare_to_hide() -> void:
	prepared_to_hide.emit()

func do_show(_new_screen : int) -> void:
	did_show.emit()

func do_hide(_current_screen : int) -> void:
	did_hide.emit()
