--- Module that contains ButtonStyle class.
--it defines the button style regarding colors and other visual aspects.
require(SB_REQUIRE_LUAGUI .. "widgets.Style")

ButtonStyle = inheritsFrom(Style)

--- ButtonStyle metatable.
local ButtonStyleMt = {
    __index = ButtonStyle
}

--- Pressed image path.
ButtonStyle._pressedImage = ''

--- Foccused image path.
ButtonStyle._foccusedImage = ''

--- Default image path.
ButtonStyle._default = ''

--- Instantiates a new ButtonStyle.
function ButtonStyle:new()
    local newButtonStyle = {}

    local src = Style
    for k, v in pairs(src) do
        if type(v) == 'table' and nil ~= v.isAn and v:isAn(Object) then
            local vClass = v:class()
            newButtonStyle[k] = vClass:new(v)
        else
            newButtonStyle[k] = src[k]
        end
    end

    setmetatable(newButtonStyle, ButtonStyleMt)
    return newButtonStyle
end

--- Attribute accessor for pressed image path.
--@param newPath String containing the path to the file representing a pressed
--button.
--@return self or the current path for the current file representing a pressed
--button.
--@name <pressedImage>
ButtonStyle.pressedImage = accessorFor("_pressedImage")

--- Attribute accessor for foccused image path.
--@param newPath String containing the path to the file representing a foccused
--button.
--@return self or the current path for the current file representing a foccused
--button.
--@name <foccusedImage>
ButtonStyle.foccusedImage = accessorFor("_foccusedImage")

--- Attribute accessor for default image path.
--@param newPath String containing the path to the file representing a default
--button.
--@return self or the current path for the current file representing a default
--button.
--@name <defaultImage>
ButtonStyle.defaultImage = accessorFor("_defaultImage")

--- Sets all the three status images of the button.
--@param pressed String containing the path to the file representing a pressed
--button.
--@param foccused String containing the path to the file representing a foccused
--button.
--@param default String containing the path to the file representing a default
--button.
--@return self or the current path for the current file representing a default
--button.
--@name <defaultImage>
function ButtonStyle:setImages(pressed, foccused, default)
    self:pressedImage(pressed)
    self:foccusedImage(foccused)
    self:defaultImage(default)
    return self
end

