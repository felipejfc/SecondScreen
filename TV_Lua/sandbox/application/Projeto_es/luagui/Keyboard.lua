Keyboard = {}


--[[Keyboard = { _alfanumericoDefault = ALFANUMERICO_DEFAULT,
			   
				_alfanumericoShift = ALFANUMERICO_SHIFT,
						   
				_simbolic = SIMBOLIC,
				
				_controlMovimentsSimbol = CONTROL_MOVIMENTS_SIMBOLS,
				
				_controlMovimentsDefault = CONTROL_MOVIMENTS_DEFAULT,
				
				_specialKeys = {"GREEN", "SIMBOL", "SPACE", "LEFT", "RIGHT", "BACKSPACE"},
				
				_mapType = MAPTYPE_NOT_ISRUNNING, --this map indicate is the button is normal, selected or clicked
			   
				_accentsKeys  = ACCENTS_KEYS
				
			}
--]]
local version = ''

--initKeyboard() 
---
--@params textEdit this is where the text is write
--@params x (optional) is the position begin of the keyboard
--@params y (optional) is the position begin of the keyboard
--@params version is the version of config to keyboard
--@params background (optional) is the background of the keyboard
--@params button (optional) is the button in the normal form of keyboard
--@params select (optional) is the button selected 
function Keyboard:new(textEdit, x, y, config, background, button, selected, click)
	a, b = pcall(dofile,"luagui/" .. config ..".conf")
	print("depois", a, b)
	version = config
	Keyboard._alfanumericoDefault = ALFANUMERICO_DEFAULT
	Keyboard._alfanumericoShift = ALFANUMERICO_SHIFT
	Keyboard._alfanumericoDefault = ALFANUMERICO_DEFAULT

	Keyboard._alfanumericoShift = ALFANUMERICO_SHIFT
			   
	Keyboard._simbolic = SIMBOLIC

	Keyboard._controlMovimentsSimbol = CONTROL_MOVIMENTS_SIMBOLS

	Keyboard._controlMovimentsDefault = CONTROL_MOVIMENTS_DEFAULT

	Keyboard._specialKeys = {"GREEN", "SIMBOL", "SPACE", "LEFT", "RIGHT", "BACKSPACE"}

	Keyboard._mapType = MAPTYPE_NOT_ISRUNNING --this map indicate is the button is normal, selected or clicked

	Keyboard._accentsKeys = ACCENTS_KEYS
	
	self = Keyboard		
			--} --]]
    local instance = {}
	setmetatable(instance, self)
	self.__index = Keyboard
    
    instance.__isRunning=false
    instance._textEdit = textEdit
    instance._x = x or 0
    instance._y = y or 0
    instance._fontSize = FONT_SIZE
    instance._fontColor = FONT_COLOR
    instance._changeType = 1
    instance._typeShift = 1
    
    instance._isPaused = false
    instance._currentKeyboard = self._alfanumericoDefault
    instance._currentMoviment = self._controlMovimentsDefault
    instance._background = canvas:new(BGDEFAULT)    
    instance._bigBgAcents = canvas:new(BIGBG_ACENTSDEFAULT)
    instance._smallBgAcents = canvas:new(SMALLBG_ACENTSDEFAULT)
    
    instance._listButton = BTTDEFAULT
    instance._listButtonRed = BTTDEFAULT_RED  
    instance._listButtonGreen = BTTDEFAULT_GREEN
    instance._listButtonYellow = BTTDEFAULT_YELLOW
    instance._listButtonBlue = BTTDEFAULT_BLUE
    instance._listButtonOff = BTTDEFAULT_OFF
    instance._listButtonDouble = BTTDEFAULT_DOUBLE
    
    instance._button = canvas:new(instance._listButton["normal"])
    instance._buttonSelected = canvas:new(instance._listButton["selected"])
    instance._buttonClick = canvas:new(instance._listButton["click"])
    
    instance._buttonRed = canvas:new(instance._listButtonRed["normal"])
    instance._buttonRedSelected = canvas:new(instance._listButtonRed["selected"])
    instance._buttonRedClick = canvas:new(instance._listButtonRed["click"])
    
    instance._buttonGreen = canvas:new(instance._listButtonGreen["normal"])
    instance._buttonGreenSelected = canvas:new(instance._listButtonGreen["selected"])
    
    instance._buttonYellow = canvas:new(instance._listButtonYellow["normal"])
    instance._buttonYellowSelected = canvas:new(instance._listButtonYellow["selected"])
    instance._buttonYellowClick = canvas:new(instance._listButtonYellow["click"])
    
    instance._buttonBlue = canvas:new(instance._listButtonBlue["normal"])
    instance._buttonBlueSelected = canvas:new(instance._listButtonBlue["selected"])
    instance._buttonBlueClick = canvas:new(instance._listButtonBlue["click"])
     
    instance._buttonDouble = canvas:new(instance._listButtonDouble["normal"])
    instance._buttonDoubleSelected = canvas:new(instance._listButtonDouble["selected"])
    instance._buttonDoubleClick = canvas:new(instance._listButtonDouble["click"])
    
    instance._buttonOffDefault = canvas:new(instance._listButtonOff["normal"]) 
    instance._buttonOffRed = canvas:new(instance._listButtonOff["red"]) 
    instance._buttonOffGreen = canvas:new(instance._listButtonOff["green"]) 
    instance._buttonOffYellow = canvas:new(instance._listButtonOff["yellow"]) 
    instance._buttonOffBlue = canvas:new(instance._listButtonOff["blue"]) 
    
    instance._background = canvas:new(BGDEFAULT)    
    instance._bigBgAcents = canvas:new(BIGBG_ACENTSDEFAULT)
    instance._smallBgAcents = canvas:new(SMALLBG_ACENTSDEFAULT)
    local bgx,bgy = instance._background:attrSize()
    instance._bgPaused = canvas:new(bgx-10,bgy-5)
    instance._bgPaused:attrColor(255,255,255,100)
    instance._bgPaused:drawRect("fill",0,0,instance._background:attrSize()) 
    
    instance._atualPosition = {}
    instance._atualPosition.l = 1
    instance._atualPosition.c = 1 
    
    instance._icon = {}
    instance._icon.noShift = canvas:new(DETAILS_SPECIALBUTTONS.noShift)
    instance._icon.shiftNormal = canvas:new(DETAILS_SPECIALBUTTONS.shift)
    instance._icon.shiftFixo = canvas:new(DETAILS_SPECIALBUTTONS.fixo)
    instance._icon.space = canvas:new(DETAILS_SPECIALBUTTONS.space)
    instance._icon.cursorLeft  = canvas:new(DETAILS_SPECIALBUTTONS.cursorLeft )
    instance._icon.cursorRight  = canvas:new(DETAILS_SPECIALBUTTONS.cursorRight)
    instance._icon.backSpace = canvas:new(DETAILS_SPECIALBUTTONS.backSpace)
    instance._icon.alpha = canvas:new(DETAILS_SPECIALBUTTONS.alpha)
    instance._icon.num = canvas:new(DETAILS_SPECIALBUTTONS.num)
    
    instance._cursor = textEdit:cursor()
    instance._w = 0
    instance._h = 0
    instance._spaceBetweenButtons = {}
    instance._spaceBetweenButtons.x = SPACE_BETWEEN_BUTTONS.X
    instance._spaceBetweenButtons.y = SPACE_BETWEEN_BUTTONS.Y
    
    return instance    
