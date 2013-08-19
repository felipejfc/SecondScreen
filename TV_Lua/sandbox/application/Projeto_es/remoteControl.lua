local register = event.register
local unregister = event.unregister
local socket = require("socket")
local copas = require('copas')
require("basicZapper")


server = assert(socket.bind("*", 1212))
print(server.ip)
local typeKey = {'press','release'}
local keyMap = require('keyMap')
local rkeyboard = nil
local rkeyRunning = nil
local rEdit = nil

local rprint = function (...)
print('=====SecondScreen=====', ...)
end
local handlers = function() return end

event.register = function(...)
rprint('registrei')
handlers = ...
register(...)
end
event.unregister = function (...)
rprint('disregistrei')
handlers =  function() return end
unregister(...)
end


local function secondScreen(key)
    if keyMap[key] then 
        if type(keyMap[key]) == "table" then
            keyMap[key].type = typeKey[1] 
            handlers (keyMap[key])
            keyMap[key].type = typeKey[2] 
            handlers (keyMap[key])
            return true
        else 
            keyMap[key]()
            return true
        end
    end
    return false
end

function echoHandler(skt)
  while true do
    local data = copas.receive(skt)
    if data == "quit" then
      break
    end
    if not (secondScreen(data)) then
		if rkeyboard and keyRunning then
			copas.send(skt, 'keyboardRunning')
			if(rEdit._password == nil)then
				rEdit:text(rEdit:text().. data)
				rEdit._cursor = #rEdit:text() + #data
			else
				rEdit._password = rEdit._password .. data
				rEdit._cursor = #rEdit._password + #data
			end
			
			rEdit:draw()
			canvas:flush()
		end 
	else
		copas.send(skt, 'recebi '..data..'\n')
	end
  end
end

copas.addserver(server, echoHandler, 0.1)
function setKeyboard (keyboarda)

rprint('atribui um teclado = ', type(keyboarda))
rkeyboard = keyboarda
rEdit = rkeyboard._textEdit
end

function openKeyboardOnDivice(bollRunning)
rprint('habilitei o teclado = ', bollRunning)
keyRunning= bollRunning

end
function setEdit(textEdit)
rEdit = textEdit

end
function refreshControl()
	event.timer(200,function()
	copas.step(0.1)
	refreshControl()
end)
end

refreshControl()
