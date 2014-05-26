---------------------------------------
-- version 1.1
-- updated 05/24/2014
-- Smeltery Control
---------------------------------------

-- Uses Direwolf20's Button API -------
-- (slightly modified version)
os.loadAPI("button")

-- Load configuration settings --------
os.loadAPI("smeltery_config")
local casting_tables = smeltery_config.casting_tables
local monitor_loc = smeltery_config.monitor_loc
local storage_tanks = smeltery_config.storage_tanks

-- for pouring...
-- 1 ingot is 144 mb
local ingot = 144
-- one block is 9 ingots
local block = ingot * 9

-- wrap the advanced monitor
m = peripheral.wrap(monitor_loc)
-- start with a clear screen
m.clear()

---------------------------------------
-- PRINT MENU SCREENS

-- main starting menu with the primary commands
function printMain()
  button.clearTable()
  m.clear()
  button.heading("Smeltery Control")
  button.setTable("Smelt", printSmelt,   '', 7,22, 3, 3)
  button.setTable("Pour",  printPour,    '', 7,22, 5, 5)
  button.setTable("Fill",  printLiquids, '', 7,22, 7, 7)
  button.setTable("Store", emptyTank,    '', 7,22, 9, 9)
  button.setTable("Void",  voidTank,     '', 7,22,11,11)
  button.setTable("Exit",  endControl,   '', 7,22,13,13)
  
  printLevel()
  button.screen()
end

-- show all the raw materials in storage
local smelt_count = 0
function printSmelt()
	local r = peripheral.wrap(smeltery_config.req_pipe_name)
	-- get a table of all the available items in storage
	local data = r.getAvailableItems()
	
	button.clearTable()
	m.clear()
	button.heading("Smelting Options")
	
	local i = 0
	local k = 0
	for num,mat_table in pairs(data) do
		if (i >= smelt_count and i < smelt_count + 5) then
			local itemID = mat_table[1]
			local name = r.getUnlocalizedName(itemID)
			-- make sure the name can fit on a button
			name = string.sub(name,1,18)
			local amount = mat_table[2]
			button.setTable(name, goSmelt, itemID, 6,23,3+k,3+k)
			k = k + 2
		end
		i = i + 1
	end
	
	smelt_count = smelt_count + 5
	if (smelt_count >= getTableLength(data)) then
		smelt_count = 0
	end
	
	button.setTable("Next Page", printSmelt, '', 6,23,13,13)
	button.setTable("Main",      printMain,  '', 6,23,15,15)
	printLevel()
	button.screen()	
end

-- liquids menu of all liquids that can be stored
local liquid_count = 0
function printLiquids()
  button.clearTable()
  m.clear()
  button.heading("Smeltery Control")
	
	local i = 0
	local k = 0
	-- displays only 5 options at a time
	for liquid,color in pairs(smeltery_config.liquids) do
		if (i >= liquid_count and i < liquid_count + 5) then
			button.setTable(liquid, getMolten, color, 6,23,3+k,3+k)
			k = k + 2
		end
		i = i + 1
	end

	liquid_count = liquid_count + 5
	-- go back to the begining of the list if we step over the end
	if (liquid_count >= getTableLength(smeltery_config.liquids)) then
		liquid_count = 0
	end
	
  button.setTable("Next Page", printLiquids, '', 6,23,13,13)
  button.setTable("Main",      printMain,    '', 6,23,15,15)
  printLevel()
  button.screen()
end

-- print a menu of all the pouring options
local pour_count = 0
function printPour()
	button.clearTable()
	m.clear()
	button.heading("Pouring Options")
	
	-- first screen is always the same
	if (pour_count == 0) then
		button.setTable("Ingot", pourIngots, '', 6,23, 3, 3)
		button.setTable("Block", pourBlocks, '', 6,23, 5, 5)
	else
		local i = 0
		local k = 0
		-- show the custom casts from the config
		for cast,color in pairs(smeltery_config.casts) do
			if (i >= pour_count-5 and i < pour_count) then
				button.setTable(cast, pourCast, color, 6,23,3+k,3+k)
				k = k + 2
			end
			i = i + 1
		end
	end
	
	pour_count = pour_count + 5
	-- link back to the front of the list if we step off
	if (pour_count-5 >= getTableLength(smeltery_config.casts)) then
		pour_count = 0
	end
	
	button.setTable("Next Page", printPour,   '', 6,23,13,13)
	button.setTable("Main",      printMain, '', 6,23,15,15)
	printLevel()
	button.screen()
end

-- print the amount and contents of the tank
function printLevel()
  tank = getTankInfo()
  term.setCursorPos(3,16)
	-- scratch out the old data
  button.label(7, 17, '                    ')
  button.label(7, 18, '                    ')
	-- print the new
  button.label(7, 17, searchInfo(tank,'name'))
  button.label(7, 18, 'Level:'..searchInfo(tank,'amount'))
end

-- end menu printing 
---------------------------------------

---------------------------------------
-- Main Menu Functions

