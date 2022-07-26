extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var game_type = "atkBox"
var speed = 800
var atk = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	createPosition = position
	pass # Replace with function body.

func _physics_process(delta):
	if directionPosition != null and createPosition != null:
		move(delta)

func move(delta):
	var direction = directionPosition - createPosition
	direction = direction.normalized()
#	direction = direction.move_toward(direction, delta) 
	set_position(get_position() + direction * speed * delta)
	pass

# 移动目标方向
var directionPosition = null
var createPosition = null

func setDirection(directionPosition):
	self.directionPosition = directionPosition

var entered_num = 0
var entered_max_num = 0
func _on_Area2D_area_entered(area):
	if area.game_type == "mo":
		area.on_Attacked(atk)
		entered_num += 1
		if entered_max_num == 0 or entered_num == entered_max_num:
			queue_free()
