extends CharacterBody2D
class_name Sticker

var draggable:bool = false
var is_inside_dropable:bool = false
@onready var area_2d: Area2D = $Area2D



func _ready() -> void:
	area_2d.input_event.connect(on_click)


func on_click(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	print(1)
	if event.is_action_pressed("left_click"):
		print("Clicked")
	
