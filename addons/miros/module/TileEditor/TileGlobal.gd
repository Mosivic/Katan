extends Node

var currTileMap
var currTileMapRes
var currTileMapData:Dictionary

const tile_width = 64
const tile_heigh = 32
const tile_layer_heigh = 16

# 单位类型
enum UnitType{
	NULL,#0 
	TILE,#1 瓦块
	FX,#2 视觉效果
	CHARACTER,#3 人物
	WEAPON,#4 武器
	SPELL,#5 法术
	RANGE,#6 范围显示
}
