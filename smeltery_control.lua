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
  button.setTable("Pour Ingots", pourIngots,   '', 7,22, 3, 3)
  button.setTable("Pour Blocks", pourBlocks,   '', 7,22, 5, 5)
  button.setTable("Fill Tank",   printLiquids, '', 7,22, 7, 7)
  button.setTable("Store Tank",  emptyTank,    '', 7,22, 9, 9)
  button.setTable("Void Tank",   voidTank,     '', 7,22,11,11)
  button.setTable("Exit",        endControl,   '', 7,22,13,13)
  
  printLevel()
  button.screen()
end

-- liquids menu of all liquids that can be stored
liquid_count = 0
function printLiquids()
  button.clearTable()
  m.clear()
  button.heading("Smeltery Control")
	
	local i = 0
	local k = 0
	for liquid,color in pairs(smeltery_config.liquids) do
		if (i >= liquid_count and i < liquid_count + 5) then
			button.setTable(liquid, getMolten, color,3+k,3+k)
			k += 1
		end
		i += 1
	end
	
	liquid_count = liquid_count + 5
	if (liquid_count >= #smeltery_config.liquids) then
		liquid_count = 0
	end
	
  -- button.setTable("Aluminium Brass", getMolten,     colors.magenta,   6,23, 3, 3)
  -- button.setTable("Molten Bronze",   getMolten,     colors.lightBlue, 6,23, 5, 5)
  -- button.setTable("Molten Tin",      getMolten,     colors.yellow,    6,23, 7, 7)
  -- button.setTable("Molten Obsidian", getMolten,     colors.white,     6,23, 9, 9)
  -- button.setTable("Molten Glass",    getMolten,     colors.orange,    6,23,11,11)
  button.setTable("Next",            printLiquids, '',               6,23,13,13)
  button.setTable("Back",            printMain,     '',               6,23,15,15)
  
  printLevel()
  button.screen()
end

-- second menu for liquids
function printLiquids1()
	button.clearTable()
	m.clear()
	button.heading("Smeltery Control")
	button.setTable("Next", nothing,      '', 6,23,13,13)
	button.setTable("Back", printLiquids, '', 6,23,15,15)
	
	printLevel()
	button.screen()
end

-- print the amount and contents of the tank
function printLevel()
  -- tank = getTankInfo()
  -- term.setCursorPos(3,16)
	-- scratch out the old data
  -- button.label(7, 17, '                    ')
  -- button.label(7, 18, '                    ')
	-- print the new
  -- button.label(7, 17, searchInfo(tank,'name'))
  -- button.label(7, 18, 'Level:'..searchInfo(tank,'amount'))
end

-- end menu printing 
---------------------------------------

---------------------------------------
-- Main Menu Functions 
function pourBlocks()
  button.toggleButton("Pour Blocks")
  local tank = getTankInfo()
  local level = tonumber(searchInfo(tank, 'amount'))
  local ingot = 144
  local block = ingot * 9
  while level >= block do
		rs.setBundledOutput(casting_tables, colors.orange)
    sleep(1)
		rs.setBundledOutput(casting_tables, 0)
    sleep(1)
		tank = getTankInfo()
		level = tonumber(searchInfo(tank, 'amount'))
  end
  button.toggleButton("Pour Blocks")
end

function pourIngots()
  button.toggleButton("Pour Ingots")
  local tank = getTankInfo()
  local level = tonumber(searchInfo(tank, 'amount'))
  local ingot = 144
  while level >= ingot do
		rs.setBundledOutput('bottom', colors.white)
    sleep(2)
		rs.setBundledOutput('bottom',0)
    sleep(2)
		tank = getTankInfo()
		level = tonumber(searchInfo(tank, 'amount'))
  end
  button.toggleButton("Pour Ingots")
end

function emptyTank()
  button.toggleButton("Store Tank")
  local tank = getTankInfo()
  local level = tonumber(searchInfo(tank, 'amount'))
  local ingot = 144
  while level >= ingot do
	rs.setBundledOutput('bottom', colors.black)
    sleep(2)
	rs.setBundledOutput('bottom',0)
    sleep(2)
	tank = getTankInfo()
	level = tonumber(searchInfo(tank, 'amount'))
  end
  button.toggleButton("Store Tank")
end

function voidTank()
  button.toggleButton("Void Tank")
  rs.setBundledOutput('bottom', colors.lightBlue)
  sleep(3)
  rs.setBundledOutput('bottom', 0)
  button.toggleButton("Void Tank")
end

function endControl()
  button.toggleButton("Exit")
  print 'Good Bye'
  os.sleep(1)
  os.shutdown()
end


-- end Main Menu Functions
---------------------------------------

-- liquids sub menu functions --
function getMolten(name, color)
  button.toggleButton(name)
  rs.setBundledOutput('right', color)
  sleep(3)
  rs.setBundledOutput('right', 0)
  button.toggleButton(name)
end
-- end sub menu for liquids

-- communication with tank
function getTankInfo()
  rednet.open('top')
  local tank = 1
  local data = {}
  rednet.send(tank)

  while true do
    local id, status = rednet.receive(.2)
	if status == 'incoming' then
	  local id, name = rednet.receive(.5)
	  local id, value = rednet.receive(.5)
	  data[name] = value
	else break end
  end
  rednet.close('top')
  return data
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


printMain()
-- main loop
while true do
   getClick()
end




