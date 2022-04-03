extends GameScreen

func _ready() -> void:
	Audio.play_random_music(true)

func _on_play_button_pressed() -> void:
	Audio.fade_out()
	await Audio.faded_out
	Screens.change_screen(Constants.screens.play)
