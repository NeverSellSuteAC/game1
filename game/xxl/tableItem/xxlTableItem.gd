extends PanelContainer

onready var boder = $ItemBorder
onready var imgText = $ItemBorder/ItemImg
onready var tween = $Tween

var defaultImg = load("res://img/item_bg.png")

var data = {
	"color" : Color(0.2, 0.6, 0.8, 1),
	"img":defaultImg
}

var oldPosition = rect_position
var firstMove = true;
var moveDirection = null
var moveDirectionValue = null

var tweenTime = 0.15
var is_tween = "null"
var directionPosition = 0

func _ready():
#	如果要手动调整每格大小,就用这个
#	setScale(data.scale,data.scale)
	setBoderColor()
	imgText['texture'] = data.img
	rect_position.x = data.position_x
	rect_position.y = data.position_y
	rect_size.x = 100
	rect_size.y = 100
	oldPosition = rect_position

#	如果要手动调整每格大小,就用这个
func setScale(width,height):
	yield(get_tree(),"idle_frame")
	rect_scale = Vector2(width,height)


func setData(data):
	if data != null :
		self.data = data


func setBoderColor():
	boder['custom_styles/panel']['border_color'] = data.color

func _physics_process(delta):
	if is_tween == "start" and moveDirection != null:
#		print(data)
#		print(moveDirection)
#		print(directionPosition)
		
		var direction = oldPosition
		if moveDirection == "x":
			direction.x += directionPosition
		else :
			direction.y += directionPosition
		rect_position = direction
	if is_tween == "start" and (abs(directionPosition) == 100 or directionPosition == 0):
		moveDirection = null
		firstMove = true;
		is_tween = "end"
		oldPosition = rect_position



func _on_TableBorder_gui_input(event):
	# 初次点击
	if is_tween != "start" and Input.is_action_pressed("mouse_click") and !XxlConfig.mouse_clik and XxlConfig.mouse_start_position == null and XxlConfig.mouse_clik_node == null:
		XxlConfig.mouse_clik = true
		XxlConfig.mouse_start_position = get_global_mouse_position()
		XxlConfig.mouse_clik_node = self
		oldPosition = rect_position
		var ff = get_parent().get_parent()
		get_parent().remove_child(self)
		ff.get_node("xxlTableUp").add_child(self)
		print(data)
	# 松开鼠标
	# 本来是想在这做松开鼠标的判断,但是发现有问题,只能在最上层做松开时候的判断了
#	if !Input.is_action_pressed("mouse_click") and XxlConfig.mouse_clik and XxlConfig.mouse_start_position != null and XxlConfig.mouse_clik_node == self:
#		XxlConfig.mouse_clik = false
#		XxlConfig.mouse_start_position = null
#		XxlConfig.mouse_clik_node = null
#		var ff = get_parent().get_parent()
#		get_parent().remove_child(self)
#		ff.get_node("xxlTable").add_child(self)
	# 点击鼠标拖拽移动
	# 移动也是一样的,只能在最上层做操作了
#	if Input.is_action_pressed("mouse_click") and XxlConfig.mouse_clik and XxlConfig.mouse_start_position != null and XxlConfig.mouse_clik_node == self:
#		pass
	pass # Replace with function body.

func move():

	var nowPosition = get_global_mouse_position()
	var startPosition = XxlConfig.mouse_start_position
	var x = nowPosition.x - startPosition.x
	var y = nowPosition.y - startPosition.y		
	var abs_x = abs(x)
	var abs_y = abs(y)
	# 边缘移动判定
	if data.x == 0 and x < 0:
		x = 0
	# 边缘移动判定
	if data.x == 8 and x > 0:
		x = 0
	# 边缘移动判定
	if data.y == 0 and y < 0:
		y = 0
	# 边缘移动判定
	if data.y == 8 and y > 0:
		y = 0
	# 位移太小时先不动
	if abs_x < 20 and abs_y < 20 and firstMove:
		return

	var direction = oldPosition
	if firstMove :
		if abs_x > abs_y:
			if x > 100:
				x = 100
			if x < -100:
				x = -100
			direction.x += x
			moveDirection = "x"
			directionPosition = x
		if abs_x < abs_y:
			if y > 100:
				y = 100
			if y < -100:
				y = -100
			direction.y += y
			moveDirection = "y"
			directionPosition = y
	else:
		if moveDirection == "x":
			if x > 100:
				x = 100
			if x < -100:
				x = -100
			direction.x += x
			directionPosition = x
		else :
			if y > 100:
				y = 100
			if y < -100:
				y = -100
			direction.y += y
			directionPosition = y
	rect_position = direction
	firstMove = false

func passiveMove(moveDirection,directionPosition):
	self.moveDirection = moveDirection
	self.directionPosition = -directionPosition
	var direction = oldPosition
	if moveDirection == "x":
		direction.x -= directionPosition
	else :
		direction.y -= directionPosition
	rect_position = direction

func moveEnd(targetNode):
	var ff = get_parent().get_parent()
	get_parent().remove_child(XxlConfig.mouse_clik_node)
	ff.get_node("xxlTable").add_child(XxlConfig.mouse_clik_node)
	
#	XxlConfig.mouse_clik = false
#	XxlConfig.mouse_start_position = null
#	XxlConfig.mouse_clik_node = null
	
	if targetNode == null:
		return
	# 移动判定 确定移动后进行消除判定
	var x = rect_position.x - oldPosition.x
	var y = rect_position.y - oldPosition.y
	var targetNode_x = targetNode.rect_position.x - targetNode.oldPosition.x
	var targetNode_y = targetNode.rect_position.y - targetNode.oldPosition.y
	var abs_x = abs(x)
	var abs_y = abs(y)
	var status = true
	if moveDirection == "x":
		if x > 50:
			tweenStart(x,100)
			targetNode.tweenStart(targetNode_x,-100)
		elif x < -50:
			tweenStart(x,-100)
			targetNode.tweenStart(targetNode_x,100)
		else:
			tweenStart(x,0)
			targetNode.tweenStart(targetNode_x,0)
			status = false
	else :
		if y > 50:
			tweenStart(y,100)
			targetNode.tweenStart(targetNode_y,-100)
		elif y < -50:
			tweenStart(y,-100)
			targetNode.tweenStart(targetNode_y,100)
		else:
			tweenStart(y,0)
			targetNode.tweenStart(targetNode_y,0)
			status = false
	return status

func tweenStart(start,end):
	is_tween = "start"
	tween.interpolate_property(self, "directionPosition", start, end, tweenTime)
	if not tween.is_active():
		tween.start()

func positionRest():
	pass








