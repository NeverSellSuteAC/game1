extends MarginContainer

onready var number_label = $HBoxContainer/Bars/LifeBar/Count/Background/Number
onready var bar = $HBoxContainer/Bars/LifeBar/TextureProgress
onready var tween = $Tween

var animated_health = 0
var animated_exp = 0

onready var exp_number_label = $HBoxContainer/Bars/EnergyBar/Count/Background/Number
onready var exp_bar = $HBoxContainer/Bars/EnergyBar/TextureProgress

onready var level_number_label = $HBoxContainer/Bars/EnergyBar/Count2/Background/Number

func _ready():
	# 生命值显示初始化
	var player_max_health = PlayerData.health_max
	bar["max_value"] = player_max_health
	update_health(PlayerData.health)
	# 经验显示初始化
	var player_max_exp = PlayerData.exp_max
	exp_bar["max_value"] = player_max_exp
	update_exp(PlayerData.exp_now)
	# 等级显示初始化
	level_number_label.text = str(PlayerData.level)


func _on_Player_health_changed(player_health):
	update_health(player_health)


func update_health(new_value):
	tween.interpolate_property(self, "animated_health", animated_health, new_value, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()


func update_exp(new_value):
	tween.interpolate_property(self, "animated_exp", animated_exp, new_value, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
		tween.start()


func update_level(new_level):
	level_number_label.text = str(new_level)


func _process(delta):
	var round_value = round(animated_health)
	number_label.text = str(round_value)
	bar.value = round_value
	
	var round_value_exp = round(animated_exp)
	exp_number_label.text = str(round_value_exp)
	exp_bar.value = round_value_exp


func _on_Player_died():
	var start_color = Color(1.0, 1.0, 1.0, 1.0)
	var end_color = Color(1.0, 1.0, 1.0, 0.0)
	tween.interpolate_property(self, "modulate", start_color, end_color, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)


func _on_Node2D_health_update(health_new):
	update_health(health_new)


var exp_update_state = true

func _on_Node2D_exp_update(exp_new):
	if exp_update_state:
		update_exp(exp_new)
	else:
		exp_update_state = true


func _on_Node2D_level_update(level):
	update_level(level) # Replace with function body.


func _on_Node2D_exp_max_update():
	exp_update_state = false
	var player_max_exp = PlayerData.exp_max
	exp_bar["max_value"] = player_max_exp
	update_exp(PlayerData.exp_now)
	
	


func _on_exp_TextureProgress_mouse_entered():
	$HBoxContainer/Bars/EnergyBar/TextureProgress/Label["text"] = str(exp_bar.value) + "/" + str(exp_bar["max_value"])
	$HBoxContainer/Bars/EnergyBar/TextureProgress/Label["modulate"] = Color(1, 0, 0, 1)


func _on_exp_TextureProgress_mouse_exited():
	$HBoxContainer/Bars/EnergyBar/TextureProgress/Label["modulate"] = Color(1, 1, 1, 0)


func _on_hp_TextureProgress_mouse_entered():
	$HBoxContainer/Bars/LifeBar/TextureProgress/Label["text"] = str(bar.value) + "/" + str(bar["max_value"])
	$HBoxContainer/Bars/LifeBar/TextureProgress/Label["modulate"] = Color(1, 0, 0, 1)


func _on_hp_TextureProgress_mouse_exited():
	$HBoxContainer/Bars/LifeBar/TextureProgress/Label["modulate"] = Color(1, 1, 1, 0)


func _on_Node2D_health_max_update():
	bar["max_value"] = PlayerData.base["生命"]
