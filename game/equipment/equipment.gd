extends Node2D


onready var right = $PanelContainer/VBoxContainer/HBoxContainer/right
onready var left = $PanelContainer/VBoxContainer/HBoxContainer/left
onready var tableItem = load("res://TableItem/TableItem.tscn")

func _ready():
	initData()

func initData():
	
	var itemObj
	var i = 0
	for item in PlayerData.equipmentList["right"]:
		itemObj = createItem(item)
		right.add_child(itemObj)
		itemObj.data.x = "right"
		itemObj.data.y = i
		itemObj.itemType = "equipment"
		PlayerData.equipmentList["right"][i] = itemObj.data
		PlayerData.equipmentItemList["right"][i] = itemObj
		i += 1
	i = 0
	for item in PlayerData.equipmentList["left"]:
		itemObj = createItem(item)
		left.add_child(itemObj)
		itemObj.data.x = "left"
		itemObj.data.y = i
		itemObj.itemType = "equipment"
		PlayerData.equipmentList["left"][i] = itemObj.data
		PlayerData.equipmentItemList["left"][i] = itemObj
		i += 1

#"margin_left"
func createItem(data):
	var itemInstance = tableItem.instance()
	itemInstance.SetData(data)
	itemInstance["size_flags_horizontal"] = 0
	itemInstance["margin_left"] = 300
	return itemInstance
