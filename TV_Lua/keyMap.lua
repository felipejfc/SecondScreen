keyMap ={}
local volume = 0
---KEYBOARD VERYFY
keyMap['KEYRUNNING'] = function(copas, skt, keyRunning)
		copas.send(skt, tostring(keyRunning))
end
---CURSOR
keyMap['UPP'] = 'CURSOR_UP'
keyMap['DOW'] = 'CURSOR_DOWN'
keyMap['LEF'] = 'CURSOR_LEFT'
keyMap['RIG'] = 'CURSOR_RIGHT'
keyMap['ENT'] = 'ENTER'
---OPTION
keyMap['BACK'] = 'BACK'
keyMap['MENU'] = 'MENU'
keyMap['EXIT'] = 'EXIT'
keyMap['INFO'] = 'INFO'
keyMap['EPG'] = 'EPG'
keyMap['CHLIST'] = 'CH_LIST'
---COlOR
keyMap['RED'] = 'RED'
keyMap['GRE'] = 'GREEN'
keyMap['BLU'] = 'BLUE'
keyMap['YEL'] = 'YELLOW'
---Basic Zapper
keyMap['CUP'] = 'CHANNEL_UP'
keyMap['CDW'] = 'CHANNEL_DOWN'
keyMap['MUT'] =  function ()
	if control.getVolume () == 0 then 
		control.setVolume(volume)
	else
		control.setVolume(0)
	end

end
keyMap['VUP'] = function ()
control.volumeUp()
volume = control.getVolume()
end
keyMap['VDW'] = function() 
control.volumeDown()
volume = control.getVolume()
end

--~ keyMap['CUP'] = function () print('Channel UP') end
--~ keyMap['CDW'] = function () print('Channel Down') end

return keyMap
