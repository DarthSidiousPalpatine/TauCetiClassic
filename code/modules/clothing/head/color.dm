/datum/proc/hueshing(h)
	var/H = h
	var/V = 100
	var/S = 100
	var/Hi = round(H/60)%6
	var/Vmin = (100-S)*V/100
	var/a = (V-Vmin)*(H%60)/60
	var/Vinc = Vmin + a
	var/Vdec = V-a
	switch(Hi)
		if(0)
			return rgb(V*2.55, Vinc*2.55, Vmin*2.55)
		if(1)
			return rgb(Vdec*2.55, V*2.55, Vmin*2.55)
		if(2)
			return rgb(Vmin*2.55, V*2.55, Vinc*2.55)
		if(3)
			return rgb(Vmin*2.55, Vdec*2.55, V*2.55)
		if(4)
			return rgb(Vinc*2.55, Vmin*2.55, V*2.55)
		if(5)
			return rgb(V*2.55, Vmin*2.55, Vdec*2.55)

/datum/proc/huespin(h)
	var/matrix[3][3]
	matrix[1][1] = cos(h)+(1-cos(h))/3
	matrix[1][2] = 0.33*(1-cos(h))-sqrt(0.33)*sin(h)
	matrix[1][3] = 0.33*(1-cos(h))+sqrt(0.33)*sin(h)
	matrix[2][1] = 0.33*(1-cos(h))+sqrt(0.33)*sin(h)
	matrix[2][2] = cos(h)+0.33*(1-cos(h))
	matrix[2][3] = 0.33*(1-cos(h))-sqrt(0.33)*sin(h)
	matrix[3][1] = 0.33*(1-cos(h))-sqrt(0.33)*sin(h)
	matrix[3][2] = 0.33*(1-cos(h))+sqrt(0.33)*sin(h)
	matrix[3][3] = cos(h)+0.33*(1-cos(h))
	return list(matrix[1][1],matrix[1][2],matrix[1][3], matrix[2][1],matrix[2][2],matrix[2][3], matrix[3][1],matrix[3][2],matrix[3][3], 0,0,0)
