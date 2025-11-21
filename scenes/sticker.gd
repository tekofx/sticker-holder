extends CharacterBody2D
class_name Sticker

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var page: int = 0
@export var sticker_id: int = randi()

var draggable:bool = false
var offset = Vector2.ZERO

func _ready() -> void:
	area_2d.input_event.connect(on_click)
	var viewport_size = get_viewport_rect().size
	global_position = Vector2(viewport_size.x/2, viewport_size.y/2)

func _process(_delta: float) -> void:
	if draggable:
		var pos = get_global_mouse_position() - offset
		var viewport = get_viewport_rect()
		var sticker_size = sprite_2d.get_rect().size*sprite_2d.scale
		global_position = Vector2(
			clamp(pos.x, viewport.position.x + sticker_size.x/2, viewport.end.x - sticker_size.x/2),
			clamp(pos.y, viewport.position.y + sticker_size.y/2, viewport.end.y - sticker_size.y/2)
		)
	
func on_click(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	
	if event.is_action_pressed("left_click"):
		
		if InteractionManager.STICKER_MOVING!=sticker_id and InteractionManager.STICKER_MOVING!=-1:
			return
		
		if draggable:
			InteractionManager.set_sticker_moving(-1)
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
			
		else:
			InteractionManager.set_sticker_moving(sticker_id)
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1)
		draggable=!draggable
		offset = get_global_mouse_position() - global_position
			
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"page" : page,
		"sticker_id": sticker_id,
	}
	return save_dict
