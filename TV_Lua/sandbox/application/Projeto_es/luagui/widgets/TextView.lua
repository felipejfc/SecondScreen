--- Class representing a TextView widget.
require(SB_REQUIRE_LUAGUI .. "widgets.Widget")
require(SB_REQUIRE_LUAGUI .. "widgets.Utils")

TextView = inheritsFrom(Widget)

--- Text hold on the TextView.
--Default: (blank)
TextView._text = ""

--- One line attribute. Defines if the TextView is one lined.
--Default: false
TextView._oneline = false

--- Padding from top.
--Default: 3
--@see Widget._paddingTop.
TextView._paddingTop = 3

--- Padding from bottom.
--Default: 3
--@see Widget._paddingBottom.
TextView._paddingBottom = 3

--- Padding from left.
--Default: 5
--@see Widget._paddingLeft.
TextView._paddingLeft = 5

--- Padding from right.
--Default: 5
--@see Widget._paddingRight
TextView._paddingRight = 5

--- Holds the current cursor position.
--Default: 1
TextView._cursor = 1


TextView._style = Style:new()
        :backgroundColor(Color:new(255, 255, 255, 255))
        :fontColor(Color:new(0, 0, 0, 255))
        :shadowColor(Color:new(0, 0, 0, 0))

--- Attribute that defines the cursor visibility.
--Default: false
TextView._cursorVisible = false

local function isBoolean(value) return (type(value) == 'boolean') end
local function isString(value) return (type(value) == 'string') end

--- TextView metatable.
local TextViewMt = { __index = TextView }

--- Instantiates a new TextView object.
--
--@param text String to be displayed.
--@param oneline Boolean true if its an one line textview, false otherwise.
function TextView:new(text, oneline)
    local newTextView = {}

    for k, v in pairs(TextView) do
        if type(v) == 'table' and nil ~= v.isAn and v:isAn(Object) then
            local vClass = v:class()
            newTextView[k] = vClass:new(v)
        else
            newTextView[k] = TextView[k]
        end
    end

    setmetatable(newTextView, TextViewMt)

    if text then
        newTextView:text(text)
    end

    if oneline then
        newTextView:oneline(oneline)
    end

    return newTextView
end

--- Reads or sets the text to be displayed.
--
--@param text if not nil, it's the string to be displayed
--@return The current text displayed if text = nil, or self otherwise.
--@name TextView:text()
function TextView:text(text)
    if text then
        self._text = LString:new(text)
    else
        return self._text:string()
    end
end

--- Reads or sets the one line parameter.
--
--@param bool if true to set the textview to be one liner, false otherwise.
--@param return boolean matching the one line status if bool = nil, self
--otherwise.
--@name TextView:oneline()
TextView.oneline = accessorFor("_oneline", isBoolean)

--- Getter and setter for the cursor visibility attribute.
--@param bool if true, it sets the cursor to be visible.
--@return The current visibility of the cursor.
TextView.cursorVisible = accessorFor("_cursorVisible", isBoolean)

--- Gets and sets the cursor position.
--@param value The new cursor position.
--@return Self or the current cursor position.
function TextView:cursor(value)
    if nil == value then return self._cursor end

    assert(
        (type(value) == 'number') and (math.floor(value) == value),
        "value must be an integer"
        )

    if value < 1 then
        self._cursor = 1

    elseif value > self._text:length() + 1 then
        self._cursor = self._text:length() + 1

    else
        self._cursor = value

    end
    return self
end

--- Sets the collor to use on the given canvas.
--
--@param lcanvas the target canvas to set collor.
--@param color Color instance
local function setDrawingColor(lcanvas, color)
  lcanvas:attrColor(color:r(), color:g(), color:b(), color:a())
end

local function drawCursor(x, y, lcanvas)
    local _, cHeight = lcanvas:measureText('a')
    lcanvas:drawLine(x, 0.1 * cHeight + y, x, y + 0.8*cHeight)
end

local function cursorPosition(textView, lcanvas)
    local currentPosition = 1
    local cursorPosition = textView:cursor()
    local cursor_x = 1
    for k, v in pairs(textView._text:iterable()) do
        if currentPosition == cursorPosition then return cursor_x end
        local wordWidth, _ = lcanvas:measureText(v)
        cursor_x = cursor_x + wordWidth
        currentPosition = currentPosition + 1
    end

    return cursor_x
end
local function drawOneLine(textView, lcanvas,cursorVisible)
    local cursor_x = cursorPosition(textView, lcanvas)

    local contW = textView:contentsRegion().width

    local xc = 0
    if cursor_x > contW then
        xc = contW  - cursor_x - 1
    end


    -- draw shadow
    setDrawingColor(lcanvas, textView:style():shadowColor())
    lcanvas:drawText(xc + 1, 1, textView:text())

    --draw text
    setDrawingColor(lcanvas, textView:style():fontColor())
    lcanvas:drawText(xc, 0, textView:text())
	if(cursorVisible)then
	    drawCursor(xc + cursor_x - 1, 0, lcanvas)
	end
