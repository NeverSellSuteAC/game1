extends Line2D

onready var tween = $Tween

var atkStartPosition = null
var drawPosition = null
var atkEndPosition = null

var drawList = []
var speed = 1500

var yieldTime = 0.8
var tweenTime = 0.8
var modulateValue = 1
func _ready():
	self.add_point(atkStartPosition)
	pass # Replace with function body.

var direction = null
var dieTime = 3
func _physics_process(delta):
	dieTime -= delta
	if dieTime <= 0:
		self.queue_free()
	var direction = (atkEndPosition - atkStartPosition).normalized()
	if self.direction == null or self.direction.is_equal_approx(direction): 
		var addPosition = direction * delta * speed
#		drawLine(addPosition)
#		update()
		addPoint(addPosition)
		self.direction = direction
	else:
#		yield(get_tree().create_timer(yieldTime), "timeout")
		self.queueFree()
	if modulateValue > 0 and modulateValue < 1:
		self.modulate = Color(1,1,1,modulateValue)
	elif modulateValue == 0:
		self.queue_free()
	



func addPoint(addPosition):
	atkStartPosition += addPosition
	self.add_point(atkStartPosition)

func drawLine(addPosition):
	drawPosition = atkStartPosition + addPosition
	drawList.append({
		"start" : atkStartPosition,
		"end" : drawPosition,
	})

func _draw():
	if drawPosition == null:
		return
	
#	var i:float = 2
#	for positionObj in drawList:
#		draw_line(positionObj.start, positionObj.end, Color(1,1,1,1), i, true)
#		i += 0.2
	draw_line(atkStartPosition, drawPosition, Color(1,1,1,1), 10, true)
	atkStartPosition = drawPosition

func setData(atkStartPosition, atkEndPosition):
	self.atkStartPosition = atkStartPosition
	self.atkEndPosition = atkEndPosition

func queueFree():
	tween.interpolate_property(self, "modulateValue", modulateValue, 0, tweenTime, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()

