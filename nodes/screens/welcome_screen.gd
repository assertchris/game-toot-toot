extends GameScreen

@onready var _quit_button := $MenuAnchor/Items/QuitButton
@onready var _menu_anchor := $MenuAnchor
@onready var _menu_position := $Interface/MenuPosition
@onready var _items := $MenuAnchor/Items
@onready var _menu_map := $MenuMap

func _ready() -> void:
	if not Audio.is_playing_music():
		Audio.play_random_music(true)

	_quit_button.visible = not OS.has_feature("HTML5")
	_items.modulate = Color(1.0, 1.0, 1.0, 0.0)

func _process(_delta: float) -> void:
	_menu_anchor.global_position = _menu_position.global_position

func _on_play_button_pressed() -> void:
	play_action_sound()
	Audio.fade_out()
	await Audio.faded_out
	Screens.change_screen(Constants.screens.play)

func _on_settings_button_pressed() -> void:
	play_action_sound()
	Screens.change_screen(Constants.screens.settings)

func _on_credits_button_pressed() -> void:
	play_action_sound()
	Screens.change_screen(Constants.screens.credits)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func do_show(_new_screen : int, _current_screen : int) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(_items, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5)

	did_show.emit()

func do_hide(new_screen : int, _current_screen : int) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(_items, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)

	if new_screen == Constants.screens.credits:
		tween.tween_property(_menu_map, "position", Vector2(720, 0), 0.5)

	if new_screen == Constants.screens.settings:
		tween.tween_property(_menu_map, "position", Vector2(-720, 0), 0.5)

	await tween.finished

	did_hide.emit()