end

function Keyboard:dispose()
    --local instance = {}
	--setmetatable(instance, self)
	--self.__index = Keyboard
     self.__isRunning=nil
    self._textEdit =nil
    self._x = nil
    self._y = nil
    self._fontSize = nil
    self._fontColor = nil
    self._changeType = nil
    self._typeShift = nil
    
    self._isPaused =nil
    self._currentKeyboard = nil
    self._currentMoviment =nil
    
    self._background = nil
    self._bigBgAcents = nil
    self._smallBgAcents = nil
    
    self._listButton = nil
    self._listButtonRed = nil
    self._listButtonGreen = nil
    self._listButtonYellow = nil
    self._listButtonBlue = nil
    self._listButtonOff = nil
    self._listButtonDouble = nil
    
    self._button =nil
    self._buttonSelected = nil
    self._buttonClick =nil
    
    self._buttonRed = nil
    self._buttonRedSelected = nil
    self._buttonRedClick =nil
    
    self._buttonGreen =nil
    self._buttonGreenSelected = nil
    
    self._buttonYellow = nil
    self._buttonYellowSelected = nil
    self._buttonYellowClick =nil
    
    self._buttonBlue = nil
    self._buttonBlueSelected =nil
    self._buttonBlueClick = nil
     
    self._buttonDouble = nil
    self._buttonDoubleSelected = nil
    self._buttonDoubleClick =nil
    
    self._buttonOffDefault = nil
    self._buttonOffRed = nil
    self._buttonOffGreen = nil
    self._buttonOffYellow = nil
    self._buttonOffBlue = nil 
    
    self._background =nil
    self._bigBgAcents =nil
    self._smallBgAcents =nil
    local bgx,bgy = nil
    self._bgPaused =nil
    
    self._atualPosition.l = nil
    self._atualPosition.c = nil
    self._atualPosition = nil
    
    self._icon.noShift =nil 
    self._icon.shiftNormal =nil
    self._icon.shiftFixo = nil
    self._icon.space =nil
    self._icon.cursorLeft  =nil
    self._icon.cursorRight  =nil
    self._icon.backSpace =nil
    self._icon.alpha =nil
    self._icon.num =nil
    self._icon = nil
    
    self._cursor =nil
    self._w =nil
    self._h = nil    
    self._spaceBetweenButtons.x = nil
    self._spaceBetweenButtons.y = nil
    self._spaceBetweenButtons = nil   
