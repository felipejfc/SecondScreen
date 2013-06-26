local register = event.register
local unregister = event.unregister
local socket = require("socket")
local copas = require('copas')
local server = assert(socket.bind("*", 1212))
local typeKey = {'press','release'}
local keyMap = require('keyMap')

handlers = function() return end
event.register = function(...)
handlers = ...
register(...)
end
event.unregister = function (...)
handlers =  function() return end
unregister(...)
end


local function secondScreen(key)
print(key)
	if keyMap[key] then 
		keyMap[key].class = typeKey[1] 
		handlers (keyMap[key])
		keyMap[key].class = typeKey[2] 
		handlers (keyMap[key])
	end
end

function echoHandler(skt)
  while true do
    local data = copas.receive(skt)
    if data == "quit" then
      break
    end
    copas.send(skt, 'recebi '..data)
    secondScreen(data)
  end
end

copas.addserver(server, echoHandler, 0.1)

function refreshControl()
event.timer(200,function()
copas.step(0.1)
refreshControl()
end)
end

refreshControl()
