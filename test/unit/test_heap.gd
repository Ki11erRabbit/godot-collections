extends GutTest

func test_heapify():
	var heap = Heap.from_iterator(ArrayIterator.new([1, 2, 3, 4]))
	
	assert_eq(heap.min(), 1)
	assert_eq(heap.max(), 4)

func test_insertion():
	var heap = Heap.new()
	heap.add(1)
	heap.add(2)
	heap.add(3)
	heap.add(4)
	
	assert_eq(heap.min(), 1)
	assert_eq(heap.max(), 4)

func test_insertion_and_deletion():
	var heap = Heap.new()
	heap.add(1)
	heap.add(2)
	heap.add(3)
	heap.add(4)
	
	assert_eq(heap.pop_min(), 1)
	assert_eq(heap.pop_max(), 4)
	
	assert_eq(heap.min(), 2)
	assert_eq(heap.max(), 3)
	
func test_insertion_and_deletion_interspersed():
	var heap = Heap.new()
	heap.add(1)
	heap.add(2)
	assert_eq(heap.pop_min(), 1)
	heap.add(3)
	assert_eq(heap.pop_max(), 3)
	heap.add(4)
	
	assert_eq(heap.min(), 2)
	assert_eq(heap.max(), 4)

func test_iterator():
	var heap = Heap.from_iterator(ArrayIterator.new([1, 2, 3, 4]))
	var iter = heap.iter()
	
	assert_eq(iter.next(), 1)
	assert_eq(iter.prev(), 4)
	assert_eq(iter.next(), 2)
	assert_eq(iter.next(), 3)
