extends Area2D

@onready var villaintext:Label = $Label

var hitcount:int
func take_damage():
	hitcount += 1
	print("You hit me %d times" [hitcount])
