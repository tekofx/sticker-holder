extends CharacterBody2D
class_name Sticker

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var page: int = 0
@export var sticker_id: int = randi()

var draggable:bool = false
var offset = Vector2.ZERO
var shadow:Sprite2D = null

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
			var tween = create_tween().set_parallel(true)
			tween.tween_property(self, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_SPRING)
			tween.tween_property(shadow, "scale", Vector2(0.2,0.2),0.2).set_trans(Tween.TRANS_SPRING)
			tween.finished.connect(func(): remove_child(shadow))
			
		else:
			InteractionManager.set_sticker_moving(sticker_id)
			shadow = sprite_2d.duplicate()
			shadow.modulate=Color(0,0,0,0.2)
			shadow.z_index=0
			add_child(shadow)
			
			var tween = create_tween().set_parallel(true)
			tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_SPRING)
			tween.tween_property(shadow, "scale", Vector2(0.23,0.23),0.2).set_trans(Tween.TRANS_SPRING)
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
