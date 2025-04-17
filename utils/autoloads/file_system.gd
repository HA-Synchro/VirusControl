class_name FileSystem
extends Resource

var data: Dictionary = {}
var current_path: Array = ["Drives"]
var virus_file_name: String = ""
var virus_file_path: Array = []
var sidebar_shortcuts := []

func _init():
	randomize()
	data = generate_random_filesystem()

func generate_random_filesystem() -> Dictionary:
	var extensions = [".txt", ".doc", ".pdf", ".jpg", ".png", ".mp3", ".mp4", ".exe", ".dll", ".sys", ".bat", ".zip"]
	var adjectives = ["important", "old", "new", "secret", "personal", "work", "backup", "temp", "final", "draft"]
	var nouns = ["report", "data", "letter", "project", "photo", "song", "movie", "file", "document", "presentation"]
	var drive_letters = ["C:", "D:", "E:", "F:", "G:", "H:", "I:", "J:"]

	var filesystem = {
		"Drives": {}
	}

	var num_drives = randi() % 4 + 1
	var used_letters = []

	used_letters.append("C:")
	filesystem["Drives"]["C:"] = {
		"EggApps": {
			"Egg Defender": generate_random_folder([], extensions, adjectives, nouns, 1),
			"Egg Office": generate_random_folder([], extensions, adjectives, nouns, 1),
			"Egg Browser": generate_random_folder([], extensions, adjectives, nouns, 1),
		},
		"EggApps (x86)": {
			"Steam": generate_random_folder([], extensions, adjectives, nouns, 1),
			"Common Files": generate_random_folder([], extensions, adjectives, nouns, 1),
		},
		"Chickens": {
			"Public": {
				"Public Nests": generate_random_folder([], extensions, adjectives, nouns, 1),
				"Public Eggs": generate_random_folder([], extensions, adjectives, nouns, 1),
				"Public Clucks": generate_random_folder([], extensions, adjectives, nouns, 1),
			},
			"Chicken": {
				"Roost": generate_random_folder([], extensions, adjectives, nouns, 1),
				"Nests": generate_random_folder([], extensions, adjectives, nouns, 1),
				"Eggs": generate_random_folder([], extensions, adjectives, nouns, 1),
				"Feathers": generate_random_folder([], extensions, adjectives, nouns, 1),
				"Clucks": generate_random_folder([], extensions, adjectives, nouns, 1),
				"Pecks": generate_random_folder([], extensions, adjectives, nouns, 1),
			}
		},
		"EggOS": {
			"Coop32": generate_random_folder([], extensions, adjectives, nouns, 1),
			"HenHouse": generate_random_folder([], extensions, adjectives, nouns, 1),
			"EggLogs": generate_random_folder([], extensions, adjectives, nouns, 1),
		},
		"CluckLogs": generate_random_folder([], extensions, adjectives, nouns, 1),
		"HenHouse": generate_random_folder([], extensions, adjectives, nouns, 1),
	}

	for _i in range(1, num_drives):
		var available_letters = drive_letters.filter(func(letter): return letter not in used_letters)
		if available_letters.size() > 0:
			var drive_letter = available_letters[randi() % available_letters.size()]
			used_letters.append(drive_letter)

			filesystem["Drives"][drive_letter] = {
				"EggBackups": generate_random_folder([], extensions, adjectives, nouns, 1),
				"EggGames": generate_random_folder([], extensions, adjectives, nouns, 1),
				"EggProjects": generate_random_folder([], extensions, adjectives, nouns, 1),
			}

	# --- Generate Virus File Name ---
	var virus_id = str(randi() % 1000)
	var virus_suffix = ["trojan", "worm", "spy", "stealer", "keylogger", "dropper", "hack", "horse"]
	var virus_file_name = "Virus_" + virus_suffix[randi() % virus_suffix.size()] + "_" + virus_id + ".exe"
	self.virus_file_name = virus_file_name

	# --- Place Virus Randomly ---
	var current_folder = filesystem["Drives"]["C:"]
	var depth = randi() % 3 + 1
	var path = ["Drives", "C:"]

	for i in range(depth):
		var folder_keys = current_folder.keys()
		var subfolders = folder_keys.filter(func(k): return typeof(current_folder[k]) == TYPE_DICTIONARY)
		if subfolders.size() == 0:
			break
		var random_folder = subfolders[randi() % subfolders.size()]
		current_folder = current_folder[random_folder]
		path.append(random_folder)

	current_folder[virus_file_name] = null
	self.virus_file_path = path + [virus_file_name]
	print(virus_file_path)

	return filesystem

func generate_random_folder(folders: Array, extensions: Array, adjectives: Array, nouns: Array, max_depth: int, current_depth: int = 0) -> Dictionary:
	var result = {}

	if current_depth >= max_depth:
		return result

	var subfolder_count = randi() % 3 + 1 if current_depth < max_depth - 1 else 0
	for i in range(subfolder_count):
		if folders.size() > 0:
			var folder_index = randi() % folders.size()
			var folder_name = folders[folder_index]
			folders.remove_at(folder_index)
			result[folder_name] = generate_random_folder(folders, extensions, adjectives, nouns, max_depth, current_depth + 1)

	var file_count = randi() % 5 + 2
	for i in range(file_count):
		var file_name = ""
		if randf() < 0.8:
			file_name = adjectives[randi() % adjectives.size()] + "_" + nouns[randi() % nouns.size()]
		else:
			var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
			for j in range(randi() % 8 + 3):
				file_name += chars[randi() % chars.length()]

		file_name += extensions[randi() % extensions.size()]
		result[file_name] = null

	return result

func get_sidebar_shortcuts() -> Array:
	var shortcuts = []

	shortcuts.append(["Drives"])

	var chicken_path = ["Drives", "C:", "Chickens", "Chicken"]
	var current = data
	for part in chicken_path:
		if not current.has(part):
			return shortcuts
		current = current[part]

	for folder in current.keys():
		if typeof(current[folder]) == TYPE_DICTIONARY:
			shortcuts.append(chicken_path + [folder])

	return shortcuts

func get_current_folder() -> Dictionary:
	var folder = data
	for part in current_path:
		folder = folder[part]
	return folder

func go_back(calling_script):
	if current_path.size() > 1:
		current_path.pop_back()
		calling_script.update_ui()

func delete_file(name: String, calling_script):
	var folder = get_current_folder()
	if name == virus_file_name:
		Events.virus_deleted.emit()
	else:
		Global.score -= 5

	if Global.score < 5 and name != virus_file_name:
		print("NOT ENOUGH POINTS")
		return

	folder.erase(name)
	calling_script.update_ui()
