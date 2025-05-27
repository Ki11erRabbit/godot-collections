class_name ArrayList extends Collection

var buffer: Array = []
var length: int = 0
var resize_factor: float = 1.618 # Golden ratio 


static func from_array(array: Array) -> ArrayList:
	var list: ArrayList = ArrayList.new()
	list.buffer = array
	list.length = array.size()
	return list

static func initialize(size: int, method: Callable) -> ArrayList:
	var list: ArrayList = ArrayList.new()
	list.buffer.resize(size)
	list.length = size
	for i in size:
		list.buffer[i] = method.call(i)
	return list

func resize() -> void:
	var size: int = buffer.size()
	if size == 0:
		size = 1
	var new_size: int = int(ceil(size * resize_factor))
	buffer.resize(new_size)

func resize_if_needed(extra_elements: int) -> void:
	if length == buffer.size() or (extra_elements + length) > buffer.size():
		resize()

func set_resize_factor(factor: float) -> void:
	resize_factor = factor

func clear() -> void:
	for i in length:
		buffer[i] = null
	length = 0

func push(value: Variant) -> void:
	resize_if_needed(1)
	buffer[length] = value
	length += 1

func pop() -> Variant:
	length -= 1
	var out = buffer[length]
	buffer[length] = null
	return out

func at(index: int) -> Variant:
	return buffer[index]

func set_at(index: int, value: Variant) -> void:
	buffer[index] = value

func size() -> int:
	return length

func capacity() -> int:
	return buffer.size()

func iter() -> Iterator:
	return ArrayListIterator.new(self)

func extend(iter: Iterator) -> void:
	var next_item = iter.next()
	while next_item != null:
		push(next_item)

func collect(item: Variant) -> void:
	push(item)

class ArrayListIterator extends DoubleEndedIterator:
	var list: ArrayList
	var index: int = 0
	func _init(list: ArrayList) -> void:
		self.list = list
	
	func next() -> Variant:
		if index >= list.size():
			return null
		var out = list.at(index)
		index += 1
		return out
	
	func prev() -> Variant:
		index -= 1
		if index <= 0:
			index = 0
			return null
		return list.at(index)
