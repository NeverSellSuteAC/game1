extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var ball = load("res://atk/test/2/RigidBody2D.tscn")
onready var platform = load("res://atk/test/2/StaticBody2D.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var c90 = PI/4

func _on_Node2D_gui_input(event):
	# 鼠标点击监听 sqrt
	if event.is_action_released("mouse_click"):
		var position = get_global_mouse_position()
		
		var a = c90
		
		var platformObj = platform.instance()
		self.add_child(platformObj)
		platformObj.global_position = position
		
		var ballObj = ball.instance()
		self.add_child(ballObj)
		
		
		var v = getVelocity(a, position)
		print(v)
		var vx = v * cos(a)
		var vy = v * sin(a)

		var x = position.x
		vx = x / 5
		ballObj.linear_velocity.x = x / 5
		var y = position.y
		print("y:" + str(y))
		vy = (-y + 225) /5
		ballObj.linear_velocity.y -= vy
		
		print(vx)
		print(vy)
		print(ballObj.linear_velocity)
		pass


func getVelocity(a, position):
	var b = 2 * (cos(a) * (sin(a) / 10))
	
	var c = position.x
	
	var v = sqrt(c / b)
	
	return v
	
	

	
	
	
	
	
	
	
	
	
	
	
