class_name DictionaryIterator extends Iterator
var dict: Dictionary
var keys: Array
var index: int = 0

func _init(dict: Dictionary) -> void:
	self.dict = dict
	self.keys = dict.keys()

func next() -> Variant:
	if index >= keys.size():
		return null
	var out = [keys[index] ,dict[keys[index]]]
	index += 1
	return out
