extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var nameText = $PanelContainer/PanelContainer/VBoxContainer/name
onready var describeText = $PanelContainer/PanelContainer/VBoxContainer/text

var data = {
	
}
# Called when the node enters the scene tree for the first time.
# 初始化信息展示
func _ready():
	nameText.text = data.name
	describeText.text = data.describe
	pass # Replace with function body.

# 设置展示数据
func setData(data):
	self.data = data
	pass

# 跟随移动
func _physics_process(delta):
	global_position = get_global_mouse_position()
	global_position.x -= 2
	global_position.y -= 2
	if global_position.x < 200:
		global_position.x = 200
		
		
		
		
		
		
		
		
