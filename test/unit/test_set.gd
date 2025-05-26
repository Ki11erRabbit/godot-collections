extends GutTest


func test_creation():
	var set = Set.new()
	assert_ne(set, null)

func test_set_add():
	var set = Set.new()
	set.add(2)
	assert_true(set.contains(2))

func test_set_remove():
	var set = Set.new()
	set.add(2)
	set.remove(2)
	assert_eq(set.size(), 0)

func test_set_collect():
	var set = Set.new()
	var iter = ArrayIterator.new([1,1,2,3,3])
	
	iter.collect(set)
	var array = set.iter().collect_array()
	array.sort()
	assert_eq_deep(array, [1, 2, 3])

func test_set_intersection():
	var set1 = Set.new()
	ArrayIterator.new([1,2,3,4]).collect(set1)
	var set2 = Set.new()
	ArrayIterator.new([2, 4]).collect(set2)
	
	var intersection = set1.intesection(set2).collect_array()
	intersection.sort()
	
	assert_eq_deep(intersection, [2, 4])

func test_set_difference():
	var set1 = Set.new()
	ArrayIterator.new([1,2,3,4]).collect(set1)
	var set2 = Set.new()
	ArrayIterator.new([2, 4]).collect(set2)
	
	var difference = set1.difference(set2).collect_array()
	difference.sort()
	
	assert_eq_deep(difference, [1, 3])

func test_set_union():
	var set1 = Set.new()
	ArrayIterator.new([1,2,3,4]).collect(set1)
	var set2 = Set.new()
	ArrayIterator.new([4, 5]).collect(set2)
	
	var union = set1.union(set2).collect_array()
	union.sort()
	
	assert_eq_deep(union, [1,2,3,4,5])

func test_set_symmetric_difference():
	var set1 = Set.new()
	ArrayIterator.new([1,2,3,4]).collect(set1)
	var set2 = Set.new()
	ArrayIterator.new([2, 4, 5]).collect(set2)
	
	var difference = set1.symmetric_difference(set2).collect_array()
	difference.sort()
	
	assert_eq_deep(difference, [1, 3, 5])
