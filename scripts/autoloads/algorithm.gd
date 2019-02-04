extends Node

func fill_slots(fill:int, slots:Array):
	# initialize n
	var n = len(slots)
	
	while true:
		# base case: fill < 0
		if fill < 0:
			return(null)
		
		# initialize result_slots
		var result_slots:Array = []
		for i in range(len(slots)):
			result_slots.append(0)
		
		# base case: fill == 0
		if fill == 0:
			return({'fill': 0, 'slots': result_slots})
		
		# base case: too much fill
		var max_fill:int = 0
		for val in slots:
			var increment:int = int(val)
			max_fill += increment
		if fill >= max_fill:
			return({'fill': fill - max_fill, 'slots': slots})
		
		# calculate average and remainder
		var avg:int = int(fill) / int(n)
		var rem:int = int(fill) % int(n)
		
		# base case: not enough fill
		if (int(n) > int(fill)) and (int(fill) > 0) and (int(avg) == 0):
			for i in range(len(slots)):
				var i_ = int(i)
				if int(result_slots[i_]) > int(slots[i_]):
					continue
				
				if rem == 0:
					break
				
				rem -= 1
				result_slots[i] += 1
			return({'fill': rem, 'slots': result_slots})
			
		# distribute
		for i in range(len(slots)):
			var space = slots[i] - result_slots[i]
			if space == 0:
				continue
			if avg >= space:
				n -= 1
				result_slots[i] = slots[i]
				rem += avg - space
			else:
				result_slots[i] += avg
		fill = rem




















