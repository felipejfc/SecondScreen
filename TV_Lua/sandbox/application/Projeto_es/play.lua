--fazer mini app: https://developers.google.com/image-search/v1/jsondevguide?hl=pt-BR

--[[***************************
 * Copyright (c) 2013 Fundação CERTI.
 * All rights reserved.
 ***********************]]

-- Example of using for Images moving
require("config")
require(SB_REQUIRE_LUAGUI .. "Keyboard")
require(SB_REQUIRE_LUAGUI .. "widgets.TextEdit")
require(SB_REQUIRE_LUAGUI .. "widgets.PasswordField")
local http = require("socket.http")



require('application')
require('basicZapper')
require('remoteControl')

local channelGlobo, channelBand, channelSbt, channelRecord
local iconVolumeMute, iconVolume0, iconVolume1, iconVolume2, iconVolume3, iconNoAction
local iconMediaNormal, iconInputNormal, iconPictureNormal, iconAudioNormal, iconSettingsNormal, iconAppNormal
local iconAppFocus, iconMediaFocus, iconInputFocus, iconPictureFocus, iconAudioFocus, iconSettingsFocus, bgMenuFocus
local json = nil
local channels = nil
local imageIconsNormal = nil
local imageIconsFocus = nil
local iconVolume = nil

local nameMenu = {"Aplicações", "Media Center", "Entrada", "Imagem", "Audio", "Configurações"}
local avaliableChannels = {"3","7","9","13"}
local posChannel = 1
local posMenuPrincipal = 1
local volume = 0--control.getVolume ()
local showMenu = false
local clearVolume
local setChannel = ""
local cancelChangeChannel = nil
local canEnter = true
local keyboard = nil
local textEditU, textEditUP = nil
local red, green, blue, transparency = 150, 150, 150, 255
local canal = 0
local x, y,w, h = nil 


local function loadImages()
	channelGlobo = canvas:new('res/globo.png')
	channelBand = canvas:new('res/band.png')
	channelSbt = canvas:new('res/sbt.png')
	channelRecord = canvas:new('res/record.png')

	iconVolumeMute = canvas:new('res/icon/ico-mute.png')
	iconVolume0 = canvas:new('res/icon/ico-volume_00.png')
	iconVolume1 = canvas:new('res/icon/ico-volume_01.png')
	iconVolume2 = canvas:new('res/icon/ico-volume_02.png')
	iconVolume3 = canvas:new('res/icon/ico-volume_03.png')
	iconNoAction = canvas:new('res/icon/ico-no_action.png')

	iconAppNormal = canvas:new('res/icon/ico-apps.png')
	iconMediaNormal = canvas:new('res/icon/ico-media_center.png')
	iconInputNormal = canvas:new('res/icon/ico-input.png')
	iconPictureNormal = canvas:new('res/icon/ico-picture.png')
	iconAudioNormal = canvas:new('res/icon/ico-sound.png')
	iconSettingsNormal = canvas:new('res/icon/ico-settings.png')

	iconAppFocus = canvas:new('res/icon/ico-apps_focus.png')
	iconMediaFocus = canvas:new('res/icon/ico-media_center2.png')
	iconInputFocus = canvas:new('res/icon/ico-input_focus.png')
	iconPictureFocus = canvas:new('res/icon/ico-picture_focus.png')
	iconAudioFocus = canvas:new('res/icon/ico-sound_focus.png')
	iconSettingsFocus = canvas:new('res/icon/ico-settings_focus.png')

	bgMenuFocus = canvas:new('res/icon/selectMenu.png')
	channels = {}
	channels["3"] =  channelGlobo 
	channels["7"] = channelBand
	channels["9"] =  channelSbt
	channels["13"] =   channelRecord
	imageIconsNormal = {iconAppNormal, iconMediaNormal, iconInputNormal, iconPictureNormal, iconAudioNormal, iconSettingsNormal}
	imageIconsFocus = {iconAppFocus, iconMediaFocus, iconInputFocus, iconPictureFocus, iconAudioFocus, iconSettingsFocus}
	iconVolume = {iconVolume0 ,iconVolume1 , iconVolume2, iconVolume3}
end


function searchKeyboardHandler(evt)
	if(canEnter) then
		canEnter = false
	else
		keyboard:handler(evt)
	end
	if (evt.class == 'key' and evt.type == 'press') then
		if (evt.key == 'BACK' ) then
			keyWordSearch = textEditU:text():gsub(" ", "")
			event.unregister(searchKeyboardHandler)
			local requisicao = 'https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q='..keyWordSearch
			requisicao = http.request(requisicao)
			requisicao= json:decode(requisicao)
			--~ print(json.decode(requisicao))
			
			for i,v in pairs(requisicao.responseData.results) do 
				print(i,v.url)
				file  = io.open("img/"..i..".jpg", "w+") 
				imagem  = http.request(v.url)
				
				file:write(imagem)
				
				file:close()
				imagem = canvas:new("img/"..i..".jpg")
				imagem:attrScale(200,100)
				canvas:compose(i * 200, 0, imagem)
				canvas:flush()
			end
			
			event.register(onKeyPress)
			canEnter = false
			textEditU._cursorVisible = false
			
			verticalNavigationSearch = 2
			
			canvas:flush()
		end
	end
