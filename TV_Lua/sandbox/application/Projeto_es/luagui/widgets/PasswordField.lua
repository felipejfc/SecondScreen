--- Class representing a PasswordField widget.
require(SB_REQUIRE_LUAGUI .. "widgets.TextEdit")

local INPUT_END = -1

PasswordField = inheritsFrom(TextEdit)

--- Mask to be used on the PasswordField.
--Default: '*'
PasswordField._mask = "*"

--- Attribute that holds the password value.
--Default: (blank)
PasswordField._password = ''

--- Attribute that defines if the PasswordField is an one line.
--Default: true
PasswordField._oneline = true

-- PasswordField metatable.
-- -
local PasswordFieldMt = { __index = PasswordField }

--- Instantiates a new PasswordField object or clones another one.
--
--@param t PasswordField to clone.
function PasswordField:new(t)
    local newPasswordField = {}
    local src = t or PasswordField

    for k, v in pairs(src) do
        if type(v) == 'table' and nil ~= v.isAn and v:isAn(Object) then
            local vClass = v:class()
            newPasswordField[k] = vClass:new(v)
        else
            newPasswordField[k] = src[k]
        end
    end

    return setmetatable(newPasswordField, PasswordFieldMt)
end

--- Gets or sets the the current mask symbol.
--
--@param value new mask to be used.
--@return self or the current mask symbol.
PasswordField.mask = accessorFor(
    "_mask",
    function (m) return type(m) == 'string' end
    )

--- Gets or sets the password.
--
--@param value password to be set.
--@return self or the current password.
PasswordField.password = accessorFor(
    "_password",
    function(p) return type(p) == 'string' end
    )

--- Appends the given string or character to the password.
--
--@param value string or character to be appended.
--@return self
function PasswordField:append(value)
    self:password(self:password() .. value)
    return self
end

--- Deletes the last character of the password.
--
--@return self
function PasswordField:backspace()
	if self:cursor() == 1 then return end
	local auxPass=LString:new(self:password())
	local count = auxPass:length()
    if self:cursor() > count then
        self:password(auxPass:substring(1 , self:cursor() - 2):string())
    else
        local head = auxPass:substring(1 , self:cursor() - 2):string()
        local tail = auxPass:substring(self:cursor(), count):string()

        self:password(head .. tail)
    end

    self:cursor(self:cursor() - 1)
    return self
end

--- Clears the password.
--
--@return self
function PasswordField:clear()
    self:password('')
    return self
end

--- Method to insert content on the text field.
--@param value The content to be inserted.
--@return self
function PasswordField:insert(value)
    assert(type(value) == "string")
	local newPass = LString:new(self._password)
    local left = newPass:substring(1, self:cursor() - 1)
    local right = newPass:substring(self:cursor())
    self:clear()
    self._password=left:append(value):append(right):string()
    self._cursor=self._cursor + 1
    return self
end

--- Draws the PasswordField on the given canvas.
--
--@param lcanvas Target canvas to draw on.
function PasswordField:draw(lcanvas)
    local lcanvas = lcanvas or canvas
	local count = LString:new(self:password()):length()
    self:text(string.rep(self:mask(),count))
    TextEdit.draw(self, lcanvas)
end

