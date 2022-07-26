extends Node2D

onready var tableItem = load("res://xxl/tableItem/xxlTableItem.tscn")
onready var defaultImg = load("res://img/item_bg.png")
onready var zdImg = load("res://xxl/img/zd.png")
onready var bsImg = load("res://xxl/img/bs.png")
onready var img0 = load("res://xxl/img/0.png")
onready var img1 = load("res://xxl/img/1.png")
onready var img2 = load("res://xxl/img/2.png")
onready var img3 = load("res://xxl/img/3.png")
onready var img4 = load("res://xxl/img/4.png")
onready var img5 = load("res://xxl/img/5.png")
onready var imgList = [img0, img1, img2, img3, img4, img5]

onready var table = $main/table
onready var xxlTable = $main/xxlTable

var itemList = []
var dataList = []
var columns = 9

func _ready():
	# 随机种子
	randomize()
	initTable(columns)
	table.queue_free()

var targetNode = null
func _process(delta):
	if !Input.is_action_pressed("mouse_click") and (XxlConfig.mouse_clik or XxlConfig.mouse_start_position != null or XxlConfig.mouse_clik_node != null):
		var node = XxlConfig.mouse_clik_node
		if node.moveDirection == null:
			return
		var moveStatus = XxlConfig.mouse_clik_node.moveEnd(targetNode)
		var tweenTime = 0.15
		# 移动成功
		if moveStatus:
			itemList[node.data.x][node.data.y] = targetNode
			itemList[targetNode.data.x][targetNode.data.y] = node
			var x = targetNode.data.x
			var y = targetNode.data.y
			targetNode.data.x = node.data.x
			targetNode.data.y = node.data.y
			node.data.x = x
			node.data.y = y
			pass
		# 移动不成功
		else:
			pass
		# 延迟时间注销此值
		XxlConfig.mouse_clik = false
		XxlConfig.mouse_start_position = null
		XxlConfig.mouse_clik_node = null
		# 进行消除判断
		if moveStatus:
			checkTableData(node,targetNode,tweenTime)
	if Input.is_action_pressed("mouse_click") and XxlConfig.mouse_clik and XxlConfig.mouse_start_position != null and XxlConfig.mouse_clik_node != null:
		# 操作目标
		var node = XxlConfig.mouse_clik_node
		node.move()
		if node.moveDirection == null:
			return
		# 被影响目标
		var moveDirection = node.moveDirection
		var directionPosition = node.directionPosition
		
		if directionPosition == 0:
			return
		if moveDirection == "x":
			if directionPosition > 0:
				targetNode = itemList[node.data.x + 1][node.data.y]
			else:
				targetNode = itemList[node.data.x - 1][node.data.y]
			pass
		else:
			if directionPosition > 0:
				targetNode = itemList[node.data.x][node.data.y + 1]
			else:
				targetNode = itemList[node.data.x][node.data.y - 1]
		targetNode.passiveMove(moveDirection,directionPosition)
		
func initTable(num):
	initTableData(num)
	for i in range(0,num):
		var itemWidthList = []
		itemList.append(itemWidthList)
		for j in range(0,num):
			var itemData = dataList[i][j]
			var tempItem = createTableItem(itemData)
			xxlTable.add_child(tempItem) 
			itemWidthList.append(tempItem)


func initTableData(num):
	for x in range(0,num):
		var dataWidthList = []
		dataList.append(dataWidthList)
		for y in range(0,num):
			var data = newTableItemData(x,y)
			dataWidthList.append(data)


func newTableItemData(x,y):
	var imgNumber = randi()%6
	var img =  imgList[imgNumber]
	var data = {
			"color" : Color(0.2, 0.6, 0.8, 1),
#			"img":defaultImg,
			"img":img,
			"imgNumber": imgNumber,
			"scale":0.6,
			"x":x,
			"y":y,
			"position_x":x*100,
			"position_y":y*100,
		}
	return data

func checkData(node):
	var nodeX = 0
	var nodeY = 0
	var nodeXList = []
	var nodeYList = []
	if node.data.x >= 1 and itemList[node.data.x - 1][node.data.y].data.imgNumber == node.data.imgNumber:
		nodeX += 1
		nodeXList.append(itemList[node.data.x - 1][node.data.y])
		if node.data.x >= 2 and itemList[node.data.x - 2][node.data.y].data.imgNumber == node.data.imgNumber:
			nodeX += 1
			nodeXList.append(itemList[node.data.x - 2][node.data.y])
	if node.data.x <= columns - 2 and itemList[node.data.x + 1][node.data.y].data.imgNumber == node.data.imgNumber:
		nodeX += 1
		nodeXList.append(itemList[node.data.x + 1][node.data.y])
		if node.data.x <= columns - 3 and itemList[node.data.x + 2][node.data.y].data.imgNumber == node.data.imgNumber:
			nodeX += 1
			nodeXList.append(itemList[node.data.x + 2][node.data.y])
	if node.data.y >= 1 and  itemList[node.data.x][node.data.y - 1].data.imgNumber == node.data.imgNumber:
		nodeY += 1
		nodeYList.append(itemList[node.data.x][node.data.y - 1])
		if node.data.y >= 2 and  itemList[node.data.x][node.data.y - 2].data.imgNumber == node.data.imgNumber:
			nodeY += 1
			nodeYList.append(itemList[node.data.x][node.data.y - 2])
	if node.data.y <= columns - 2 and itemList[node.data.x][node.data.y + 1].data.imgNumber == node.data.imgNumber:
		nodeY += 1
		nodeYList.append(itemList[node.data.x][node.data.y + 1])
		if node.data.y <= columns - 3 and itemList[node.data.x][node.data.y + 2].data.imgNumber == node.data.imgNumber:
			nodeY += 1
			nodeYList.append(itemList[node.data.x][node.data.y + 2])
	return {
		"nodeX" : nodeX,
		"nodeY" : nodeY,
		"nodeXList" : nodeXList,
		"nodeYList" : nodeYList,
	}

func checkTableData(node,targetNode,tweenTime):
	yield(get_tree().create_timer(tweenTime), "timeout")
	print(node)
	print(targetNode)
	var nodeData = checkData(node)
	var targetNodeData = checkData(targetNode)
	
	var xList = []
	var yList = []
	
	print("nodeX:" + str(nodeData.nodeX))
	print("nodeY:" + str(nodeData.nodeY))
	if nodeData.nodeX >= 2:
		for el in nodeData.nodeXList:
			xList.append(el)
			xList.append(node)
	if nodeData.nodeY >= 2:
		for el in nodeData.nodeYList:
			yList.append(el)
			yList.append(node)
	
	print("targetNodeData nodeX:" + str(targetNodeData.nodeX))
	print("targetNodeData nodeY:" + str(targetNodeData.nodeY))
	if targetNodeData.nodeX >= 2:
		for el in targetNodeData.nodeXList:
			xList.append(el)
			xList.append(targetNode)
	if targetNodeData.nodeY >= 2:
		for el in targetNodeData.nodeYList:
			yList.append(el)
			yList.append(targetNode)
	tableItemQueue(xList,yList)

func tableItemQueue(xList,yList):
	if xList.size() > 0:
		
		pass
	if yList.size() > 0:
		pass
	pass

func createTableItem(data):
	var itemInstance = tableItem.instance()
	itemInstance.setData(data)
	return itemInstance

