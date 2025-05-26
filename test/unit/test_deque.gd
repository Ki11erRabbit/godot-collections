extends GutTest

func test_deque_creation():
	var deque = Deque.new()
	
	assert_eq(deque.size(), 0)

func test_push_front():
	var deque = Deque.new()
	deque.push_front(3)
	deque.push_front(2)
	deque.push_front(1)
	
	var array = deque.iter().collect_array()
	
	assert_eq_deep(array, [1, 2, 3])
	
func test_push_back():
	var deque = Deque.new()
	deque.push_back(1)
	deque.push_back(2)
	deque.push_back(3)
	
	var array = deque.iter().collect_array()
	
	assert_eq_deep(array, [1, 2, 3])

func test_pop_front():
	var deque = Deque.new()
	deque.push_front(3)
	deque.push_front(2)
	deque.push_front(1)
	
	assert_eq_deep(deque.pop_front(), 1)
	assert_eq_deep(deque.pop_front(), 2)
	assert_eq_deep(deque.pop_front(), 3)
	
func test_pop_back():
	var deque = Deque.new()
	deque.push_back(1)
	deque.push_back(2)
	deque.push_back(3)
	
	assert_eq(deque.pop_back(), 3)
	assert_eq(deque.pop_back(), 2)
	assert_eq(deque.pop_back(), 1)

func test_pushing():
	var deque = Deque.new()
	deque.push_front(2)
	deque.push_back(3)
	deque.push_front(1)
	
	var array = deque.iter().collect_array()
	
	assert_eq_deep(array, [1, 2, 3])

func test_popping():
	var deque = Deque.new()
	deque.push_front(2)
	deque.push_back(3)
	deque.push_front(1)
	
	assert_eq_deep(deque.pop_front(), 1)
	assert_eq_deep(deque.pop_back(), 3)
	assert_eq_deep(deque.pop_front(), 2)