end


function Keyboard:draw()
    self._cursor = self._textEdit:cursor()
    local img = self._background
    self._w, self._h = img:attrSize()
    local x = self._x +1
    local y = self._y
    canvas:compose(self._x-5, self._y-7, img)
    local fontDefault, sizeDefaut, typeDefault = canvas:attrFont()
    for i = 1, #self._currentMoviment do
        local img = nil
        local line =  self._currentMoviment[i] 
        for j = 1, #line do            
            if line[j-1]~= line[j] then
                 self:drawOneButton(i,j,true)
            end
            x = x +self._spaceBetweenButtons.x
        end 
        x= self._x+1
        y = y + self._spaceBetweenButtons.y
    end 
    if self._isPaused then
        canvas:compose(self._x, self._y-3,self._bgPaused)
    end
    canvas:attrFont(fontDefault, sizeDefaut, typeDefault)
    if not self._isPaused then 
        canvas:flush() 
    end
end

---This function draw a keyboard
function Keyboard:drawOneButton(numLine, numCol, notIsflush)  
    local typeButton = self._mapType[numLine][numCol]
    local content = self._currentKeyboard[numLine][self._currentMoviment[numLine][numCol]]
    local x = 0
    local y = 0
    --canvas:compose(self._x-5, self._y-7, self._background)
    if self._currentKeyboard[numLine][self._currentMoviment[numLine][numCol-1]] ~= content then
        x  = self._x+(numCol-1)*self._spaceBetweenButtons.x
        y = self._y+(numLine-1)*self._spaceBetweenButtons.y
    else
        if self._currentKeyboard[numLine][self._currentMoviment[numLine][numCol-2]] ~= content then
            x  = self._x+(numCol-2)*self._spaceBetweenButtons.x
            y = self._y+(numLine-1)*self._spaceBetweenButtons.y
        else
            x  = self._x+(numCol-3)*self._spaceBetweenButtons.x
            y = self._y+(numLine-1)*self._spaceBetweenButtons.y
        end
    end
    
    canvas:attrFont("Lato",self._fontSize)
    canvas:attrColor(self._fontColor.R, self._fontColor.G, self._fontColor.B, self._fontColor.A)
    
    if content == "GREEN" then
        self:drawGreenButton(x,y,typeButton)
    elseif content == "SIMBOL" then 
        self:drawSimbolButton(x,y,typeButton)
    elseif content == "SPACE" then 
        self:drawSpaceButton(x,y,typeButton)
    elseif content == "LEFT" then 
        self:drawLeftButton(x,y,typeButton)
    elseif content == "RIGHT" then 
        self:drawRightButton(x,y,typeButton)
    elseif content == "BACKSPACE" then
        self:drawBackSpaceButton(x,y,typeButton)
    elseif content == "http://" or content == ".com" or content == "www."then
        self:drawDoubleButtons(x,y,typeButton,content)
    else
        self:drawCharButton(x,y,typeButton,content)
    end
    if not self._isPaused and not notIsflush then canvas:flush() end