function emptyTank()
  button.toggleButton("Store")
  local tank = getTankInfo()
  local level = tonumber(searchInfo(tank, 'amount'))
	rs.setBundledOutput(casting_tables, smeltery_config.empty_tank)
  while level > 0 do
    sleep(1)
		tank = getTankInfo()
		level = tonumber(searchInfo(tank, 'amount'))
  end
	rs.setBundledOutput(casting_tables,0)
  button.toggleButton("Store")
end

function voidTank()
  button.clearTable()
	m.clear()
	button.heading("Confirm Action to Void Tank")
	
	button.setTable("Void Tank", voidTankConfirmed, '', 6,23, 9, 9)
	button.setTable("Cancel",    printMain,         '', 6,23,12,12)
	
	printLevel()
	button.screen()
end

function voidTankConfirmed(b)
	button.toggleButton(b)
	local tank = getTankInfo()
	local level = tonumber(searchInfo(tank, "amount"))
	rs.setBundledOutput(casting_tables, smeltery_config.void_tank)
	while level > 0 do
		sleep(1)
		tank = getTankInfo()
		level = tonumber(searchInfo(tank, "amount"))
	end
	rs.setBundledOutput(casting_tables, 0)
	button.toggleButton(b)
	
	printMain()
end

function endControl()
  button.toggleButton("Exit")
  print 'Good Bye'
  os.sleep(1)
  os.shutdown()
end


-- end Main Menu Functions
---------------------------------------

---------------------------------------
-- smelting materials
function goSmelt(name,itemID)
	button.clearTable()
	m.clear()
	button.heading("Select Amount to Smelt")
	
	button.setTable("1",  sendSmelt, itemID, 6,23, 3, 3)
	button.setTable("8",  sendSmelt, itemID, 6,23, 5, 5)
	button.setTable("16", sendSmelt, itemID, 6,23, 7, 7)
	button.setTable("32", sendSmelt, itemID, 6,23, 9, 9)
	button.setTable("64", sendSmelt, itemID, 6,23,11,11)
	
	button.setTable("Cancel", printSmelt, '',  6,23,15,15)
	printLevel()
	button.screen()	
end

function sendSmelt(num, itemID)
	local r = peripheral.wrap(smeltery_config.req_pipe_name)
	num = tonumber(num)
	r.makeRequest(itemID, num)
	button.setTable("Request Sent", nothing, '', 6,23,13,13)
	button.screen()
	sleep(1)
	printMain()
end

---------------------------------------

---------------------------------------
-- liquids sub menu functions 
function getMolten(name, color)
  button.toggleButton(name)
  rs.setBundledOutput(storage_tanks, color)
  sleep(2)
  rs.setBundledOutput(storage_tanks, 0)
  button.toggleButton(name)
end
-- end sub menu for liquids
---------------------------------------


---------------------------------------
-- pouring functions

function pourBlocks()
  button.toggleButton("Block")
  local tank = getTankInfo()
  local level = tonumber(searchInfo(tank, 'amount'))
  while level >= block do
		rs.setBundledOutput(casting_tables, smeltery_config.block_color)
    sleep(1)
		rs.setBundledOutput(casting_tables, 0)
    sleep(1)
		tank = getTankInfo()
		level = tonumber(searchInfo(tank, 'amount'))
  end
  button.toggleButton("Block")
end

function pourIngots()
  button.toggleButton("Ingot")
  local tank = getTankInfo()
  local level = tonumber(searchInfo(tank, 'amount'))
  while level >= ingot do
		rs.setBundledOutput(casting_tables, smeltery_config.ingot_color)
    sleep(2)
		rs.setBundledOutput(casting_tables,0)
    sleep(2)
		tank = getTankInfo()
		level = tonumber(searchInfo(tank, 'amount'))
  end
  button.toggleButton("Ingot")
end

function pourCast(name, color)
	button.toggleButton(name)
	rs.setBundledOutput(casting_tables, color)
	sleep(1)
	rs.setBundledOutput(casting_tables, 0)
	button.toggleButton(name)
end

-- end pouring functions
---------------------------------------

-- information on what's in the tank
function getTankInfo()
  rednet.open(smeltery_config.rednet_modem)
  local tank = 1
  local data = {}
  rednet.send(tank)
	
	local drain = peripheral.wrap(smeltery_config.drain_name)
	local data = drain.getTankInfo(smeltery_config.tank_loc)
  
  rednet.close(smeltery_config.rednet_modem)
  return data[1]
end

function searchInfo(t, s)
  assert( type(t) == 'table', 'searchInfo expects a table argument')
  assert( type(s) == 'string', 'searchInfo expects a string argument')
  for i,v in pairs(t) do
    if i == s then
	  return v
	end
  end
  return '0'
end
-- end communication with tank

function getClick()
   event,side,x,y = os.pullEvent("monitor_touch")
   if not button.checkxy(x,y) then printLevel() end
end


function nothing()
  -- place holder
end

function getTableLength(t)
	local count = 0
	for k,v in pairs(t) do
		count = count + 1
	end
	return count
end



---------------------------------------
---------------------------------------

printMain()
-- main loop
while true do
   getClick()
end




