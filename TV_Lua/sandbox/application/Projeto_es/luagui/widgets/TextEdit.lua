--- Class representing a TextEdit widget.
require(SB_REQUIRE_LUAGUI .. "widgets.TextView")

local INPUT_END = -1

TextEdit = inheritsFrom(TextView)

--- Hint text of the text edit.
--Default: "Type something".
TextEdit._hintText = LString:new("Type something")

--- Hint text style of the text edit.
--Default: Style default with fontColor as Color:new(130, 130, 130, 255)
TextEdit._hintTextStyle = Style:new()
        :fontColor(Color:new(130, 130, 130, 255))

--- TextEdit style.
--Default: Check the TextEdit.lua file.
TextEdit._style = Style:new()
        :backgroundColor(Color:new(255, 255, 255, 255))
        :fontColor(Color:new(0, 0, 0, 255))
        :shadowColor(Color:new(0, 0, 0, 0))

--- Input type of the text edit.
--Default: nil
TextEdit._inputType = nil

--- Attribute to determine if the cursor is visible or not on the TextEdit.
--Default: true
TextEdit._cursorVisible = true

--- TextEdit metatable.
local TextEditMt = { __index = TextEdit }

--- Instantiates a new TextEdit or clone another one.
--
--@param t TextEdit to be cloned.
function TextEdit:new(t)
    local newTextEdit = {}
    local src = TextEdit

    for k, v in pairs(src) do
        if type(v) == 'table' and nil ~= v.isAn and v:isAn(Object) then
            local vClass = v:class()
            newTextEdit[k] = vClass:new(v)
        else
            newTextEdit[k] = src[k]
        end
    end

    newTextEdit._hintText = LString:new(TextEdit._hintText:string())
    newTextEdit._text = LString:new(t or '')

    return setmetatable(newTextEdit, TextEditMt)
end

--- Appends a string or character to the TextEdit text.
--
--@param src String to be appended.
--@return self
function TextEdit:append(src)
    self._text:append(src)
    return self
end

--- Deletes the last character on the TextEdit text.
--
--@return self
function TextEdit:backspace()
    if self:cursor() == 1 then return end
    if self:cursor() > self._text:length() then
        self:text(self._text:substring(1 , self:cursor() - 2):string())
    else
        local head = self._text:substring(1 , self:cursor() - 2):string()
        local tail = self._text:substring(self:cursor(), self._text:length()):string()

        self:text(head .. tail)
    end

    self:cursor(self:cursor() - 1)

    return self
end

--- Clears the TextEdit text field.
--
--@return self
function TextEdit:clear()
    self:text(LString:new(""))
    return self
end

--- Method to insert content on the text field.
--@param value The content to be inserted.
--@return self
function TextEdit:insert(value)
    assert(type(value) == "string")

    local left = self._text:substring(1, self:cursor() - 1)
    local right = self._text:substring(self:cursor())

    self:clear()
    self:text(left:append(value):append(right):string())
    self:cursor(self:cursor() + 1)

    return self
end

--- Gets or sets the hint text.
--
--@param value the new hint text.
--@return self or the current hint text.
function TextEdit:hintText(value)
    if value then
        self._hintText = value
        return self
    else
        return self._hintText
    end
end

--- Draws the TextEdit on the given canvas.
--
--@param lcanvas Target canvas to draw on.
function TextEdit:draw(lcanvas)
    if not self:visible() then return end

    local lcanvas = lcanvas or canvas

    TextView.draw(self, lcanvas)
end

--- TextEdit handler to be used when a key is pressed.
--@param keyEvent The key event.
function TextEdit:onKeyPress(keyEvent)
    local key = keyEvent:key()

    if key:keyType() == KeyType.EDITING_KEY then
        if key:values()[1] == 'bksp' then
            self:backspace()
        end

    elseif key:keyType() == KeyType.CHARACTER_KEY then
        self:insert(keyEvent:text())

    elseif key:keyType() == KeyType.NAVIGATION_KEY then
        if key:values()[1] == '←' then
            self:cursor(self:cursor() - 1)
        elseif key:values()[1] == '→' then
            self:cursor(self:cursor() + 1)
        end
    end
end

