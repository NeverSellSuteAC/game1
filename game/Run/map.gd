extends Node2D



signal exp_update
signal base_update
signal health_update
signal health_max_update
signal level_update
signal exp_max_update

onready var fox = load("res://Run/fox.tscn")
onready var table = load("res://TableItem/ItemColumn.tscn")
onready var equipment = load("res://equipment/equipment.tscn")
onready var player = $run/Player

var mo_max_number = Config.mo_max_number
var mo_number = Config.mo_number
var mo_time = Config.mo_time
var mo_process_time = Config.mo_process_time
var deal_mo_sum = PlayerData.deal_mo_sum
var screen_size
var player_speed = 400

var table_open_state = false
var equipment_open_state = false
var tableObj = null
var equipmentObj = null

var guiList = {}

func _ready():
	screen_size = get_viewport_rect().size
	openTable(Color(0,0,0,0))
	openEquipmentGrid(Color(0,0,0,0))
	randomize()

var table_time = 0
func _process(delta):
	table_time += delta
	# 生成怪
	mo_process_time += delta
	if (mo_number != mo_max_number) and mo_process_time >= mo_time:
		create_mo()
		mo_process_time = 0
	if Input.is_action_pressed("open_table") and table_time > 0.2:
		if table_open_state:
			closeTable()
		else:
			table_open_state = true
			table_time = 0
			openTable(Color(1,1,1,1))
	if Input.is_action_pressed("open_equipment") and table_time > 0.2:
		if equipment_open_state:
			closeEquipmentGrid()
		else:
			equipment_open_state = true
			table_time = 0
			openEquipmentGrid(Color(1,1,1,1))
	if Input.is_action_pressed("esc") and table_time > 0.2:
		table_time = 0
		closeTableEsc()
		
func closeTableEsc():
	var list = []
	for key in guiList:
		list.append({"obj":guiList[key],"key":key})
	if list.size() == 0:
		return
	var closeObj = list[list.size()-1]
	match closeObj.key:
		"table":
			closeTable()
		"equipment":
			closeEquipmentGrid()
	
		
# 打开装备栏 equipment
func openEquipmentGrid(color):
	if equipmentObj != null:
		equipmentObj["modulate"] = color
		equipmentObj.position.x = screen_size.x * 0.04
		equipmentObj.position.y = screen_size.y * 0.14
	else:
		equipmentObj = equipment.instance()
		screen_size = get_viewport_rect().size
		equipmentObj.position.x = screen_size.x * 10
		equipmentObj.position.y = screen_size.y * 10
		$gui.add_child(equipmentObj)
		equipmentObj["modulate"] = color
	guiList["equipment"] = equipmentObj

# 打开道具栏
func openTable(color):
	if tableObj != null:
		tableObj["modulate"] = color
		tableObj.position.x = screen_size.x * 0.5
		tableObj.position.y = screen_size.y * 0.1
	else:
		tableObj = table.instance()
		screen_size = get_viewport_rect().size
		tableObj.position.x = screen_size.x * 11
		tableObj.position.y = screen_size.y * 11
		tableObj.setData(PlayerData.dataList)
		$gui.add_child(tableObj)
		tableObj["modulate"] = color
	guiList["table"] = equipmentObj

# 关闭装备栏
func closeEquipmentGrid():
	equipment_open_state = false
	table_time = 0
#	equipmentObj.queue_free()
#	equipmentObj = null
	equipmentObj["modulate"] = Color(0,0,0,0)
	equipmentObj.position.x = screen_size.x * 10
	equipmentObj.position.y = screen_size.y * 10
	# 消除information
	var items = get_tree().get_nodes_in_group("informationPanel")
	for item in items:
		item.queue_free()
	guiList.erase("equipment")
	
# 关闭道具栏"modulate"
func closeTable():
	table_open_state = false
	table_time = 0
#	tableObj.queue_free()
#	tableObj = null
	tableObj["modulate"] = Color(0,0,0,0)
	tableObj.position.x = screen_size.x * 11
	tableObj.position.y = screen_size.y * 11
	# 消除information
	var items = get_tree().get_nodes_in_group("informationPanel")
	for item in items:
		item.queue_free()
	guiList.erase("table")


# 生成怪物
func create_mo():
	var fox_mo = fox.instance()
	fox_mo.position.x = randi() % 1600
	fox_mo.position.y = randi() % 900
	fox_mo.set_face_player($run/Player)
	fox_mo.atk_open = true
	fox_mo.game_type = "mo"
	$run.add_child(fox_mo)
	mo_number += 1


func _on_Node2D_exp_update(new_exp):
	var updateData = { "player_exp":new_exp }
	player.updatePlayerData(updateData)
	pass # Replace with function body.


func _on_Node2D_base_update():
	var updateData = { "base":0 }
	player.updatePlayerData(updateData)
	pass # Replace with function body.

var atk = null
func _atkRun(area2d):
	print("啊啊啊啊")
#	get_tree().change_scene("res://atk/atk.tscn")
	if atk != null:
		return
	atk = load("res://atk/atk.tscn").instance()
	get_tree().current_scene.get_node("atk").add_child(atk)
