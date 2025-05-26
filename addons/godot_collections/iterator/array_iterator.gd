class_name ArrayIterator extends Iterator
var array: Array
var index: int = 0

func _init(array: Array) -> void:
	self.array = array

func next() -> Variant:
	if index >= array.size():
		return null
	var out = array[index]
	index += 1
	return out
