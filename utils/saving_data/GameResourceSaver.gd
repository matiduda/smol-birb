extends Node

const FILE_NAME = "user://save.tres"

func load_data() -> SavedData:
	if ResourceLoader.exists(FILE_NAME):
		var data = ResourceLoader.load(FILE_NAME)
		if data is SavedData:
			return data
	print("FAILED TO LOAD DATA - RETURNING DEFAULT")
	return SavedData.new()

func save_data(data: SavedData):
	var result = ResourceSaver.save(data, FILE_NAME)
	if result != OK:
		print("WARNING!! FAILED TO PERSIST GAME DATA IN FILE")
