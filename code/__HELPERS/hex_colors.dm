#define HEX_VAL_RED(col)   hex2num(copytext(col, 2, 4))
#define HEX_VAL_GREEN(col) hex2num(copytext(col, 4, 6))
#define HEX_VAL_BLUE(col)  hex2num(copytext(col, 6, 8))
#define HEX_VAL_ALPHA(col) hex2num(copytext(col, 8, 10))

/proc/random_short_color()
	return "#" + random_string(3, global.hex_characters)

/proc/random_color()
	return "#" + random_string(6, global.hex_characters)

/proc/normalize_color(inphex) //normalize hex color and convert hex2num and num2hex

	var/rn_color
	var/gn_color
	var/bn_color
	var/rh_color
	var/gh_color
	var/bh_color
	var/final_hex
	rn_color = hex2num(copytext(inphex, 2,4))
	gn_color = hex2num(copytext(inphex, 4,6))
	bn_color = hex2num(copytext(inphex, 6,8))

	//Normalize color when RGB color shade is not less than the sum 180
	if((rn_color + gn_color + bn_color) < 180)
		if(rn_color < 60)
			rn_color += 60
		if(gn_color < 60)
			gn_color += 60
		if(bn_color < 60)
			bn_color += 60

	rh_color = num2hex(rn_color)
	gh_color = num2hex(gn_color)
	bh_color = num2hex(bn_color)

	//Set complete normalize hex color
	final_hex = "#" + rh_color + gh_color + bh_color
	return final_hex

/proc/adjust_brightness(color, value)
	if (!color) return "#ffffff"
	if (!value) return color

	var/list/RGB = ReadRGB(color)
	RGB[1] = clamp(RGB[1]+value,0,255)
	RGB[2] = clamp(RGB[2]+value,0,255)
	RGB[3] = clamp(RGB[3]+value,0,255)
	return rgb(RGB[1],RGB[2],RGB[3])

