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
	
	currentMaxHP = calculateHPMP(baseMaxHP)
	currentMaxMP = calculateHPMP(baseMaxMP)
	
	ATK = calculateStat(baseATK)
	SPD = calculateStat(baseSPD)
	DEF = calculateStat(baseDEF)
	MAG = calculateStat(baseMAG)
	MDEF = calculateStat(baseMDEF)
	
func calculateHPMP(stat: int) -> int:
	return ((2*stat*level)/100) + 10 + level

func calculateStat(stat) -> int:
	return ((2*stat*level)/100) + 5	

func printAllStats() -> void:
	print(currentMaxHP,currentMaxMP,ATK,SPD,DEF,MAG,MDEF)
