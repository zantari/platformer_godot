extends Node

var currentLvl = 0
var money = 0
var isHome = false





func addMoney(value):
	money+=value

func getMoney():
	return money

func addLevel():
	currentLvl+=1
	
func getLevel():
	return currentLvl
	
