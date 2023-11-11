extends Node

const FILE_NAME = "user://save.tres"

func load_data() -> SavedData:
	if ResourceLoader.exists(FILE_NAME):
		var data = ResourceLoader.load(FILE_NAME)
		if data is SavedData:
			return data
	print("SAVING FILE DOES NOT EXIST - RETURNING DEFAULT DATA")
	return SavedData.new()

func save_data(data: SavedData):
	var result = ResourceSaver.save(data, FILE_NAME)
	if result != OK:
		print("WARNING!! FAILED TO PERSIST GAME DATA IN FILE")
