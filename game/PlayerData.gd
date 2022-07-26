extends Node


export var health = 100
export var health_max = 100
export var exp_now = 0
export var exp_max = 80
export var level = 1
export var deal_mo_sum = 0

var player_speed = Config.player_dog_default_speed
var player_atk_time = Config.player_dog_default_atk_time
var player_atk = Config.player_dog_default_atk
# 移动对象临时引用
var moveTemp = null
var base = {
	"护甲":0,
	"攻击":Config.player_dog_default_atk,
	"生命":100,
	"等级":0,
	"速度":Config.player_dog_default_speed,
	"魔法":0
}
# 背包数据
var dataList = [
	[
		{
		"base": {
			"护甲":1,
			"攻击":2,
			"生命":4,
			"等级":3,
			"速度":1,
			"魔法":6
		},
		"color": Color(0.2, 0.6, 0.8, 1),
		"img": load("res://img/bombs_icon.png"),
		"level": 1,
		"name": "真 * 神 * 极 * 板砖",
		"num": 1,
		"type": "armour"
	}, null, {
		"base": {
			"护甲":5,
			"攻击":1,
			"生命":40,
			"等级":3,
			"速度":1,
			"魔法":6
		},
		"color": Color(0.2, 0.6, 0.8, 1),
		"img": load("res://img/emeralds_icon.png"),
		"level": 4,
		"name": "真 * 神 * 极 * 板砖",
		"num": 4,
		"type": "armour"
	}, null, {
		"base": {
			"护甲":5,
			"攻击":2,
			"生命":4,
			"等级":3,
			"速度":1,
			"魔法":6
		},
		"color": Color(0.2, 0.6, 0.8, 1),
		"img": load("res://img/bombs_icon.png"),
		"level": 6,
		"name": "真 * 神 * 极 * 板砖",
		"num": 6,
		"type": "宝石"
	}],
	[{
		"base": {
			"护甲":5,
			"攻击":2,
			"生命":4,
			"等级":3,
			"速度":1,
			"魔法":6
		},
		"color": Color(0.2, 0.6, 0.8, 1),
		"img": load("res://img/emeralds_icon.png"),
		"level": 7,
		"name": "真 * 神 * 极 * 板砖",
		"num": 7,
		"type": "宝石"
	}, null, {
		"base": {
			"护甲":5,
			"攻击":2,
			"生命":4,
			"等级":3,
			"速度":1,
			"魔法":6
		},
		"color": Color(0.2, 0.6, 0.8, 1),
		"img": load("res://img/bombs_icon.png"),
		"level": 9,
		"name": "真 * 神 * 极 * 板砖",
		"num": 9,
		"type": "宝石"
	}, null, {
		"base": {
			"护甲":5,
			"攻击":2,
			"生命":4,
			"等级":3,
			"速度":1,
			"魔法":6
		},
		"color": Color(0.2, 0.6, 0.8, 1),
		"img": load("res://img/emeralds_icon.png"),
		"level": 11,
		"name": "真 * 神 * 极 * 板砖",
		"num": 11,
		"type": "宝石"
	}],
	[{
		"base": {
			"护甲":5,
			"攻击":2,
			"生命":4,
			"等级":3,
			"速度":1,
			"魔法":6
		},
		"color": Color(0.2, 0.6, 0.8, 1),
		"img": load("res://img/bombs_icon.png"),
		"level": 12,
		"name": "真 * 神 * 极 * 板砖",
		"num": 12,
		"type": "宝石"
	}, null, {
		"base": {
			"护甲":5,
			"攻击":2,
			"生命":4,
			"等级":3,
			"速度":1,
			"魔法":6
		},
		"color": Color(0.2, 0.6, 0.8, 1),
		"img": load("res://img/emeralds_icon.png"),
		"level": 14,
		"name": "真 * 神 * 极 * 板砖",
		"num": 14,
		"type": "宝石"
	}, null, {
		"base": {
			"护甲":5,
			"攻击":2,
			"生命":4,
			"等级":3,
			"速度":1,
			"魔法":6
		},
		"color": Color(0.2, 0.6, 0.8, 1),
		"img": load("res://img/bombs_icon.png"),
		"level": 16,
		"name": "真 * 神 * 极 * 板砖",
		"num": 16,
		"type": "宝石"
	}]
	,[null,null,null,null,null],[null,null,null,null,null]
]
var tableItemList = []
# 装备数据
var equipmentList = {
	"left":[null,null,null,null,null,null],
	"right":[null,null,null,null,null,null]
}
var equipmentItemList = {
	"left":[null,null,null,null,null,null],
	"right":[null,null,null,null,null,null]
}

var equipmentTypeList = {
	"left":["armour",null,null,null,null,null],
	"right":["arms",null,null,null,null,null]
}

var equipmentTypeStrList = {
	"armour":{
		"name" : "防具",
		"x":"left",
		"y":0,
	},
	"arms":{
		"name" : "武器",
		"x":"",
		"y":"",
	},
}



var skillList = {
	1:{
		"id" : 1,
		"level" : 5 ,
		"runCd" : 0,
	},
	2:{
		"id" : 2,
		"level" : 2 ,
		"runCd" : 0,
	},
	3:{
		"id" : 3,
		"level" : 1 ,
		"runCd" : 0,
	},
	4:{
		"id" : 4,
		"level" : 1 ,
		"runCd" : 0,
	},
	5:{
		"id" : 5,
		"level" : 1 ,
		"runCd" : 0,
	},
	6:{
		"id" : 6,
		"level" : 1 ,
		"runCd" : 0,
	},
}
