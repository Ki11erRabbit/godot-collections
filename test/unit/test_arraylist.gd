extends GutTest

func test_from_array():
	var array = [1, 2, 3, 4]
	var list: ArrayList = ArrayList.from_array(array)
	
	assert_eq_deep(list.buffer, array)

func test_initialize():
	var list: ArrayList = ArrayList.initialize(4, func(i):
		return i + 1)
		
	assert_eq_deep(list.buffer, [1, 2, 3, 4])

func test_push():
	var list: ArrayList = ArrayList.new()
	
	list.push(0)
	assert_eq(list.at(0), 0)
	assert_eq(list.size(), 1)

func test_pop():
	var list: ArrayList = ArrayList.new()
	
	list.push(0)
	var popped = list.pop()
	assert_eq(popped, 0)
	assert_eq(list.size(), 0)

func test_arraylist_iterator():
	var array = [1, 2, 3, 4]
	var list: ArrayList = ArrayList.from_array(array)
	
	var iter_array: Array = list.iter().collect_array()
	
	assert_eq_deep(iter_array, array)

func test_arraylist_collect():
	var array = [1, 2, 3, 4]
	var list1: ArrayList = ArrayList.from_array(array)
	var list2: ArrayList = ArrayList.new()
	
	list1.iter().collect(list2)
	
	assert_eq_deep(list2.buffer, array)
