---------------------------------------
-- Smeltery Configuration
--
-- EDIT THIS FILE TO SETUP YOUR SMELTERY
-- AND ONLY THIS FILE
-- (unless you know what you're doing)
---------------------------------------


-- arguments can be:
-- right, left, top, bottom, or back
-- location of the advanced monitor relative
-- to the computer
monitor_loc = "back"
-- location of the rednet cable that goes to
-- the storage tanks
storage_tanks = "left"
-- location of the rednet cable that goes to
-- the casting tables
casting_tables = "right"
-- location of the rednet modem connected to
-- the tank computer
rednet_modem = "bottom"
-- location of the smeltery drain relative to
-- the peripheral proxy
tank_loc = "top"

-- empty tank color
empty_tank = colors.purple
-- void tank color
void_tank = colors.cyan


-- list of all the liquids and their respective
-- rednet cable colors
liquids = {}
-- liquid goes in the brackets as a string
-- the value parameter is the cable color
-- colors are:
-- colors.white, .orange, ........
liquids["Aluminum Brass"] = colors.white
liquids["Molten Glass"] = colors.orange
liquids["Molten Obsidian"] = colors.maganta
liquids["Molten Bronze"] = colors.lightBlue
liquids["Molten Tin"] = colors.yellow
liquids["Molten Copper"] = colors.lime
liquids["Molten Emerald"] = colors.pink
liquids["Molten Steel"] = colors.gray
liquids["Molten Cobalt"] = colors.lightGray
liquids["Molten Ardite"] = colors.cyan


-- list of all the pouring options and the 
-- rednet cable colors
-- format is the same as above
ingot_color = colors.white
block_color = colors.orange
casts = {}
casts["pickaxe head"] = colors.magenta
casts["shovel head"] = colors.lightBlue
casts["axe head"] = colors.yellow
casts["tool rod"] = colors.lime
casts["tool binding"] = colors.pink
casts["sword blade"] = colors.gray
casts["blank cast"] = colors.lightGray