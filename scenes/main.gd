extends Node2D

@onready var page: Page = $Page

func _ready() -> void:
	SaveManager.load_game()
