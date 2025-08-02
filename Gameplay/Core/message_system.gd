extends Resource
class_name MessageSystem

# TODO: capacity is hardcoded might want to change that
var buffer: RingBuffer = RingBuffer.new(128)

func send_message(msg: Message) -> void:
	buffer.append(msg)

func dispatch() -> void:
	while not buffer.empty():
		var msg = buffer.pop_front()

#region RingBuffer

class RingBuffer:
	var buffer: Array[Message]
	var start_idx: int
	var size: int
	
	func _init(capacity: int) -> void:
		if buffer.resize(capacity) != OK:
			push_error("Failed to preallocate buffer for ring buffer")
		
		start_idx = 0
		size = 0
	
	func append(msg: Message) -> void:
		if size >= buffer.size():
			push_error("Message system ring buffer overflow")
			return
		
		buffer[offset_idx(start_idx, size)] = msg
		size += 1
	
	func pop_front() -> Message:
		if self.empty():
			push_error("Trying to pop element from empty buffer")
			return null
		
		var result = buffer[start_idx]
		
		start_idx = offset_idx(start_idx, 1)
		size -= 1
		
		return result 
	
	func offset_idx(idx: int, offset: int) -> int:
		return (idx + buffer.size() + (offset % buffer.size())) % buffer.size()
	
	func empty() -> bool:
		return size == 0

#endregion
