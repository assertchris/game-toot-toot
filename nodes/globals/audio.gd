extends Node

signal music_finished
signal sound_finished
signal faded_out

@onready var _music_player := $MusicPlayer
@onready var _sound_player := $SoundPlayer
@onready var _restart_music_timer := $RestartMusicTimer

var is_playing_forever := false
var sounds_bus := AudioServer.get_bus_index("sounds")
var music_bus := AudioServer.get_bus_index("music")

func _ready() -> void:
	if not Variables.has_loaded:
		Variables.load_variables()

	AudioServer.set_bus_volume_db(sounds_bus, linear2db(Variables.stored.volume.sounds))
	AudioServer.set_bus_volume_db(music_bus, linear2db(Variables.stored.volume.music))

func play_random_music(forever : bool = false) -> void:
	is_playing_forever = forever
	play_music(Constants.music_streams[randi() % Constants.music_streams.size()])

func play_music(music_stream: AudioStream) -> void:
	_music_player.stop()
	_music_player.stream = music_stream
	_music_player.play()

func fade_out() -> void:
	var starting_local_volume := db2linear(_music_player.volume_db)
	var current_local_volume := starting_local_volume

	while current_local_volume >= 0:
		current_local_volume -= 0.05
		_music_player.volume_db = linear2db(current_local_volume)
		await get_tree().create_timer(0.03).timeout

	stop_music()
	faded_out.emit()

	_music_player.volume_db = linear2db(starting_local_volume)

func stop_music() -> void:
	is_playing_forever = false
	_restart_music_timer.stop()
	_music_player.stop()

func play_sound(sound_stream: AudioStream) -> void:
	_sound_player.stop()
	_sound_player.stream = sound_stream
	_sound_player.play()

func _on_restart_music_timer_timeout() -> void:
	if is_playing_forever:
		play_random_music(is_playing_forever)

func _on_music_player_finished() -> void:
	music_finished.emit()

	if is_playing_forever:
		_restart_music_timer.start()

func _on_sound_player_finished() -> void:
	sound_finished.emit()
