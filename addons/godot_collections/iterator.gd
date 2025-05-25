class_name Iterator extends Object

func next() -> Variant:
	return null

func enumerate() -> EnumeratedIterator:
	return EnumeratedIterator.new(self)

func zip(other: Iterator) -> ZippedIterator:
	return ZippedIterator.new(self, other)

func map(function: Callable) -> MappedIterator:
	return MappedIterator.new(self, function)

func filter(predecate: Callable) -> FilteredIterator:
	return FilteredIterator.new(self, predecate)

func foreach(body: Callable) -> void:
	var next_item = next()
	while next_item != null:
		body.call(next_item)
		next_item = next()

func collect(collection: Collection) -> void:
	var next_item = next()
	while next_item != null:
		collection.collect(next_item)
		next_item = next()

func collect_array() -> Array:
	var out: Array = []
	var next_item = next()
	while next_item != null:
		out.append(next_item)
		next_item = next()
	return out

func all(predecate: Callable) -> bool:
	var next_item = next()
	while next_item != null:
		if not predecate.call(next_item):
			return false
		next_item = next()
	return true

func any(predecate: Callable) -> bool:
	var next_item = next()
	while next_item != null:
		if predecate.call(next_item):
			return true
		next_item = next()
	return false

func find(predecate: Callable) -> Variant:
	var next_item = next()
	while next_item != null:
		if predecate.call(next_item):
			return next_item
		next_item = next()
	return null

func max() -> Variant:
	var max = next()
	var next_item = next()
	while next_item != null:
		if max < next_item:
			max = next_item
		next_item = next()
	return max

func min() -> Variant:
	var min = next()
	var next_item = next()
	while next_item != null:
		if min > next_item:
			min = next_item
		next_item = next()
	return min

func sum() -> Variant:
	var sum = 0
	var next_item = next()
	while next_item != null:
		sum += next_item
	
	return sum

func product() -> Variant:
	var product = 1
	var next_item = next()
	while next_item != null:
		product *= next_item
	
	return product

class ArrayIterator extends Iterator:
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

class DictionaryIterator extends Iterator:
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

class EnumeratedIterator extends Iterator:
	var iter: Iterator
	var index: int = 0
	
	func _init(iter: Iterator) -> void:
		self.iter = iter
	
	func next() -> Variant:
		var next_item = iter.next()
		if next_item == null:
			return null
		var out = [index, next_item]
		index += 1
		return out

class ZippedIterator extends Iterator:
	var iter: Iterator
	var other: Iterator
	
	func _init(iter: Iterator, other: Iterator) -> void:
		self.iter = iter
		self.other = other

	func next() -> Variant:
		var next_item = iter.next()
		if next_item == null:
			return null
		
		var next_other_item = other.next()
		if next_other_item == null:
			return null
		
		return [next_item, next_other_item]

class MappedIterator extends Iterator:
	var iter: Iterator
	var function: Callable
	
	func _init(iter: Iterator, function: Callable) -> void:
		self.iter = iter
		self.function = function

	func next() -> Variant:
		var next_item = iter.next()
		if next_item == null:
			return null
		
		return function.call(next_item)

class FilteredIterator extends Iterator:
	var iter: Iterator
	var predecate: Callable
	
	func _init(iter: Iterator, predecate: Callable) -> void:
		self.iter = iter
		self.predecate = predecate

	func next() -> Variant:
		var next_item = iter.next()
		while true:
			if next_item == null:
				return null
			if predecate.call(next_item):
				return next_item
		return null
