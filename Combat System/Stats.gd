class_name characterStats
extends Resource

@export var baseMaxHP: int
@export var baseMaxMP: int

@export var baseATK: int
@export var baseSPD: int
@export var baseDEF: int
@export var baseMAG: int
@export var baseMDEF: int
@export var level: int

var currentMaxHP: int
var currentMaxMP: int

var currentHP: int
var currentMP: int

var ATK: int
var SPD: int
var DEF: int
var MAG: int
var MDEF: int

func calculate() -> void:
	
	currentMaxHP = calculateHPMP(baseMaxHP, level)
	currentMaxMP = calculateHPMP(baseMaxMP, level)
	
	ATK = calculateStat(baseATK, level)
	SPD = calculateStat(baseSPD, level)
	DEF = calculateStat(baseDEF,level)
	MAG = calculateStat(baseMAG,level)
	MDEF = calculateStat(baseMDEF, level)
	
func calculateHPMP(stat: int, level: int) -> int:
	return ((2*stat*level)/100) + 10 + level

func calculateStat(stat,level) -> int:
	return ((2*stat*level)/100) + 5	

func printAllStats() -> void:
	print(currentMaxHP,currentMaxMP,ATK,SPD,DEF,MAG,MDEF)
