extends CharacterBody2D
class_name Sticker

var draggable:bool = false
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.input_event.connect(on_click)
	area_2d.mouse_entered.connect(on_mouse_enter)
	area_2d.mouse_exited.connect(on_mouse_exit)
	
	
func _process(delta: float) -> void:
	if draggable:
		self.global_position=get_global_mouse_position()
	

func on_click(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		print("Clicked")
		draggable=!draggable

func on_mouse_enter():
	print("enter")
	self.scale=Vector2(1.05,1.05)

func on_mouse_exit():
	print("exit")
	self.scale=Vector2(1,1)
