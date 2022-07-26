extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var patrent = get_node("..")
var game_type

func _ready():
	game_type = patrent.game_type


func on_Attacked(atk):
	patrent.on_Attacked(atk)
	
