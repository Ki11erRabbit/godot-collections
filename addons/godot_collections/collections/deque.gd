class_name Deque extends Collection
var buffer: Array = []
var length: int = 0
var resize_factor: float = 1.618 # Golden ratio 
var head: int = 0
var tail: int = 0


static func from_array(array: Array) -> Deque:
	var list: Deque = Deque.new()
	list.buffer = array
	list.length = array.size()
	list.head = array.size()
	list.tail = array.size()
	return list

static func initialize(size: int, method: Callable) -> Deque:
	var list: Deque = Deque.new()
	list.buffer.resize(size)
	list.length = size
	for i in size:
		list.buffer[i] = method.call(i)
	list.head = size
	list.tail = size
	return list

func resize() -> void:
	var size: int = buffer.size()
	if size == 0:
		size = 1
	var new_size: int = int(ceil(size * resize_factor))
	var new_buffer = []
	new_buffer.resize(new_size)
	for i in length:
		new_buffer[i] = at(i)
	
	buffer = new_buffer
	head = new_size - 1
	tail = length

func resize_if_needed(extra_elements: int) -> void:
	if length == capacity() or (extra_elements + length) > capacity():
		resize()

func set_resize_factor(factor: float) -> void:
	resize_factor = factor

func clear() -> void:
	for i in length:
		buffer[i] = null
	length = 0
	head = 0
	tail = 0

func size() -> int:
	return length

func capacity() -> int:
	return buffer.size()

func front() -> Variant:
	if length == 0:
		return null
	return at(0)

func push_front(value: Variant) -> void:
	resize_if_needed(1)
	buffer[head] = value
	head = (head - 1) % capacity()
	length += 1

func pop_front() -> Variant:
	length -= 1
	head = (head + 1) % capacity()
	var out = buffer[head]
	buffer[head] = null
	return out

func back() -> Variant:
	if length == 0:
		return null
	return at(length)

func push_back(value: Variant) -> void:
	resize_if_needed(1)
	buffer[tail] = value
	tail = (tail + 1) % capacity()
	length += 1

func pop_back() -> Variant:
	length -= 1
	tail = (tail - 1) % capacity()
	var out = buffer[tail]
	buffer[tail] = null
	return out

func at(index: int) -> Variant:
	var real_index = (index + head + 1) % capacity()
	return buffer[real_index]

func set_at(index: int, value: Variant) -> void:
	var real_index = (index + head + 1) % capacity()
	buffer[real_index] = value

func extend_front(iter: Iterator) -> void:
	var next_item = iter.next()
	while next_item != null:
		push_front(next_item)

func extend_back(iter: Iterator) -> void:
	var next_item = iter.next()
	while next_item != null:
		push_back(next_item)

func collect(item: Variant) -> void:
	push_back(item)

func iter() -> DequeIterator:
	return DequeIterator.new(self)

class DequeIterator extends DoubleEndedIterator:
	var deque: Deque
	var index: int = 0
	
	func _init(deque: Deque) -> void:
		self.deque = deque
	
	func next() -> Variant:
		if index >= deque.size():
			return null
		var out = deque.at(index)
		index += 1
		return out
	
	func prev() -> Variant:
		if index < 0:
			return null
		var out = deque.at(index)
		index -= 1
		return out
