extends CanvasLayer
class_name UI
# Buttons
@onready var add_button: Button = $PanelContainer/HBoxContainer/AddButton
@onready var file_dialog: FileDialog = $FileDialog

@onready var save_button: Button = $PanelContainer/HBoxContainer/SaveButton
func _ready() -> void:
	add_button.pressed.connect(_on_add_click)
	save_button.pressed.connect(SaveManager.save_game)
	
	file_dialog.connect("file_selected", _on_file_selected)


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
	var page_node:Page = get_parent().get_child(1)
	page_node.add_sticker(texture)
	
	# Apply to a Sprite2D or Custom Node for processing
	#page.add_sticker(texture)
	#detect_edges_and_mask(img) 
