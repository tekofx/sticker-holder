extends Node2D
@onready var next_page_button: Button = $UI/Control/HBoxContainer/NextPageButton
@onready var add_button: Button = $UI/Control/HBoxContainer/AddButton
@onready var prev_page_button: Button = $UI/Control/HBoxContainer/PrevPageButton
@onready var save_button: Button = $UI/Control/HBoxContainer/SaveButton
@onready var page: Page = $Page
@onready var file_dialog = $FileDialog

func _ready() -> void:
	#add_button.pressed.connect(page.add_sticker)
	add_button.pressed.connect(_on_add_click)
	save_button.pressed.connect(save_game)
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.add_filter("*.png", "PNG Images")
	file_dialog.add_filter("*.jpg", "JPEG Images")
	file_dialog.add_filter("*.jpeg", "JPEG Images")
	file_dialog.add_filter("*.webp", "WebP Images")
	file_dialog.add_filter("*.svg", "SVG Images")   
	file_dialog.connect("file_selected", _on_file_selected)
	load_game()
	

func _on_add_click():
	file_dialog.show()

func _on_file_selected(path):
	print(path)
	var img = Image.new()
	var err = img.load(path)
	if err != OK:
		push_error("Failed to load image")
		return
	
	# Convert to ImageTexture
	var texture = ImageTexture.create_from_image(img)
	
	# Apply to a Sprite2D or Custom Node for processing
	page.add_sticker(texture)
	#detect_edges_and_mask(img)  
func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
