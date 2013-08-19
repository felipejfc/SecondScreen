keyMap ={}
local volume = 0
---CURSOR
keyMap['cursor_up'] = {class = 'key', key = 'CURSOR_UP', type = ''}
keyMap['cursor_down'] = {class = 'key', key = 'CURSOR_DOWN', type = ''}
keyMap['cursor_left'] = {class = 'key', key = 'CURSOR_LEFT', type = ''}
keyMap['cursor_right'] = {class = 'key', key = 'CURSOR_RIGHT', type = ''}
keyMap['cursor_ok'] = {class = 'key', key = 'ENTER', type = ''}

---OPTION
keyMap['back'] = {class = 'key', key = 'BACK', type = ''}
keyMap['input'] = {class = 'key', key = 'MENU', type = ''}
keyMap['exit'] = {class = 'key', key = 'EXIT', type = ''}
keyMap['INFO'] = {class = 'key', key = 'INFO', type = ''}
keyMap['EPG'] = {class = 'key', key = 'EPG', type = ''}
keyMap['CHLIST'] = {class = 'key', key = 'CH_LIST', type = ''}

---COlOR

keyMap['red'] = {class = 'key', key = 'RED', type = ''}
keyMap['green'] = {class = 'key', key = 'GREEN', type = ''}
keyMap['blue'] = {class = 'key', key = 'BLUE', type = ''}
keyMap['yellow'] = {class = 'key', key = 'YELLOW', type = ''}


---Basic Zapper
keyMap['mute'] =  function ()
    if control.getVolume () == 0 then 
        control.setVolume(volume)
    else
        control.setVolume(0)
    end

end

--keyMap['VUP'] = function ()
--control.volumeUp()
--volume = control.getVolume ()
--print(volume)
--end

--keyMap['VDW'] = function() 
--control.volumeDown()
--volume = control.getVolume ()
--print(volume)
--end

keyMap['ch_up'] = {class = 'key', key = 'CHANNEL_UP', type = ''}
keyMap['ch_down'] = {class = 'key', key = 'CHANNEL_DOWN', type = ''}
keyMap['vol_up'] = {class = 'key', key = 'VOLUME_UP', type = ''}
keyMap['vol_down'] = {class = 'key', key = 'VOLUME_DOWN', type = ''}

return keyMap
