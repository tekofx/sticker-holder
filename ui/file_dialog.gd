extends Node
# Add a FileDialog node to your scene
@onready var file_dialog = $FileDialog

func _ready():
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.connect("file_selected", _on_file_selected)
	add_child(file_dialog)

func _on_file_selected(path):
	var img = Image.new()
	var err = img.load(path)
	if err != OK:
		push_error("Failed to load image")
		return
	
	# Convert to ImageTexture
	var texture = ImageTexture.create_from_image(img)
	
	# Apply to a Sprite2D or Custom Node for processing
	$Sprite2D.texture = texture
	#detect_edges_and_mask(img)  
