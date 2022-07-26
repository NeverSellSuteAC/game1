extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var border = $Border
onready var vBox = $Border/VBox
onready var title = $Border/VBox/TableName
onready var table = $Border/VBox/Table
onready var item = load("res://TableItem/TableItem.tscn")


var dataList = []
var itemList = PlayerData.tableItemList
var pageSize = 5

func _ready():
	InitItemColumn(5,5)

func InitItemColumn(width,height):
	table.columns = width
	pageSize = height
	
	for i in range(0, width):
		var itemWidthList = []
		itemList.append(itemWidthList)
		for j in range(0, height):
			var tempItem
			var tempData = dataList[i][j]
			if tempData != null and tempData.size() != 0:
				tempItem = createItem(dataList[i][j])
			else:
				tempItem = createItem(null)
			tempItem.data.x = i
			tempItem.data.y = j
			tempItem.itemType = "table"
			table.add_child(tempItem)
			itemWidthList.append(tempItem)


func createItem(data):
	var itemInstance = item.instance()
	itemInstance.SetData(data)
	return itemInstance


func setData(data):
	self.dataList = data


func _on_Border_mouse_exited():
	if PlayerData.moveTemp != null and !Config.mouse_click_move:
		PlayerData.moveTemp = null
		pass # Replace with function body.
