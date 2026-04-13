extends TextureRect

var input: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match input:
		"0":
			texture = preload("res://Assets/Letters/0.png")
		"1":
			texture = preload("res://Assets/Letters/1.png")
		"2":
			texture = preload("res://Assets/Letters/2.png")
		"3":
			texture = preload("res://Assets/Letters/3.png")
		"4":
			texture = preload("res://Assets/Letters/4.png")
		"5":
			texture = preload("res://Assets/Letters/5.png")
		"6":
			texture = preload("res://Assets/Letters/6.png")
		"7":
			texture = preload("res://Assets/Letters/7.png")
		"8":
			texture = preload("res://Assets/Letters/8.png")
		"9":
			texture = preload("res://Assets/Letters/9.png")
		"a":
			texture = preload("res://Assets/Letters/A.png")
		"b":
			texture = preload("res://Assets/Letters/B.png")
		"c":
			texture = preload("res://Assets/Letters/C.png")
		"d":
			texture = preload("res://Assets/Letters/D.png")
		"e":
			texture = preload("res://Assets/Letters/E.png")
		"f":
			texture = preload("res://Assets/Letters/F.png")
		"g":
			texture = preload("res://Assets/Letters/G.png")
		"h":
			texture = preload("res://Assets/Letters/H.png")
		"i":
			texture = preload("res://Assets/Letters/I.png")
		"j":
			texture = preload("res://Assets/Letters/J.png")
		"k":
			texture = preload("res://Assets/Letters/K.png")
		"l":
			texture = preload("res://Assets/Letters/L.png")
		"m":
			texture = preload("res://Assets/Letters/M.png")
		"n":
			texture = preload("res://Assets/Letters/N.png")
		"o":
			texture = preload("res://Assets/Letters/O.png")
		"p":
			texture = preload("res://Assets/Letters/P.png")
		"q":
			texture = preload("res://Assets/Letters/Q.png")
		"r":
			texture = preload("res://Assets/Letters/R.png")
		"s":
			texture = preload("res://Assets/Letters/S.png")
		"t":
			texture = preload("res://Assets/Letters/T.png")
		"u":
			texture = preload("res://Assets/Letters/U.png")
		"v":
			texture = preload("res://Assets/Letters/V.png")
		"w":
			texture = preload("res://Assets/Letters/W.png")
		"x":
			texture = preload("res://Assets/Letters/X.png")
		"y":
			texture = preload("res://Assets/Letters/Y.png")
		"z":
			texture = preload("res://Assets/Letters/Z.png")
