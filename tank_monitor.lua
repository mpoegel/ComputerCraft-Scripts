-- send smeltery control the contents of the tank

-- local modem = peripheral.wrap('left')
-- modem.open('left')
rednet.open('left')


while true do

  print 'waiting to receive'
  local id, m = rednet.receive()
    
	print 'sending tank info'
	local smelteryDrain = peripheral.wrap("back")
	local tableInfo = smelteryDrain.getTanks('back')

	for key, value in pairs(tableInfo) do
      for i,v in pairs(value) do
		rednet.send(id, 'incoming')
        rednet.send(id, i)
		rednet.send(id, tostring(v))
	  end
	end
	
end