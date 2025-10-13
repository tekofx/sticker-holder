extends CanvasLayer
class_name Page
@onready var stickers: Node2D = $Stickers
@onready var label: Label = $Label
@export var page_number: int = 0

const sticker = preload("res://scenes/sticker.tscn")

func _ready() -> void:
	pass
	
	#self.position.x = -width/2
	#self.position.y = -height/2

func add_sticker():
	stickers.add_child(sticker.instantiate())
