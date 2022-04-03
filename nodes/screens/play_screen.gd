extends GameScreen

@export var level_scene : PackedScene

func _ready() -> void:
	Audio.play_random_music(true)

	var new_level := level_scene.instantiate()
	add_child(new_level)
