class_name FileSystem
extends Resource

@export var data: Dictionary = {
	"Drives": {
		"C:": {
			"Users": {
				"Admin": {
					"Documents": {
						"text.txt": null
					}
				}
			}
		}
	}
}
var current_path: Array = ["Drives"]

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
	if name == "VirusFile_39x2.exe":
		print("YOU FOUND AND DELETED THE VIRUS!")
	folder.erase(name)
	calling_script.update_ui()
