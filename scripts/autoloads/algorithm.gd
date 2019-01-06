extends Node

func fill_slots(fill, slots):
	# initialize n
	var n = len(slots)
	
	while true:
		# base case: fill < 0
		if fill < 0:
			return(null)
		
		# initialize result_slots
		var result_slots = []
		for i in range(len(slots)):
			result_slots.append(0)
		
		# base case: fill == 0
		if fill == 0:
			return({'fill': 0, 'slots': result_slots})
		
		# base case: too much fill
		var max_fill = 0
		for val in slots:
			max_fill += val
		if fill >= max_fill:
			return({'fill': fill - max_fill, 'slots': slots})
		
		# calculate average and remainder
		var avg = fill / n
		var rem = fill % n
		
		# base case: not enough fill
		if n > fill and fill > 0 and avg == 0:
			for i in range(len(slots)):
				if result_slots[i] > slots[i]:
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




















