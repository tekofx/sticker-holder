extends Node2D
@onready var next_page_button: Button = $UI/Control/HBoxContainer/NextPageButton
@onready var add_button: Button = $UI/Control/HBoxContainer/AddButton
@onready var prev_page_button: Button = $UI/Control/HBoxContainer/PrevPageButton
@onready var page: Page = $Page


func _ready() -> void:
	add_button.pressed.connect(page.add_sticker)