end

local function addItenInMidle(list,iten,index)
	local aux = iten

	for i=index,#list+1 do
		local aux2=list[i]
		list[i]=aux
		aux=aux2
	end

end
--- Draws the TextView instance.
--
--@param lcanvas the target canvas to draw on.
function TextView:draw(lcanvas)
	
    if not self:visible() then return end
    local lcanvas = lcanvas or canvas
    local r, g, b, a = lcanvas:attrColor()

    local st = self:style()
    local face, size, style = lcanvas:attrFont()
    local textViewCanvas = self:contentsCanvas()
    textViewCanvas:attrFont(st:fontFace(), st:fontSize(), style)
	
    if self:oneline() then
        local tw, th = textViewCanvas:measureText(self:text())
        self:height(th + self:paddingTop() + self:paddingBottom() +
             self:marginTop() + self:marginBottom())
    end

    local frameColor = self:style():frameColor()
    local foccusColor = self:style():foccusColor()

    if self:foccused() then
        self:style():frameColor(foccusColor)
    end

    self:_drawBackground(lcanvas)
    self:style():frameColor(frameColor)

    local width = self:width() - self:marginLeft() - self:marginRight()
    - self:paddingLeft() - self:paddingRight()

    local height = self:height() - self:marginTop() - self:marginBottom()
    - self:paddingTop() - self:paddingBottom()

    local drawingCursor = {
        x = self:paddingLeft(),
        y = self:paddingTop()
    }
	
    local cursor = self:cursor()
    local currentPosition = 1

    local thetext = self._text:split()

    local spaceWidth, lineHeight = textViewCanvas:measureText(' ')
    lineHeight=lineHeight-5
	 if self:oneline() then
        drawOneLine(self, textViewCanvas,self._cursorVisible)

        lcanvas:compose(
            self:contentsRegion().x,
            self:contentsRegion().y,
            textViewCanvas
            )
        return
    end
    local i = 1
    local flagWidht=false
    while i <= #thetext and drawingCursor.y < height do
        local wordWidth, wordHeight = textViewCanvas:measureText(thetext[i])
        local tamanhoCarac = LString:new(thetext[i]):length()
        if height < wordHeight then
            break
        end

        -- draw cursor
        if drawingCursor.x + wordWidth < width then
            if self:cursorVisible() and nil ~= thetext[i] then
                setDrawingColor(textViewCanvas, self:style():fontColor())
                local length = LString:new(thetext[i]):length()
                if currentPosition == cursor then
                    textViewCanvas:drawLine(drawingCursor.x, drawingCursor.y, drawingCursor.x, drawingCursor.y + lineHeight)

                elseif currentPosition < cursor and currentPosition + length > cursor then
                    local w = 0
                    for j = 1, length do
                        w, _ = w + textViewCanvas:measureText(LString:new(thetext[i]):at(j):string())
                        if currentPosition + j == cursor then
                            textViewCanvas:drawLine(drawingCursor.x + w, drawingCursor.y, drawingCursor.x + w, drawingCursor.y + lineHeight)
                        end
                    end

                elseif currentPosition + length == cursor then
                    local w, _ = textViewCanvas:measureText(thetext[i])
                    local w = w
                    textViewCanvas:drawLine(drawingCursor.x + w, drawingCursor.y, drawingCursor.x + w, drawingCursor.y + lineHeight)

                end

                currentPosition = length + currentPosition + 1
            end
            setDrawingColor(textViewCanvas, self:style():shadowColor())
            textViewCanvas:drawText(drawingCursor.x + 1, drawingCursor.y + 1, thetext[i])
            setDrawingColor(textViewCanvas, self:style():fontColor())

            local fc = self:style():fontColor()
            textViewCanvas:attrColor(fc:r(), fc:g(), fc:b(), fc:a())
            textViewCanvas:drawText(drawingCursor.x, drawingCursor.y, thetext[i])
            drawingCursor.x = drawingCursor.x + wordWidth + spaceWidth
            i = i + 1
            if(flagWidht)then
            	flagWidht=false
            	currentPosition = currentPosition -1
            	drawingCursor.y = drawingCursor.y + lineHeight
            	drawingCursor.x = self:paddingLeft()
            end
		elseif(tamanhoCarac>25)then
			auxWord = LString:new(thetext[i])
			
        	for k=tamanhoCarac,1,-1 do
        		local newWord=auxWord:substring(1,k):string()
        		
        		local newWordWidth = textViewCanvas:measureText(newWord)
        		if drawingCursor.x + newWordWidth < width then
	    			local newAux = auxWord:substring(k+1):string()
        			addItenInMidle(thetext,newAux,i+1)
        			thetext[i] = newWord
        			flagWidht=true
        			break
        		end
        	end
        else
            drawingCursor.y = drawingCursor.y + lineHeight
            drawingCursor.x = self:paddingLeft()
        end
    end

    drawingCursor.x = drawingCursor.x - spaceWidth

    lcanvas:compose(self:x(), self:y(), textViewCanvas)
end



