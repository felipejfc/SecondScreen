local register = event.register
local unregister = event.unregister
local socket = require("socket")
local copas = require('copas')
require("basicZapper")


local server = assert(socket.bind("*", 1212))
local typeKey = {'press','release'}
local keyMap = require('keyMap')
local rprint = function (...)
local rkeyRunning = nil
local rEdit = nil
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
--~ handlers =  function() return end
unregister(...)
end

local function sendKey(key)
	handlers ({class = 'key', key = keyMap[key], type = typeKey[1]})
	handlers ({class = 'key', key = keyMap[key], type = typeKey[2]})
end

local function selectAction(key,skt)
    if keyMap[key] then 
        if type(keyMap[key]) == "string" then
           sendKey(key)
        else 
            keyMap[key](copas,skt,rkeyRunning )
        end
        return true
    end
    return false
end

local function keyboardHandler(skt, data)
	if rEdit and rkeyRunning then
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
end

function echoHandler(skt)
  while true do
    local data = copas.receive(skt)
    if data then 
		copas.send(skt, 'recebi '..data..'\n')
			
		if data == "quit" then
		  break
		else
			if not (selectAction(data, skt)) then
					keyboardHandler(skt, data)
			end
				
		end
	end
  end
end

copas.addserver(server, echoHandler, 0.1)
function setKeyboard (keyboarda)
rprint('atribui um teclado = ', type(keyboarda))
rEdit = keyboarda._textEdit
end

function openKeyboardOnDivice(bollRunning)
rprint('habilitei o teclado = ', bollRunning)
rkeyRunning= bollRunning

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
