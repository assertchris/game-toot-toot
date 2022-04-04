extends GameScreen

@export var level_scene : PackedScene

func _ready() -> void:
	var new_level := level_scene.instantiate()
	add_child(new_level)

	await get_tree().create_timer(1.0).timeout
	Audio.play_random_music(true)
