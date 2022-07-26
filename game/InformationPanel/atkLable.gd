extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var life_time
var life_max_time = 0.6
var hiden_time = 0.3
var is_hiden = false

var text = ""

onready var lable = $Label
onready var tween = $Tween


func _ready():
	life_time = 0
	lable.text = str(text)
	pass # Replace with function body.


func _process(delta):
	life_time += delta
	if !is_hiden and life_time >= life_max_time:
		is_hiden = true
		update_hiden()
	if is_hiden:
		lable["custom_colors/font_color"] = Color(0.82,0.04,0.04,font_color_gradual_change)
	if font_color_gradual_change == 0:
		hiden()


var font_color_gradual_change = 1
func update_hiden():
	tween.interpolate_property(self, "font_color_gradual_change", font_color_gradual_change, 0, hiden_time)
	if not tween.is_active():
		tween.start()


func hiden():
	queue_free()

func setText(text):
	self.text = text
