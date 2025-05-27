class_name Heap extends Collection

var heap: Array = [null]
var size: int = 0
var resize_factor: float = 1.618 # Golden ratio 

static func shallow_copy(heap: Heap) -> Heap:
	var out_heap = Heap.new()
	out_heap.heap = heap.heap.duplicate()
	out_heap.size = heap.size
	out_heap.resize_factor = heap.resize_factor
	return out_heap

static func from_iterator(iter: Iterator) -> Heap:
	var heap = Heap.new()
	heap.heapify(iter)
	return heap

func heapify(iter: Iterator) -> void:
	var array = iter.collect_array()
	heap.append_array(array)
	size = array.size()
	balance()

func resize() -> void:
	var resize_size = size
	if resize_size == 0:
		resize_size = 1
	var new_size: int = int(ceil(resize_size * resize_factor)) + 1 # Adding 1 to leave space for extra slot that isn't used
	heap.resize(new_size)

func resize_if_needed(extra_elements: int) -> void:
	if size + 1 == heap.size() or (extra_elements + size + 1) > heap.size():
		resize()

func set_resize_factor(factor: float) -> void:
	resize_factor = factor

func parent(index: int)-> int:
	return index / 2

func is_root(index: int) -> bool:
	return index == 1

func swap(i: int, j: int) -> void:
	var temp = heap[i]
	heap[i] = heap[j]
	heap[j] = temp

func balance() -> void:
	var array = range(1, size + 1)
	array.reverse()
	for i in array:
		push_down(i)

func on_min_level(i: int) -> bool:
	return int(floor(log(i) / log(2))) % 2 == 0

func push_down(index: int) -> void:
	if on_min_level(index):
		push_down_min(index)
	else:
		push_down_max(index)

func push_down_min(index: int) -> void:
	if has_children(index):
		var pair = get_next_min(index)
		var min = pair[0]
		var grandchild = pair[1]
		if grandchild:
			if heap[min] < heap[index]:
				swap(min, index)
				if heap[min] > heap[parent(min)]:
					swap(parent(min), min)
				push_down(min)
		elif heap[min] < heap[index]:
			swap(min, index)

func push_down_max(index: int) -> void:
	if has_children(index):
		var pair = get_next_min(index)
		var min = pair[0]
		var grandchild = pair[1]
		if grandchild:
			if heap[min] > heap[index]:
				swap(min, index)
				if heap[min] < heap[parent(min)]:
					swap(parent(min), min)
				push_down(min)
		elif heap[min] > heap[index]:
			swap(min, index)

func has_children(index: int) -> bool:
	return (2 * index <= size) or (2 * index + 1 <= size)

func get_grandchildren_indices(index: int) -> Array:
	var child1_index = 2 * index
	var child2_index = 2 * index + 1
	var grandchild1_index = 2 * child1_index
	var grandchild2_index = 2 * child1_index + 1
	var grandchild3_index = 2 * child2_index
	var grandchild4_index = 2 * child2_index + 1
	
	return [grandchild1_index, grandchild2_index, grandchild3_index, grandchild4_index]

func get_next_min(index: int) -> Array:
	var min = heap[(2 * index)]
	var min_index = 2 * index
	if 2 * index + 1 < heap.size():
		var child2 = heap[2 * index + 1]
		if min > child2:
			min = child2
			min_index = 2 * index + 1
	var grandchild: bool = false
	
	var grandchildren_indices = get_grandchildren_indices(index)
	
	for i in grandchildren_indices:
		if i <= size:
			if min > heap[i]:
				min = heap[i]
				min_index = i
				grandchild = true
	return [min_index, grandchild]

func get_next_max(index: int) -> Array:
	var max = heap[(2 * index)]
	var max_index = 2 * index
	if 2 * index + 1 < heap.size():
		var child2 = heap[2 * index + 1]
		if max < child2:
			max = child2
			max_index = 2 * index + 1
	var grandchild: bool = false
	
	var grandchildren_indices = get_grandchildren_indices(index)
	
	for i in grandchildren_indices:
		if i <= size:
			if max < heap[i]:
				max = heap[i]
				max_index = i
				grandchild = true
	return [max_index, grandchild]

func push_up(index: int) -> void:
	if not is_root(index):
		if on_min_level(index):
			if heap[index] > heap[parent(index)]:
				swap(index, parent(index))
				push_up_max(parent(index))
			else:
				push_up_min(index)
		else:
			if heap[index] < heap[parent(index)]:
				swap(index, parent(index))
				push_up_min(parent(index))
			else:
				push_up_max(index)

func get_grandparent(index: int) -> Variant:
	if index <= 3:
		return null
	else:
		return index / 4

func push_up_min(index: int) -> void:
	var grandparent = get_grandparent(index)
	if grandparent != null:
		if heap[index] < heap[grandparent]:
			swap(index, grandparent)
			push_up_min(grandparent)

func push_up_max(index: int) -> void:
	var grandparent = get_grandparent(index)
	if grandparent != null:
		if heap[index] > heap[grandparent]:
			swap(index, grandparent)
			push_up_max(grandparent)

func add(item: Variant) -> void:
	resize_if_needed(1)
	heap[size + 1] = item
	size += 1
	push_up(size)

func min() -> Variant:
	if size == 0:
		return null
	return heap[1]

func max() -> Variant:
	if size == 0:
		return null
	var index = 0
	if size == 1:
		index = 1
	elif size == 2:
		index = 2
	elif heap[2] > heap[3]:
		index = 2
	else:
		index = 3
	return heap[index]

func pop_min() -> Variant:
	if size == 0:
		return null
	var min = heap[1]
	var last = heap[size]
	heap[1] = last
	heap[size] = null
	size -= 1
	push_down(1)
	return min

func pop_max() -> Variant:
	if size == 0:
		return null
	var index = 0
	if size == 1:
		index = 1
	elif size == 2:
		index = 2
	elif heap[2] > heap[3]:
		index = 2
	else:
		index = 3
	var max = heap[index]
	var last = heap[size]
	heap[index] = last
	heap[size] = null
	size -= 1
	push_down(index)
	return max

## This needs to be optimized so it isn't worse case O(n)
func update_key(key: Variant, new_key: Variant) -> void:
	var i = 1
	while size > i and heap[i] != key:
		i += 1
	if i != size:
		heap[i] = new_key
		swap(i, 1)
		push_down(i)

func collect(item: Variant) -> void:
	add(item)

## Returns an iterator over the collection
## The iterator is double ended which means that next will give the next min element and prev the next max element
func iter() -> HeapIterator:
	return HeapIterator.new(self)

class HeapIterator extends DoubleEndedIterator:
	var heap: Heap
	
	func _init(heap: Heap) -> void:
		self.heap = Heap.shallow_copy(heap)
	
	func next() -> Variant:
		return heap.pop_min()
	
	func prev() -> Variant:
		return heap.pop_max()
