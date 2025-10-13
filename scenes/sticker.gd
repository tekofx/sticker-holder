extends CharacterBody2D
class_name Sticker

var draggable:bool = false
@onready var area_2d: Area2D = $Area2D
var offset = Vector2.ZERO


func _ready() -> void:
	area_2d.input_event.connect(on_click)
	
func _process(delta: float) -> void:
	if draggable:
		global_position = get_global_mouse_position() - offset
	
func on_click(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		
		if draggable:
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
			
		else:
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1)
		draggable=!draggable
		offset = get_global_mouse_position() - global_position
			