end

local function showKeyboard(handlerFunction, isPassword,x, y, width, height, refresh, textDefault )
	print("------------chamei")
	local currentText = nil
	if(isPassword) then
		textEditUP = PasswordField:new():oneline(true)
		textEditUP._x= x 
		textEditUP._y= y
		textEditUP._width= width
		textEditUP._height= height
		textEditUP:text(textDefault)
		textEditUP._style = Style:new()
		:backgroundColor(Color:new(255, 255, 255, 255))
		:fontColor(Color:new(red, green, blue, transparency))
		:shadowColor(Color:new(0, 0, 0, 0))
		:frameColor(Color:new(0, 0, 0, 0))
		textEditUP:style():fontSize(17)
		textEditUP:visible(true)
		textEditUP._cursorVisible = false
		textEditUP:draw()
		currentText = textEditUP
	else
		textEditU = TextEdit:new():oneline(true)
		textEditU._x= x 
		textEditU._y= y
		textEditU._width= width
		textEditU._height= height
		textEditU:text(textDefault)
		
		textEditU._style = Style:new()
		:backgroundColor(Color:new(255, 255, 255, 255))
		:fontColor(Color:new(red, green, blue, transparency))
		:shadowColor(Color:new(0, 0, 0, 0))
		:frameColor(Color:new(0, 0, 0, 0))
		textEditU:style():fontSize(17)
		textEditU:visible(true)
		textEditU:cursor(#textDefault+1)
		textEditU._cursorVisible = false
		textEditU:draw()
		currentText = textEditU
	end
	print("----------------meio")
	if not(refresh) then
		keyboard = Keyboard:new(currentText, 938, 305, "v3")
		keyboard:setRunning(false)
		keyboard:draw()
	else
		canEnter = true
		currentText._cursorVisible = true
		currentText:text(textDefault)
		currentText:draw()
		keyboard:setTextEdit(currentText)
		keyboard:setRunning(true)
		event.unregister(onKeyPress)
		event.register(handlerFunction)
	end	
	
	print("----------------fim")
end



local function getColor()
	return 0,0,0,255
end

local function clearBackground(x,y, widht, height, canFlush)
	canvas:compose(x,y,channels[avaliableChannels[posChannel + 1]], x, y, widht, height)
	if(canFlush)then
		canvas:flush()
	end

end

local function alignCenter(x_box, text, sizeFont)
	canvas:attrFont("Lato", sizeFont, "normal")
	local x = canvas:measureText(text)
	local aux = x_box - x
	return (aux/2)
end

local function drawBarVolume(fixVolume)
	canvas:attrFont('Lato', 20)
	canvas:attrColor(229,229,229,255)

	if(clearVolume) then
		clearVolume()
	end
	clearBackground(1200,0, 80, 80, false)
	
	if(volume == 0) then
		canvas:compose(1200,20,iconVolumeMute)
		canvas:drawText(1200, 40,"MUTE")	
	else
		local image = math.ceil(volume / 25)
		canvas:compose(1200,20,iconVolume[image])
		canvas:drawText(1200, 40,tostring(volume))	
	end
	canvas:flush()
	if(not fixVolume)then
		print ("=================== vou limpar o volume")
		clearVolume = event.timer(2000, function()
			clearBackground(1200,0, 80, 80, true)
		end)
	end
end

local function paintImage(canDrawVolume)
	canvas:attrColor(getColor())
	canvas:clear()
	canvas:compose(0,0,channels[avaliableChannels[posChannel+1]])
	if(volume == 0)then
		drawBarVolume(true)	
	else
		canvas:flush()
	end
end



local function changeChannel(numberChannel)
	setChannel = setChannel..numberChannel
	canvas:attrFont('Lato', 20)
	canvas:attrColor(229,229,229,255)

	if(cancelChangeChannel) then
		cancelChangeChannel()
	end
	clearBackground(1200,0, 80, 80, false)
	canvas:drawText(1200, 40, setChannel)	
	canvas:flush()
	print("canal",avaliableChannels[tostring(setChannel)])
	cancelChangeChannel = event.timer(2000, function()
		for i,v in pairs(avaliableChannels) do
		if(v == tostring(setChannel))then
			posChannel = tonumber(i)-1
			paintImage()
			break
		else
					
			print("vou mudar de canal")
			canvas:compose(1200,20,iconNoAction)
			canvas:flush()
			event.timer(1000, function()
				clearBackground(1200,0, 80, 80, true)
			end)
			
		end
		end
		setChannel = ""	
		

	end)
end






local function drawButtonMenu(pos, isSelect)
	if(isSelect)then
		canvas:attrColor(0,0,0, 255)
		canvas:drawRect ("fill", 0 + ((pos-1) * 214), 580, 214 , 140)
		canvas:compose(0 + ((pos-1) * 214),580,bgMenuFocus)	
		canvas:compose(72 + ((pos-1) * 214),610,imageIconsFocus[pos])	
		
		canvas:attrFont('Lato', 24)
		canvas:attrColor(255,255,255,255)
		canvas:drawText(alignCenter(214, nameMenu[pos], 24) + ((pos-1) * 214), 680,nameMenu[pos])
		
	else
		canvas:attrColor(0,0,0, 255)
		canvas:drawRect ("fill", 0 + ((pos-1) * 214), 580, 214 , 140)
		canvas:compose(72 + ((pos-1) * 214),610,imageIconsNormal[pos])
		
		canvas:attrFont('Lato', 20)
		canvas:attrColor(229,229,229,255)
		canvas:drawText(alignCenter(214, nameMenu[pos], 20) + ((pos-1) * 214), 680,nameMenu[pos])	
	end
	
	
end
local function drawMenu()
	canvas:attrColor(0,0,0, 255)
	canvas:drawRect ("fill", 0, 580, 1280 , 140)
	
	for i=1, #imageIconsNormal do
		if(i == posMenuPrincipal)then
			drawButtonMenu(i, true)
		else
			drawButtonMenu(i, false)
		end
	end
		
	canvas:flush()
end



--------------------------------------------------
-- HANDLERS
--------------------------------------------------

function onKeyPress(evt)
	if evt.class == 'key' and evt.type == 'press' then
		print("====================+", evt.class, evt.type, type(evt.key))
		if(evt.key == 'MENU') then
			if(not showMenu)then
				drawMenu()
			else
				clearBackground(0, 580, 1280 , 140, true)
			end
			showMenu = not showMenu
			
		elseif(evt.key == 'ENTER') then
			if(showMenu and posMenuPrincipal == 1) then
				showKeyboard(searchKeyboardHandler, false,940, 255, 280, 30, false, "Teste")
				showKeyboard(searchKeyboardHandler, false,940, 255, 280, 30, true, "Teste")
			end
		elseif(evt.key == 'VOLUME_DOWN') then
			if(volume > 0)then
				volume = volume - 1
			end
			drawBarVolume()
		elseif (evt.key == 'VOLUME_UP') then
			if(volume < 100)then
				volume = volume + 1
			end
			drawBarVolume()
			
		elseif(evt.key == 'CHANNEL_DOWN') then
			showMenu = false
			posChannel = (posChannel - 1) % #avaliableChannels
			paintImage()
			
		elseif (evt.key == 'CHANNEL_UP') then
			showMenu = false
			posChannel = (posChannel + 1) % #avaliableChannels
			paintImage()
			
		elseif (evt.key == 'CURSOR_LEFT') then
			if(showMenu)then
				if(posMenuPrincipal > 1)then
					drawButtonMenu(posMenuPrincipal, false)
					posMenuPrincipal = posMenuPrincipal - 1
					drawButtonMenu(posMenuPrincipal, true)
					canvas:flush()
				end
			end
			
		elseif (evt.key == 'CURSOR_RIGHT') then
			if(showMenu)then				
				if(posMenuPrincipal < #imageIconsNormal)then
					drawButtonMenu(posMenuPrincipal, false)
					posMenuPrincipal = posMenuPrincipal + 1
					drawButtonMenu(posMenuPrincipal, true)
					canvas:flush()
				end
			end
		elseif (tonumber(evt.key)) then
			
			changeChannel(evt.key)
		end
		
		
		
	else
		print('NO ACTION FOR PRESSED KEY "' .. evt.key .. '" , "'.. evt.type..'"')
	end
end

local function initializeVariables()
	json = require("util.json")
	event.register(onKeyPress)
	loadImages()
	
	video = mediaPlayer:new('dtv://video')
	video:prepare()
	x, y,w, h = video:getBounds()
	video:setBounds(0, 0, 790, 440)
	video:start()
	--~ paintImage()



end
handlers = {}

function handlers.onCreate()
	print("<< APP EXAMPLE >> onCreate")
end

function handlers.onStart()
	print("<< APP EXAMPLE >> onStart")
end

function handlers.onStop()
	print("<< APP EXAMPLE >> onStop")
end

function handlers.onDestroy()
	print("<< APP EXAMPLE >> onDestroy")
end

function handlers.onKeyPress(key)
print("<< APP EXAMPLE >> onKeyPress", key)
end

function indexPage()
	return true
end

initializeVariables()

