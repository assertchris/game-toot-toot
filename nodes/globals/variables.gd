extends Node

var has_loaded := false
var needs_to_save := false

var sounds_bus = AudioServer.get_bus_index("Sounds")
var music_bus = AudioServer.get_bus_index("Music")

var initial := {
	"volume": {
		"sounds": db2linear(AudioServer.get_bus_volume_db(sounds_bus)),
		"music": db2linear(AudioServer.get_bus_volume_db(music_bus)),
	},
}

var stored := {}

func _ready() -> void:
	stored = initial.duplicate()
	load_variables()

func reset() -> void:
	stored.hope = initial.hope
	stored.rescued = initial.rescued
	save_variables()

func has_saved() -> bool:
	return stored.hope != initial.hope or stored.rescued != initial.rescued

func load_variables():
	var file = File.new()

	if file.file_exists(Constants.save_file_path):
		var error = file.open_encrypted_with_pass(Constants.save_file_path, File.READ, Constants.save_file_key)

		if !error:
			stored = Variables.merge(stored, file.get_var())

		file.close()

	has_loaded = true

func save_variables():
	needs_to_save = true

func force_save_variables():
	var file = File.new()
	var error = file.open_encrypted_with_pass(Constants.save_file_path, File.WRITE, Constants.save_file_key)

	if !error:
		file.store_var(stored, true)

	file.close()

func _on_save_timer_timeout() -> void:
	if needs_to_save:
		needs_to_save = false
		force_save_variables()

static func merge(source: Dictionary, patch: Dictionary) -> Dictionary:
	var dupe = source.duplicate(true)

	for key in patch:
		dupe[key] = patch[key]

	return dupe
