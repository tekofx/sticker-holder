extends CanvasLayer
class_name UI
# Buttons
@onready var add_button: Button = $PanelContainer/HBoxContainer/AddButton
@onready var save_button: Button = $PanelContainer/HBoxContainer/SaveButton
@onready var next_page_button: Button = $PanelContainer/HBoxContainer/NextPageButton
@onready var prev_page_button: Button = $PanelContainer/HBoxContainer/PrevPageButton

@onready var file_dialog: FileDialog = $FileDialog

# Base reference resolution (e.g., your design resolution)
@export var base_resolution: Vector2 = Vector2(1080, 1920)
# Base font size used at base resolution
@export var base_font_size: int = 60

func _ready() -> void:
	_on_screen_resized()
	add_button.pressed.connect(_on_add_click)
	save_button.pressed.connect(SaveManager.save_game)
	file_dialog.connect("file_selected", _on_file_selected)

func _on_add_click():
	file_dialog.show()

func _on_file_selected(path):
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
	
	
func _on_screen_resized():
	var current_size = get_viewport().size
	var scale_factor = current_size.x / base_resolution.x
	var scaled_size = base_font_size * scale_factor

	# Optionally clamp to avoid extreme sizes
	#scaled_size = clamp(scaled_size, 30, 200)

	# Apply the new font size
	add_button.add_theme_font_size_override("font_size", int(scaled_size))
	save_button.add_theme_font_size_override("font_size", int(scaled_size))
	next_page_button.add_theme_font_size_override("font_size", int(scaled_size))
	prev_page_button.add_theme_font_size_override("font_size", int(scaled_size))
	