/proc/transform_color(hue_value, saturation_value, brightness_value)
	var/hue[5][5]
	hue[1][1] = cos(hue_value)+(1-cos(hue_value))/3
	hue[1][2] = 0.33*(1-cos(hue_value))-sqrt(0.33)*sin(hue_value)
	hue[1][3] = 0.33*(1-cos(hue_value))+sqrt(0.33)*sin(hue_value)
	hue[1][4] = 0
	hue[1][5] = 0
	hue[2][1] = 0.33*(1-cos(hue_value))+sqrt(0.33)*sin(hue_value)
	hue[2][2] = cos(hue_value)+0.33*(1-cos(hue_value))
	hue[2][3] = 0.33*(1-cos(hue_value))-sqrt(0.33)*sin(hue_value)
	hue[2][4] = 0
	hue[2][5] = 0
	hue[3][1] = 0.33*(1-cos(hue_value))-sqrt(0.33)*sin(hue_value)
	hue[3][2] = 0.33*(1-cos(hue_value))+sqrt(0.33)*sin(hue_value)
	hue[3][3] = cos(hue_value)+0.33*(1-cos(hue_value))
	hue[3][4] = 0
	hue[3][5] = 0
	hue[4][1] = 0
	hue[4][2] = 0
	hue[4][3] = 0
	hue[4][4] = 1
	hue[4][5] = 0
	hue[5][1] = 0
	hue[5][2] = 0
	hue[5][3] = 0
	hue[5][4] = 0
	hue[5][5] = 1

	var/sr = (1-saturation_value)*0.3086 //or 0.2125
	var/sg = (1-saturation_value)*0.6094 //or 0.7154
	var/sb = (1-saturation_value)*0.0820 //or 0.0721

	var/sat[5][5]
	sat[1][1] = sr+saturation_value
	sat[1][2] = sr
	sat[1][3] = sr
	sat[1][4] = 0
	sat[1][5] = 0
	sat[2][1] = sg
	sat[2][2] = sg+saturation_value
	sat[2][3] = sg
	sat[2][4] = 0
	sat[2][5] = 0
	sat[3][1] = sb
	sat[3][2] = sb
	sat[3][3] = sb+saturation_value
	sat[3][4] = 0
	sat[3][5] = 0
	sat[4][1] = 0
	sat[4][2] = 0
	sat[4][3] = 0
	sat[4][4] = 1
	sat[4][5] = 0
	sat[5][1] = 0
	sat[5][2] = 0
	sat[5][3] = 0
	sat[5][4] = 0
	sat[5][5] = 1

	var/bri[5][5]
	bri[1][1] = 1
	bri[1][2] = 0
	bri[1][3] = 0
	bri[1][4] = 0
	bri[1][5] = 0
	bri[2][1] = 0
	bri[2][2] = 1
	bri[2][3] = 0
	bri[2][4] = 0
	bri[2][5] = 0
	bri[3][1] = 0
	bri[3][2] = 0
	bri[3][3] = 1
	bri[3][4] = 0
	bri[3][5] = 0
	bri[4][1] = 0
	bri[4][2] = 0
	bri[4][3] = 0
	bri[4][4] = 1
	bri[4][5] = 0
	bri[5][1] = brightness_value
	bri[5][2] = brightness_value
	bri[5][3] = brightness_value
	bri[5][4] = 0
	bri[5][5] = 1

	var/onetwo[5][5]
	onetwo[1][1] = bri[1][1]*sat[1][1] + bri[1][2]*sat[2][1] + bri[1][3]*sat[3][1] + bri[1][4]*sat[4][1] + bri[1][5]*sat[5][1]
	onetwo[1][2] = bri[1][1]*sat[1][2] + bri[1][2]*sat[2][2] + bri[1][3]*sat[3][2] + bri[1][4]*sat[4][2] + bri[1][5]*sat[5][2]
	onetwo[1][3] = bri[1][1]*sat[1][3] + bri[1][2]*sat[2][3] + bri[1][3]*sat[3][3] + bri[1][4]*sat[4][3] + bri[1][5]*sat[5][3]
	onetwo[1][4] = bri[1][1]*sat[1][4] + bri[1][2]*sat[2][4] + bri[1][3]*sat[3][4] + bri[1][4]*sat[4][4] + bri[1][5]*sat[5][4]
	onetwo[1][5] = bri[1][1]*sat[1][5] + bri[1][2]*sat[2][5] + bri[1][3]*sat[3][5] + bri[1][4]*sat[4][5] + bri[1][5]*sat[5][5]

	onetwo[2][1] = bri[2][1]*sat[1][1] + bri[2][2]*sat[2][1] + bri[2][3]*sat[3][1] + bri[2][4]*sat[4][1] + bri[2][5]*sat[5][1]
	onetwo[2][2] = bri[2][1]*sat[1][2] + bri[2][2]*sat[2][2] + bri[2][3]*sat[3][2] + bri[2][4]*sat[4][2] + bri[2][5]*sat[5][2]
	onetwo[2][3] = bri[2][1]*sat[1][3] + bri[2][2]*sat[2][3] + bri[2][3]*sat[3][3] + bri[2][4]*sat[4][3] + bri[2][5]*sat[5][3]
	onetwo[2][4] = bri[2][1]*sat[1][4] + bri[2][2]*sat[2][4] + bri[2][3]*sat[3][4] + bri[2][4]*sat[4][4] + bri[2][5]*sat[5][4]
	onetwo[2][5] = bri[2][1]*sat[1][5] + bri[2][2]*sat[2][5] + bri[2][3]*sat[3][5] + bri[2][4]*sat[4][5] + bri[2][5]*sat[5][5]

	onetwo[3][1] = bri[3][1]*sat[1][1] + bri[3][2]*sat[2][1] + bri[3][3]*sat[3][1] + bri[3][4]*sat[4][1] + bri[3][5]*sat[5][1]
	onetwo[3][2] = bri[3][1]*sat[1][2] + bri[3][2]*sat[2][2] + bri[3][3]*sat[3][2] + bri[3][4]*sat[4][2] + bri[3][5]*sat[5][2]
	onetwo[3][3] = bri[3][1]*sat[1][3] + bri[3][2]*sat[2][3] + bri[3][3]*sat[3][3] + bri[3][4]*sat[4][3] + bri[3][5]*sat[5][3]
	onetwo[3][4] = bri[3][1]*sat[1][4] + bri[3][2]*sat[2][4] + bri[3][3]*sat[3][4] + bri[3][4]*sat[4][4] + bri[3][5]*sat[5][4]
	onetwo[3][5] = bri[3][1]*sat[1][5] + bri[3][2]*sat[2][5] + bri[3][3]*sat[3][5] + bri[3][4]*sat[4][5] + bri[3][5]*sat[5][5]

	onetwo[4][1] = bri[4][1]*sat[1][1] + bri[4][2]*sat[2][1] + bri[4][3]*sat[3][1] + bri[4][4]*sat[4][1] + bri[4][5]*sat[5][1]
	onetwo[4][2] = bri[4][1]*sat[1][2] + bri[4][2]*sat[2][2] + bri[4][3]*sat[3][2] + bri[4][4]*sat[4][2] + bri[4][5]*sat[5][2]
	onetwo[4][3] = bri[4][1]*sat[1][3] + bri[4][2]*sat[2][3] + bri[4][3]*sat[3][3] + bri[4][4]*sat[4][3] + bri[4][5]*sat[5][3]
	onetwo[4][4] = bri[4][1]*sat[1][4] + bri[4][2]*sat[2][4] + bri[4][3]*sat[3][4] + bri[4][4]*sat[4][4] + bri[4][5]*sat[5][4]
	onetwo[4][5] = bri[4][1]*sat[1][5] + bri[4][2]*sat[2][5] + bri[4][3]*sat[3][5] + bri[4][4]*sat[4][5] + bri[4][5]*sat[5][5]

	onetwo[5][1] = bri[5][1]*sat[1][1] + bri[5][2]*sat[2][1] + bri[5][3]*sat[3][1] + bri[5][4]*sat[4][1] + bri[5][5]*sat[5][1]
	onetwo[5][2] = bri[5][1]*sat[1][2] + bri[5][2]*sat[2][2] + bri[5][3]*sat[3][2] + bri[5][4]*sat[4][2] + bri[5][5]*sat[5][2]
	onetwo[5][3] = bri[5][1]*sat[1][3] + bri[5][2]*sat[2][3] + bri[5][3]*sat[3][3] + bri[5][4]*sat[4][3] + bri[5][5]*sat[5][3]
	onetwo[5][4] = bri[5][1]*sat[1][4] + bri[5][2]*sat[2][4] + bri[5][3]*sat[3][4] + bri[5][4]*sat[4][4] + bri[5][5]*sat[5][4]
	onetwo[5][5] = bri[5][1]*sat[1][5] + bri[5][2]*sat[2][5] + bri[5][3]*sat[3][5] + bri[5][4]*sat[4][5] + bri[5][5]*sat[5][5]

	var/twothree[5][5]
	twothree[1][1] = onetwo[1][1]*hue[1][1] + onetwo[1][2]*hue[2][1] + onetwo[1][3]*hue[3][1] + onetwo[1][4]*hue[4][1] + onetwo[1][5]*hue[5][1]
	twothree[1][2] = onetwo[1][1]*hue[1][2] + onetwo[1][2]*hue[2][2] + onetwo[1][3]*hue[3][2] + onetwo[1][4]*hue[4][2] + onetwo[1][5]*hue[5][2]
	twothree[1][3] = onetwo[1][1]*hue[1][3] + onetwo[1][2]*hue[2][3] + onetwo[1][3]*hue[3][3] + onetwo[1][4]*hue[4][3] + onetwo[1][5]*hue[5][3]
	twothree[1][4] = onetwo[1][1]*hue[1][4] + onetwo[1][2]*hue[2][4] + onetwo[1][3]*hue[3][4] + onetwo[1][4]*hue[4][4] + onetwo[1][5]*hue[5][4]
	twothree[1][5] = onetwo[1][1]*hue[1][5] + onetwo[1][2]*hue[2][5] + onetwo[1][3]*hue[3][5] + onetwo[1][4]*hue[4][5] + onetwo[1][5]*hue[5][5]

	twothree[2][1] = onetwo[2][1]*hue[1][1] + onetwo[2][2]*hue[2][1] + onetwo[2][3]*hue[3][1] + onetwo[2][4]*hue[4][1] + onetwo[2][5]*hue[5][1]
	twothree[2][2] = onetwo[2][1]*hue[1][2] + onetwo[2][2]*hue[2][2] + onetwo[2][3]*hue[3][2] + onetwo[2][4]*hue[4][2] + onetwo[2][5]*hue[5][2]
	twothree[2][3] = onetwo[2][1]*hue[1][3] + onetwo[2][2]*hue[2][3] + onetwo[2][3]*hue[3][3] + onetwo[2][4]*hue[4][3] + onetwo[2][5]*hue[5][3]
	twothree[2][4] = onetwo[2][1]*hue[1][4] + onetwo[2][2]*hue[2][4] + onetwo[2][3]*hue[3][4] + onetwo[2][4]*hue[4][4] + onetwo[2][5]*hue[5][4]
	twothree[2][5] = onetwo[2][1]*hue[1][5] + onetwo[2][2]*hue[2][5] + onetwo[2][3]*hue[3][5] + onetwo[2][4]*hue[4][5] + onetwo[2][5]*hue[5][5]

	twothree[3][1] = onetwo[3][1]*hue[1][1] + onetwo[3][2]*hue[2][1] + onetwo[3][3]*hue[3][1] + onetwo[3][4]*hue[4][1] + onetwo[3][5]*hue[5][1]
	twothree[3][2] = onetwo[3][1]*hue[1][2] + onetwo[3][2]*hue[2][2] + onetwo[3][3]*hue[3][2] + onetwo[3][4]*hue[4][2] + onetwo[3][5]*hue[5][2]
	twothree[3][3] = onetwo[3][1]*hue[1][3] + onetwo[3][2]*hue[2][3] + onetwo[3][3]*hue[3][3] + onetwo[3][4]*hue[4][3] + onetwo[3][5]*hue[5][3]
	twothree[3][4] = onetwo[3][1]*hue[1][4] + onetwo[3][2]*hue[2][4] + onetwo[3][3]*hue[3][4] + onetwo[3][4]*hue[4][4] + onetwo[3][5]*hue[5][4]
	twothree[3][5] = onetwo[3][1]*hue[1][5] + onetwo[3][2]*hue[2][5] + onetwo[3][3]*hue[3][5] + onetwo[3][4]*hue[4][5] + onetwo[3][5]*hue[5][5]

	twothree[4][1] = onetwo[4][1]*hue[1][1] + onetwo[4][2]*hue[2][1] + onetwo[4][3]*hue[3][1] + onetwo[4][4]*hue[4][1] + onetwo[4][5]*hue[5][1]
	twothree[4][2] = onetwo[4][1]*hue[1][2] + onetwo[4][2]*hue[2][2] + onetwo[4][3]*hue[3][2] + onetwo[4][4]*hue[4][2] + onetwo[4][5]*hue[5][2]
	twothree[4][3] = onetwo[4][1]*hue[1][3] + onetwo[4][2]*hue[2][3] + onetwo[4][3]*hue[3][3] + onetwo[4][4]*hue[4][3] + onetwo[4][5]*hue[5][3]
	twothree[4][4] = onetwo[4][1]*hue[1][4] + onetwo[4][2]*hue[2][4] + onetwo[4][3]*hue[3][4] + onetwo[4][4]*hue[4][4] + onetwo[4][5]*hue[5][4]
	twothree[4][5] = onetwo[4][1]*hue[1][5] + onetwo[4][2]*hue[2][5] + onetwo[4][3]*hue[3][5] + onetwo[4][4]*hue[4][5] + onetwo[4][5]*hue[5][5]

	twothree[5][1] = onetwo[5][1]*hue[1][1] + onetwo[5][2]*hue[2][1] + onetwo[5][3]*hue[3][1] + onetwo[5][4]*hue[4][1] + onetwo[5][5]*hue[5][1]
	twothree[5][2] = onetwo[5][1]*hue[1][2] + onetwo[5][2]*hue[2][2] + onetwo[5][3]*hue[3][2] + onetwo[5][4]*hue[4][2] + onetwo[5][5]*hue[5][2]
	twothree[5][3] = onetwo[5][1]*hue[1][3] + onetwo[5][2]*hue[2][3] + onetwo[5][3]*hue[3][3] + onetwo[5][4]*hue[4][3] + onetwo[5][5]*hue[5][3]
	twothree[5][4] = onetwo[5][1]*hue[1][4] + onetwo[5][2]*hue[2][4] + onetwo[5][3]*hue[3][4] + onetwo[5][4]*hue[4][4] + onetwo[5][5]*hue[5][4]
	twothree[5][5] = onetwo[5][1]*hue[1][5] + onetwo[5][2]*hue[2][5] + onetwo[5][3]*hue[3][5] + onetwo[5][4]*hue[4][5] + onetwo[5][5]*hue[5][5]

	return list(twothree[1][1],twothree[1][2],twothree[1][3],twothree[1][4],twothree[2][1],twothree[2][2],twothree[2][3],twothree[2][4],twothree[3][1],twothree[3][2],twothree[3][3],twothree[3][4],twothree[4][1],twothree[4][2],twothree[4][3],twothree[4][4],twothree[5][1],twothree[5][2],twothree[5][3],twothree[5][4])