end

---Draw the double buttons (for example: http://)
--@params x the position x
--@params y the posstion y
--@params typeButton the type of the button (normal, selected)
--@params content the content draw in the button
function Keyboard:drawDoubleButtons(x,y,typeButton, content)
    if typeButton==0 then
        img = self._buttonOffDefault
    elseif typeButton== 1 then 
		img = self._buttonDouble
	elseif typeButton== 2 then 
		img = self._buttonDoubleSelected
    elseif typeButton== 3 then 
        img = self._buttonDoubleSelected
	else
		img = self._buttonDoubleClick
	end
    local w,h = img:attrSize()
    local iconW, iconH = canvas:measureText(content)
    local iconX = (w)-(iconW/2)
    local iconY = (h/2)-(iconH/2)
    canvas:compose(x,y, img)
    canvas:drawText(x+5, y+5, content)
end

---Draw buttons of the type Char (letters and simbols)
--@params x the position x
--@params y the posstion y
--@params typeButton the type of the button (normal, selected)
--@params content the content draw in the button
function Keyboard:drawCharButton(x,y,typeButton, content)
	if typeButton==0 then
        img = self._buttonOffDefault
    elseif typeButton== 1 then 
		img = self._button
	elseif typeButton== 2 then 
		img = self._buttonSelected
    elseif typeButton== 3 then 
        img = self._buttonRedSelected
	else
		img = self._buttonClick
	end
	local w,h = img:attrSize()
    local iconW, iconH = canvas:measureText(content)
    local iconX = (w/2)-(iconW/2)
    local iconY = (h/2)-(iconH/2)
    canvas:compose(x,y,self._background,x-self._x,y-self._y,w,h)
    canvas:compose(x,y, img)
    canvas:drawText(x+iconX, y+iconY, content)
end

---Draw the green button
--@params x the position x
--@params y the posstion y
--@params typeButton the type of the button (normal, selected)
--@params content the content draw in the button
function Keyboard:drawGreenButton(x,y,typeButton)
    if typeButton == 0 then
        img = self._buttonOffGreen
    elseif typeButton == 1 then 
        img = self._buttonGreen
    elseif typeButton== 2 then 
        img = self._buttonGreenSelected
    else 
        img = self._buttonYellow
    end
    if self._typeShift == 1 then
        icon = self._icon.noShift
    elseif self._typeShift == 2 then
        icon = self._icon.shiftNormal
    elseif self._typeShift ==3 then
        icon = self._icon.shiftFixo
    end
    w,h = img:attrSize()
    iconW, iconH = icon:attrSize()
    local iconX = (w/2)-(iconW/2)
    local iconY = (h/2)-(iconH/2)
    canvas:compose(x,y,self._background,x,y,w,h)
    canvas:compose(x,y, img)
    canvas:compose(x+iconX, y+iconY, icon)
end

---Draw the button witch change the type of button (alphnumeric or simbolic)
--@params x the position x
--@params y the posstion y
--@params typeButton the type of the button (normal, selected)
function Keyboard:drawSimbolButton(x,y,typeButton)
    local w,h = self._button:attrSize()
    local img = nil
    local icon = nil
    
     if typeButton == 0 then
        img = self._buttonOffDefault
    elseif typeButton == 1 then 
        img = self._button
    elseif typeButton == 2 then
        img = self._buttonSelected
    end
    
    if self._changeType == 1 then
        icon = self._icon.num
    else
        icon = self._icon.alpha
    end
    
    w,h = img:attrSize()
    iconW, iconH = icon:attrSize()
    local iconX = (w/2)-(iconW/2)
    local iconY = (h/2)-(iconH/2)
    canvas:compose(x,y,self._background,x,y,w,h)
    canvas:compose(x,y, img)
    canvas:compose(x+iconX, y+iconY, icon)
end

---Draw the space button
--@params x the position x
--@params y the posstion y
--@params typeButton the type of the button (normal, selected)
--@params content the content draw in the button
function Keyboard:drawSpaceButton(x,y,typeButton)
    local w,h = 0,0
    local icon = self._icon.space
    local img=nil
    if typeButton == 0 then
        img = self._buttonOffYellow
    elseif typeButton == 1 then 
        img = self._buttonYellow
    elseif typeButton == 2 then
        img = self._buttonYellowSelected
    end
    
    local w,h = img:attrSize()
    iconW, iconH = icon:attrSize()
    local iconX = (w/2)-(iconW/2)
    local iconY = (h/2)-(iconH/2)
    canvas:compose(x,y, img)
    canvas:compose(x+iconX, y+iconY, icon)
end

---Draw the backspace button
--@params x the position x
--@params y the posstion y
--@params typeButton the type of the button (normal, selected)
function Keyboard:drawBackSpaceButton(x,y,typeButton)
    local w,h = 0,0
    local icon = self._icon.backSpace
    
    if typeButton== 0 then
        img = self._buttonOffBlue
    elseif typeButton == 1 then 
        img = self._buttonBlue
    elseif typeButton == 2 then
        img = self._buttonBlueSelected
    end
    
    w,h = img:attrSize()
    iconW, iconH = icon:attrSize()
    local iconX = (w/2)-(iconW/2)
    local iconY = (h/2)-(iconH/2)
    canvas:compose(x,y, img)
    canvas:compose(x+iconX, y+iconY, icon)
end
    
---draw the button move cursor left
--@params x the position x
--@params y the posstion y
--@params typeButton the type of the button (normal, selected)
function Keyboard:drawLeftButton(x,y,typeButton)
    local w,h=0,0    
    local iconW, iconH=0,0
    local icon = self._icon.cursorLeft
    local img = nil

    if typeButton == 0 then
        img = self._buttonOffDefault
    elseif typeButton == 1 then 
        img = self._button
    elseif typeButton == 2 then
        img = self._buttonSelected
    end
    
    w,h = img:attrSize()
    iconW, iconH = icon:attrSize()
    local iconX = (w/2)-(iconW/2)
    local iconY = (h/2)-(iconH/2)
    canvas:compose(x,y, img)
    canvas:compose(x+iconX, y+iconY, icon)
end

---Draw the button move cursor to the right
--@params x the position x
--@params y the posstion y
--@params typeButton the type of the button (normal, selected)
function Keyboard:drawRightButton(x,y,typeButton)
    local w,h = self._button:attrSize()
    local lcanvas = canvas:new(w,h)
    local icon = self._icon.cursorRight
    local img = nil

    if typeButton == 0 then
        img = self._buttonOffDefault
    elseif typeButton == 1 then 
        img = self._button
    elseif typeButton == 2 then
        img = self._buttonSelected
    end
    
    w,h = img:attrSize()
    iconW, iconH = icon:attrSize()
    local iconX = (w/2)-(iconW/2)
    local iconY = (h/2)-(iconH/2)
    canvas:compose(x,y, img)
    canvas:compose(x+iconX, y+iconY, icon)
end

---Draw the Accents Keys
--@params maptype 
--@params KeyAcents
function Keyboard:drawAccentsKeys(mapType, keyAcents)
    local x = self._x+((self._atualPosition.c-1)*self._spaceBetweenButtons.x)
    local y = self._y+((self._atualPosition.l-1)*self._spaceBetweenButtons.y)
    local bg = nil
    local img = nil
    if #keyAcents>0 then
        self._isPaused = true
        self:draw()
    else
        return
    end
    if #keyAcents >3 then
        bg = self._bigBgAcents
    else 
        bg = self._smallBgAcents
    end
    -- CHANGE HERE canvas:compose(x-3,y-5, bg)
    if(version == 'v4') then
		canvas:compose(x-3,y-5,bg)
    else
		canvas:compose(x,y,bg)
    end
    canvas:attrFont("Lato", self._fontSize)
    for j = 1, #keyAcents do
        if mapType[j] == 0 then 
            img = self._button
        elseif mapType[j] == 1 then 
            img = self._buttonSelected
        else
            img = self._buttonClick
        end
        if j>1 and j%3-1==0 then 
            y = y+self._spaceBetweenButtons.y
            x= self._x+((self._atualPosition.c-1)*self._spaceBetweenButtons.x)
        end
        canvas:compose(x, y, img)
        canvas:drawText(x+20, y+5,keyAcents[j])
        x = x + self._spaceBetweenButtons.x        
    end
    local x = self._x+((self._atualPosition.c-1)*self._spaceBetweenButtons.x)
    local y = self._y+((self._atualPosition.l-1)*self._spaceBetweenButtons.y)
    
    canvas:flush()
end

---This function move de select button for the right
function Keyboard:moveRight()
    
    if self._isPaused ~= true then
    
        self._mapType[self._atualPosition.l][self._atualPosition.c] = 1
        self:drawOneButton(self._atualPosition.l,self._atualPosition.c)
        
        local content = self._currentKeyboard[self._atualPosition.l][self._currentMoviment[self._atualPosition.l][self._atualPosition.c]]
        if self._atualPosition.c < #self._currentKeyboard[1] then
            if self._currentKeyboard[self._atualPosition.l][self._currentMoviment[self._atualPosition.l][self._atualPosition.c+1]] ~= content then
                 self._atualPosition.c = self._atualPosition.c +1
            else
                if self._currentKeyboard[self._atualPosition.l][self._currentMoviment[self._atualPosition.l][self._atualPosition.c+2]] ~= content then
                    self._atualPosition.c = self._atualPosition.c +2
                else
                    self._atualPosition.c = self._atualPosition.c +3
                end
            end
        elseif self._atualPosition.c == #self._currentMoviment[self._atualPosition.l] then
             self._atualPosition.c = 1
        end
      
        self:selected()
        self:drawOneButton(self._atualPosition.l,self._atualPosition.c)
    end
end

---This function move the select button for the left
function Keyboard:moveLeft()
    if self._isPaused ~= true then
        self._mapType[self._atualPosition.l][self._atualPosition.c] = 1
        self:drawOneButton(self._atualPosition.l,self._atualPosition.c)
        local content = self._currentKeyboard[self._atualPosition.l][self._currentMoviment[self._atualPosition.l][self._atualPosition.c]]
        if self._atualPosition.c > 1 then
            if self._currentKeyboard[self._atualPosition.l][self._currentMoviment[self._atualPosition.l][self._atualPosition.c-1]]~= content then
                self._atualPosition.c = self._atualPosition.c-1
            else
                local newcontent = self._currentKeyboard[self._atualPosition.l][self._currentMoviment[self._atualPosition.l][self._atualPosition.c-2]]
                if self._atualPosition.c -2 >0 then
                    if  newcontent~= content then
                        
                        self._atualPosition.c = self._atualPosition.c-2
                    else
                        self._atualPosition.c = self._atualPosition.c-3
                    end
                else
                     self._atualPosition.c = #self._currentMoviment[self._atualPosition.l] 
                end
            end
        elseif self._atualPosition.c == 1 then
             self._atualPosition.c = #self._currentMoviment[self._atualPosition.l] 
        end
        self:selected()
        self:drawOneButton(self._atualPosition.l,self._atualPosition.c)
    end
end

---This function move the select button for the up
function Keyboard:moveUp()
    if self._isPaused ~= true then 
        self._mapType[self._atualPosition.l][self._atualPosition.c] = 1
        self:drawOneButton(self._atualPosition.l, self._atualPosition.c)
        if self._atualPosition.l > 1 then
            self._atualPosition.l = self._atualPosition.l -1
        elseif self._atualPosition.l == 1 then
            self._atualPosition.l = #self._currentKeyboard
        end
        self:selected()
        self:drawOneButton(self._atualPosition.l, self._atualPosition.c)
    end
end

function Keyboard:selectAccent()
    local key = self._currentKeyboard[self._atualPosition.l][self._atualPosition.c]
    local keyAcents = self._accentsKeys[key]
    local returned = false
    if keyAcents ~= nil then 
        returned =  true
    else
        returned = false
    end
    return returned
end

function Keyboard:selected()
        if  self:selectAccent() then
            self._mapType[self._atualPosition.l][self._atualPosition.c] = 3
        else
            self._mapType[self._atualPosition.l][self._atualPosition.c] = 2
        end
end

---This function move the select button fot the down
function Keyboard:moveDown()
	if self._isPaused ~= true then 
        self._mapType[self._atualPosition.l][self._atualPosition.c] = 1
        self:drawOneButton(self._atualPosition.l, self._atualPosition.c)
        if self._atualPosition.l >= #self._currentKeyboard then
            self._atualPosition.l = 1
        elseif self._atualPosition.l >= 1 then
            self._atualPosition.l = self._atualPosition.l +1
           
        end
        self:selected()
        self:drawOneButton(self._atualPosition.l, self._atualPosition.c)
    end
    
end

---Insert a caracter in the textField
--@params key is the text who will be insert
function Keyboard:insertText(key)
    if self._isRunning then
        self._textEdit:draw()
        self._textEdit:insert(key)
        self._cursor=self._textEdit:cursor()
        self._textEdit:draw()
    end
end

---Append a caracter in the textField
--@params key is the text who will be add
function Keyboard:appendText(key)
    if self._isRunning then
        self._textEdit:draw()
        self._textEdit:append(key)
        local value = self._cursor+key:len()
        self._textEdit:cursor(value)
        self._cursor=self._textEdit:cursor()
        self._textEdit:draw()
    end
end

---Delete the last caracter
function Keyboard:textBackspace()
    if self._isRunning then
        self._textEdit:backspace()
        self._textEdit:draw()
        self:draw()
    end
end

---Add a space in teh text
function Keyboard:space()
    if self._isRunning then 
       self:insertText(" ")
       self._textEdit:draw()
       self:draw()
    end
end

---Move the cursor to left
function Keyboard:moveCursorLeft()
    if self._cursor >=1 then
        self._cursor = self._cursor -1
    end
    self._textEdit:cursor(self._cursor)
end

---Move the cursor to right
function Keyboard:moveCursorRight()
    self._cursor = self._cursor+1
    self._textEdit:cursor(self._cursor)
end

---Control the actions when a key is pressed
--@params numline is the line of the atual position
--@params numCol is the colune of the atual position
function Keyboard:pressed(numLine,numCol)
    if self._isPaused ~= true then  
        local key = self._currentKeyboard[self._atualPosition.l][self._currentMoviment[self._atualPosition.l][self._atualPosition.c]]
        if key == "GREEN" then
            self:controlShift()
        elseif key == "SIMBOL" then 
            self:controlType()
        elseif key == "SPACE" then 
            self:space()
        elseif key == "LEFT" then 
            self:moveCursorLeft()
            self._textEdit:draw()
        elseif key == "RIGHT" then 
            self:moveCursorRight()
            self._textEdit:draw()
        elseif key == "BACKSPACE" then
            self:textBackspace()
        elseif #key >= 2  then
            self:appendText(key)
        else
            self:insertText(key)
        end
        if self._typeShift == 2 and key ~= "GREEN" and key ~= "SIMBOL" then
            self:setCurrentKeyboard(self._alfanumericoDefault)
            self._typeShift = 1
            self:draw()
        end
        self:selected()
    end
    canvas:flush()
end

---Control if the keyboard is shift, fixo or normal
function Keyboard:controlShift()
    if self._changeType ~= 2 then
        if self._typeShift == 1 then
            self._typeShift = 2
            self:setCurrentKeyboard(self._alfanumericoShift)
            self:draw()
        elseif self._typeShift==2 then
            self._typeShift = 3
            self:setCurrentKeyboard(self._alfanumericoShift)
            self:draw()
        elseif self._typeShift == 3 or self._typeShift == 0 then
            self._typeShift = 1
            self:setCurrentKeyboard(self._alfanumericoDefault)
            self:draw()
        end
    end
   -- self:draw()
end

---Control the type. The type are simbol or alphanumeric
function Keyboard:controlType()
    if self._changeType == 1 then
        self._changeType=2
        self:setCurrentKeyboard(self._simbolic)
        self:setCurrentMoviment(self._controlMovimentsSimbol)
    elseif self._changeType == 2 then
        self._changeType=1
        self._typeShift = self._typeShift-1
        self:controlShift()
        self:setCurrentMoviment(self._controlMovimentsDefault)
    end
    self:draw()
end

---control keys that have accents
local atualPosition = 1
function Keyboard:controlAccentsKeys(evt)
     local function populateMapType(keylist)
        local list = {}
        if #keylist >= 1 then
            for k,v in ipairs(keylist) do
                list[k] = 0
            end
        end
    return list
    end
    
    local key = self._currentKeyboard[self._atualPosition.l][self._atualPosition.c]
    local keyAcents = self._accentsKeys[key] or {}
    
    local mapType = populateMapType(keyAcents)
    
    mapType[atualPosition] = 1
    self:drawAccentsKeys(mapType, keyAcents)
    
    if (evt.key == 'CURSOR_RIGHT' ) then
        mapType[atualPosition] = 0
        if atualPosition < #keyAcents then
            atualPosition = atualPosition+1
        else 
            atualPosition = 1
        end

        mapType[atualPosition] = 1
        self:drawAccentsKeys(mapType, keyAcents) 
    elseif (evt.key == 'CURSOR_LEFT' ) then
        mapType[atualPosition] = 0
        if atualPosition > 1 then
            atualPosition = atualPosition-1
        else
            atualPosition = #keyAcents
        end

        mapType[atualPosition] = 1
        self:drawAccentsKeys(mapType, keyAcents) 
    elseif (evt.key == 'CURSOR_UP' ) then
        mapType[atualPosition] = 0
        if atualPosition > 3 then 
            atualPosition = atualPosition-3 
        end
        mapType[atualPosition] = 1
        self:drawAccentsKeys(mapType, keyAcents)
    elseif (evt.key == 'CURSOR_DOWN' ) then
        mapType[atualPosition] = 0
        if atualPosition <= 3 and atualPosition+3 <= #keyAcents then 
            atualPosition = atualPosition+3 
        end
        mapType[atualPosition] = 1
        self:drawAccentsKeys(mapType, keyAcents)
    elseif (evt.key == 'ENTER' ) then
            local lkey = keyAcents[atualPosition]
           self:appendText(lkey)
           self._isPaused = false
           atualPosition = 1
           self:draw()
    elseif (evt.key == 'BACK' and self._isPaused == true) then
        self._isPaused = false
        atualPosition = 1
        self:draw()
    end   
end

function Keyboard:backKeyboard()
 	self._mapType[self._atualPosition.l][self._atualPosition.c] = 1
    self:setRunning(false)
end

---Change the current Keyboard
function Keyboard:setCurrentKeyboard(newCurrentKeyBoard)
        self._currentKeyboard = newCurrentKeyBoard 
end

---Change the current Movimentation
function Keyboard:setCurrentMoviment(newCurrentMoviment)
    self._currentMoviment = newCurrentMoviment
end

function Keyboard:setTextEdit(textEdit)
    self._textEdit = textEdit
end

function Keyboard:setBackGround(pathimg)
    self._background = canvas:new(pathimg)
end

function Keyboard:setRunning(bollRunning)
    self._isRunning = bollRunning
    if self._isRunning then 
        self._mapType = MAPTYPE_ISRUNNING
        --self._atualPosition.l=self._atualPosition.l
        --self._atualPosition.c=self._atualPosition.c 
        self._mapType[self._atualPosition.l][self._atualPosition.c] = 3
        self:draw()
        canvas:flush()
             
    else 
        self._mapType = MAPTYPE_NOT_ISRUNNING
        self._isRunning = false
        self._atualPosition.l=1
        self._atualPosition.c=1 
        self:draw()
        canvas:flush()
            
    end
end
---This is the keyboard Handler
function Keyboard:handler(evt)
    if (evt.class == 'key' and evt.type == 'press') and self._isRunning then -- we are just interested in key pressed
        if self._isPaused then
             self:controlAccentsKeys(evt)
             return true
        else
			if (evt.key == 'CURSOR_RIGHT' ) then
				self:moveRight()
				return true
			elseif (evt.key == 'CURSOR_LEFT' ) then
				self:moveLeft()
				return true
			elseif (evt.key == 'CURSOR_UP' ) then
				self:moveUp()
				return true
			elseif (evt.key == 'CURSOR_DOWN' ) then
				self:moveDown()
				return true
			elseif (evt.key == 'GREEN') then
			   self:controlShift()
			   return true
			elseif (evt.key == 'RED') then
				if not atualPosition then atualPosition = 1 end
			   self:controlAccentsKeys(evt)
			   return true
			elseif (evt.key == 'BLUE' ) then
				self:textBackspace()
				return true
			elseif (evt.key == 'YELLOW' ) then
				self:space()
				return true
			elseif (evt.key == 'ENTER' ) then
				self:pressed()
				return true
			elseif (evt.key == 'BACK' ) and not self._isPaused then
				self:backKeyboard()
				return true
			end
		end
    end

end
