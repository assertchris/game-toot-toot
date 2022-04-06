extends GameScreen

@onready var _camera := $Camera
@onready var _quit_button := $Center/Items/QuitButton

func _ready() -> void:
	if not Audio.is_playing_music():
		Audio.play_random_music(true)

	_camera.current = true
	_quit_button.visible = not OS.has_feature("HTML5")

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
