extends GameScreen

@onready var _menu_anchor := $MenuAnchor
@onready var _menu_position := $Interface/MenuPosition
@onready var _items := $MenuAnchor/Items
@onready var _menu_map := $MenuMap
@onready var _fullscreen_checkbox := $MenuAnchor/Items/Settings/Fullscreen/CheckBox

func _ready() -> void:
	_items.modulate = Color(1.0, 1.0, 1.0, 0.0)

	if not Variables.has_loaded:
		Variables.load_variables()

	if Variables.stored.is_fullscreen:
		_fullscreen_checkbox.button_pressed = true

func _process(_delta: float) -> void:
	_menu_anchor.global_position = _menu_position.global_position

func _on_back_button_pressed() -> void:
	play_action_sound()
	Screens.change_screen(Constants.screens.welcome)

func do_show(_new_screen : int, _current_screen : int) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(_items, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5)

	did_show.emit()

func do_hide(new_screen : int, _current_screen : int) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(_items, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
	tween.tween_property(_menu_map, "position", Vector2(0, 0), 0.5)

	await tween.finished

	did_hide.emit()

func _on_check_box_pressed() -> void:
	play_action_sound()

	Variables.stored.is_fullscreen = _fullscreen_checkbox.is_pressed()
	Variables.force_save_variables()

	if _fullscreen_checkbox.is_pressed():
		Screens.maximise()
	else:
		Screens.restore()
