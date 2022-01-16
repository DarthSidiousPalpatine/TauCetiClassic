//How to work with this?
//1. Make a new tree in the holder you want: Make a variable and type
//     tree_variable = new /datum/quad_tree(name, x, y, width, height (of tree))
//2. To add object to the tree and add reference to the object of the cell the object added into - type:
//     object.data_cells[tree_variable.name] += tree_variable.Add_Object(desired object)
//3. If you want to find any object within the range of random point - type:
//     tree_variable.Objects_in_Range(x, y, range (of circular radius))
//4. If you want to find any object within the range of any object in tree - type:
//     object.data_cells[tree_variable.name].Reverse_Objects_in_Range(object, range)

/datum/quad_tree
	var/treename

	//Tree Cordinates
	var/tree_x
	var/tree_y
	var/tree_width
	var/tree_height
	var/tree_z_lvl

	var/datum/quad_tree_cell/root = null
	var/list/all_elements

	var/max_objects = 4

/datum/quad_tree/New(name, x, y, width, height, z_lvl)
	..()
	treename = name

	tree_x = x
	tree_y = y
	tree_width = width
	tree_height = height
	tree_z_lvl = z_lvl

/datum/quad_tree/proc/Add_Object(atom/object) //Adding object to tree
	if(!root)
		root = new /datum/quad_tree_cell(src, null, tree_x, tree_y) //Setting the Root
	var/datum/quad_tree_cell/cell = root
	if(cell.check_inside(object))
		while(cell.children) //Going deep into children's children's childre...children
			for(var/datum/quad_tree_cell/C in cell.children)
				if(C.check_inside(object))
					cell = C
					continue
		cell.Populate(object) //Adding object to cell

/datum/quad_tree/proc/Objects_in_Range(x, y, range) //Search from the surface deep into branches
	var/list/objects
	if(root)
		var/datum/quad_tree_cell/cell = root
		objects = cell.execute_recursive_search(x, y, range)
	return objects

//Cells shit
/datum/quad_tree_cell
	var/datum/quad_tree/tree
	var/datum/quad_tree_cell/parent
	var/list/children = null

	var/cell_x
	var/cell_y
	var/cell_width
	var/cell_height

	var/list/objects
	var/population = 0

/datum/quad_tree_cell/New(quad_tree, parent_cell, x, y)
	..()
	tree = quad_tree
	parent = parent_cell

	cell_x = x
	cell_y = y
	if(parent)
		cell_width = parent.cell_width / 2
		cell_height = parent.cell_height / 2
	else
		cell_width = tree.tree_width
		cell_height = tree.tree_height

/datum/quad_tree_cell/proc/Populate(atom/object) //Adding object to cell
	if(population < tree.max_objects)
		objects += object
		population++
		tree.all_elements += object
		object.data_cells[tree.treename] = src
	else
		Divide()

/datum/quad_tree_cell/proc/Depopulate(atom/object, move = FALSE) //Removing object from cell
	var/list/objs
	var/parent_population = 0
	objects -= object
	tree.all_elements -= object

	if(!move)
		object.data_cells[tree.treename] = null

	for(var/datum/quad_tree_cell/cell in parent.children)
		for(var/atom/obj in cell.objects)
			objs  += obj
			parent_population++
	if(parent_population < tree.max_objects)
		parent.Merge(objs)

/datum/quad_tree_cell/proc/Merge(list/objs)
	for(var/datum/quad_tree_cell/cell in children)
		cell.Destroy()
	for(var/atom/object in objs)
		Populate(object)
		object.data_cells[tree.treename] = src

/datum/quad_tree_cell/proc/Divide() //Dividing cells if overpopulation
	for(var/n = 1 to 4)
		children += new /datum/quad_tree_cell(tree, src, n % 2 ? cell_x + cell_width / 2 : cell_x, n < 3 ? cell_y + cell_height / 2 : cell_y)
	for(var/object in objects)
		for(var/datum/quad_tree_cell/cell in children)
			if(cell.check_inside(object))
				cell.Populate(object)

	objects = null
	population = 0

/datum/quad_tree_cell/proc/check_inside(atom/object) //Check if the object is within cell's boundaries
	return (cell_x <= object.x && object.x < cell_x + cell_width) && (cell_y <= object.y && object.y < cell_y + cell_height) && (tree.tree_z_lvl == object.z)

/datum/quad_tree_cell/proc/check_intersects(x, y, range) //Check if a Circle of x,y,range is colliding with cell
	return ((x - clamp(x, cell_x, cell_x + cell_width)) ** 2 + (y - clamp(y, cell_y, cell_y + cell_height)) ** 2) < range ** 2

/datum/quad_tree_cell/proc/execute_recursive_search(x, y, range) //Recursive deep to the bottom search
	if(!check_intersects(x, y, range))
		return objects

	var/list/objs

	if(!children)
		for(var/atom/object in objects)
			if((((object.x - x) ** 2) + ((object.y - y) ** 2)) < (range ** 2))
				objs += object
	else
		for(var/datum/quad_tree_cell/cell in children)
			objs += cell.execute_recursive_search(x, y, range)

	return objs

/datum/quad_tree_cell/proc/execute_reverse_recursive_search(atom/object, range) //Recursive up to the surface search
	var/list/objs
	var/check_parent = FALSE
	for(var/atom/obj in objects)
		if(obj != object)
			objs += obj

	for(var/datum/quad_tree_cell/cell in parent.children)
		if(cell != src && cell.check_intersects(object.x, object.y, range))
			objs += execute_recursive_search(object.x, object.y, range)
			check_parent = TRUE
	if(check_parent)
		objs += parent.execute_reverse_recursive_search(object, range)

	return objs

/datum/quad_tree_cell/proc/Reverse_Objects_in_Range(atom/object, range) //Search from the ground object up to the surface
	var/list/objs
	objs = execute_reverse_recursive_search(object, range)
	return objs

/datum/quad_tree_cell/proc/Handle_Movement(atom/object) //Handle object's movement from cell to cell
	if(check_inside(object))
		return

	if(tree.tree_z_lvl != object.z)
		Depopulate(object, TRUE)

	var/datum/quad_tree_cell/cell = parent
	while(!cell.check_inside(object)) //Finding a Parent that contains our orphan
		cell = cell.parent

	if(cell.check_inside(object))
		while(cell.children) //Going deep into children's children's childre...children
			for(var/datum/quad_tree_cell/C in cell.children)
				if(C.check_inside(object))
					cell = C
					continue

		cell.Populate(object)
	Depopulate(object, TRUE) //Making our object orphan
