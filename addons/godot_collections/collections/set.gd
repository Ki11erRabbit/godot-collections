class_name Set extends Collection
var map: Dictionary

func add(item: Variant) -> void:
	map[item] = 1
	
func remove(item: Variant) -> bool:
	return map.erase(item)

func size() -> int:
	return map.size()

func clear() -> void:
	map.clear()

func contains(item: Variant) -> bool:
	return map.get(item) != null

func iter() -> SetIterator:
	return SetIterator.new(self)

func collect(item: Variant) -> void:
	add(item)

func difference(other: Set) -> Difference:
	return Difference.new(self.iter(), other)

func symmetric_difference(other: Set) -> SymmetricDifference:
	return SymmetricDifference.new(self, other)

func intesection(other: Set) -> Intersection:
	return Intersection.new(self.iter(), other)

func union(other: Set) -> Union:
	return Union.new(self, other)

func is_disjoint(other: Set) -> bool:
	var iter = intesection(other)
	var next_item = iter.next()
	return next_item == null

func is_subset(other: Set) -> bool:
	return iter().map(func(item):
		return other.contains(item)).all(func(item: bool): return item)

func is_superset(other: Set) -> bool:
	return other.iter().map(func(item):
		return self.contains(item)).all(func(item: bool): return item)

class SetIterator extends Iterator:
	var items: Array
	var index: int = 0
	
	func _init(set: Set) -> void:
		self.items = set.map.keys()
	
	func next() -> Variant:
		if index >= items.size():
			return null
		var out = items[index]
		index += 1
		return out

class Difference extends Iterator:
	var iter: SetIterator
	var set: Set
	
	func _init(iter: SetIterator, set: Set) -> void:
		self.iter = iter
		self.set = set
	
	func next() -> Variant:
		var next_item = iter.next()
		while next_item != null:
			if set.contains(next_item):
				next_item = iter.next()
				continue
			break
		return next_item

class SymmetricDifference extends Iterator:
	var iter1: SetIterator
	var set1: Set
	var iter2: SetIterator
	var set2: Set
	
	func _init(set1: Set, set2: Set) -> void:
		iter1 = set1.iter()
		self.set1 = set1
		
		iter2 = set2.iter()
		self.set2 = set2
	
	func next() -> Variant:
		var next_item = iter1.next()
		while next_item != null:
			if set2.contains(next_item):
				next_item = iter1.next()
				continue
			return next_item
		next_item = iter2.next()
		while next_item != null:
			if set1.contains(next_item):
				next_item = iter2.next()
				continue
			return next_item
		return null
	
class Intersection extends Iterator:
	var iter: SetIterator
	var set: Set
	
	func _init(iter: SetIterator, set: Set) -> void:
		self.iter = iter
		self.set = set
	
	func next() -> Variant:
		var next_item = iter.next()
		while next_item != null:
			if set.contains(next_item):
				return next_item
			next_item = iter.next()
		return next_item

class Union extends Iterator:
	var iter1: SetIterator
	var iter2: SetIterator
	var seen: Set = Set.new()
	
	func _init(set1: Set, set2: Set) -> void:
		iter1 = set1.iter()
		iter2 = set2.iter()
	
	func next() -> Variant:
		var next_item = iter1.next()
		if next_item != null:
			seen.add(next_item)
			return next_item
		next_item = iter2.next()
		while next_item != null:
			if seen.contains(next_item):
				next_item = iter2.next()
				continue
			return next_item
		return null
	
