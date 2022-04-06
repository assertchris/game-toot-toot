extends GameVehicle

@export var toot_toot_stream : AudioStream

func complete() -> void:
	Audio.play_sound(toot_toot_stream)
	super.complete()
