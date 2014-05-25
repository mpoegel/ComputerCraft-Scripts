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
storage_tanks = "bottom"
-- location of the rednet cable that goes to
-- the casting tables
casting_tables = "top"


-- list of all the liquids and their respective
-- rednet cable colors
liquids = {}
-- liquid goes in the brackets as a string
-- the value parameter is the cable color
-- colors are:
-- colors.white, .magenta, ........
liquids["Aluminum Brass"] = colors.white


-- list of all the pouring options and the 
-- rednet cable colors
-- format is the same as above
casts = {}
casts["ingot"] = colors.white
casts["block"] = colors.magenta