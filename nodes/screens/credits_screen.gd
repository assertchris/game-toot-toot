extends GameScreen

@onready var _menu_anchor := $MenuAnchor
@onready var _menu_position := $Interface/MenuPosition
@onready var _items := $MenuAnchor/Items
@onready var _menu_map := $MenuMap

func _ready() -> void:
	_items.modulate = Color(1.0, 1.0, 1.0, 0.0)

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
