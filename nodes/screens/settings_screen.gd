extends GameScreen

@onready var _fullscreen_checkbox := $Center/Items/Fullscreen/CheckBox

func _ready() -> void:
	if not Variables.has_loaded:
		Variables.load_variables()

	if Variables.stored.is_fullscreen:
		_fullscreen_checkbox.button_pressed = true

func _on_back_button_pressed() -> void:
	Screens.change_screen(Constants.screens.welcome)

func _on_fullscreen_check_box_pressed() -> void:
	Variables.stored.is_fullscreen = _fullscreen_checkbox.is_pressed()
	Variables.force_save_variables()

	if _fullscreen_checkbox.is_pressed():
		Screens.maximise()
	else:
		Screens.restore()
