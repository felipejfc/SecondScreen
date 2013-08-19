--- Represents a style.
require(SB_REQUIRE_LUAGUI .. "widgets.Utils")
require(SB_REQUIRE_LUAGUI .. "widgets.Color")
require(SB_REQUIRE_LUAGUI .. "widgets.Object")


Style = inheritsFrom(Object)

--- Background attribute of the Style.
--Default: Color:new(150, 150, 150, 255)
Style._backgroundColor = Color:new(150, 150, 150, 255)

--- Font color attribute of the Style.
--Default: Color:new(255, 255, 255, 255)
Style._fontColor = Color:new(255, 255, 255, 255)

--- Frame color of the Style.
--Default: Color:new(  0,   0,   0, 255)
Style._frameColor = Color:new(  0,   0,   0, 255)

--- Background of selected text.
--Default: Color:new(170, 170, 170, 255)
Style._selectedTextBackground = Color:new(170, 170, 170, 255)

--- Color of selected text.
--Default: Color:new(255, 255, 255, 255)
Style._selectedTextColor = Color:new(255, 255, 255, 255)

--- Shadow color of the style.
--Default: Color:new(  0,   0,   0, 150)
Style._shadowColor = Color:new(  0,   0,   0, 150)

--- Font of the style.
--Default: Tiresias
Style._fontFace = 'Lato'

--- Font size of the style.
--Default: 16
Style._fontSize = 16

--- Path to the Image for the Style background.
--Default: (blank)
Style._backgroundImage = ''

--- Foccus color of the Style.
--Default: Color:new(200, 0, 0, 255)
Style._foccusColor = Color:new(200, 0, 0, 255)


--- Gets or sets the foccusColor attribute.
--@name Style:foccusColor()
--@param value Color to be used.
--@return self or the current foccusColor.
Style.foccusColor = accessorFor("_foccusColor")

--- Returns true if each field of this style is equal to the corresponding field
-- of another style.
--
-- @param other Another Style.
-- @return true, if the styles are equal, or false.
function Style:equals(other)
    if type(other) ~= 'table' or not other.isA or not other:isA(Style) then
        return false
    end

    for k,v in pairs(self) do
        if not other[k] or (v ~= other[k]) then return false end
    end

    return true
end

--- Style metatable.
local StyleMt = {
    __index = Style,
    __eq = Style.equals,
}

--- Instanciates a new Style object.
-- Can also be used to clone an existing style.
--
-- @param s Another Style (to clone it) or nil.
-- @return Then new Style.
function Style:new(s)
    local style = {}
    local src = s or Style

    for k, v in pairs(src) do
        if type(v) == 'table' and nil ~= v.isAn and v:isAn(Object) then
            local vClass = v:class()
            style[k] = vClass:new(v)
        else
            style[k] = v
        end
    end

    return setmetatable(style, StyleMt)
end

--- Returns or modifies the color of the background of a given Style.
--
-- @param color nil to read the backgroundColor, or a color to modify it.
-- @return the backgroundColor if color == nil, or self otherwise.
function Style:backgroundColor(color)
    if color then
        assert (color.class and color:class() == Color.class())
        self._backgroundColor = Color:new(color)
        return self
    else
        return self._backgroundColor
    end
end

--- Returns or modifies the color of the font of a given Style.
--
-- @param color nil to read the fontColor, or a color to modify it.
-- @return the fontColor if color == nil, or self otherwise.
function Style:fontColor(color)
    if color then
        assert (color.class and color:class() == Color.class())
        self._fontColor = Color:new(color)
        return self
    else
        return self._fontColor
    end
end

--- Returns or modifies the color of the frame of a given Style.
--
-- @param color nil to read the frameColor, or a color to modify it.
-- @return the frameColor if color == nil, or self otherwise.
function Style:frameColor(color)
    if color then
        assert (color.class and color:class() == Color.class())
        self._frameColor = Color:new(color)
        return self
    else
        return self._frameColor
    end
end

--- Returns or modifies the color of the background of the selected text of a
-- given Style.
--
-- @param color nil to read the selectedTextBackground, or a color to modify
-- it.
-- @return the selectedTextBackground if color == nil, or self otherwise.
function Style:selectedTextBackground(color)
    if color then
        assert (color.class and color:class() == Color.class())
        self._selectedTextBackground = Color:new(color)
        return self
    else
        return self._selectedTextBackground
    end
end

--- Returns or modifies the color of the selected text of a given Style.
--
-- @param color nil to read the selectedTextColor, or a color to modify it.
-- @return the selectedTextColor if color == nil, or self otherwise.
function Style:selectedTextColor(color)
    if color then
        assert (color.class and color:class() == Color.class())
        self._selectedTextColor = Color:new(color)
        return self
    else
        return self._selectedTextColor
    end
end

--- Returns or modifies the color of the shadow of a given Style.
--
-- @param color nil to read the shadowColor, or a color to modify it.
-- @return the shadowColor if color == nil, or self otherwise.
function Style:shadowColor(color)
    if color then
        assert (color.class and color:class() == Color.class())
        self._shadowColor = Color:new(color)
        return self
    else
        return self._shadowColor
    end
end

--- Returns or modifies the face of the font of a given Style.
--
-- @param face nil to read the fontFace, or a color to modify it.
-- @return the fontFace if face == nil, or self otherwise.
function Style:fontFace(face)
    if face then
        assert (type(face) == 'string')
        if (face ~= '') then
            self._fontFace = face
        else
            self._fontFace = 'Lato'
        end
        return self
    else
        return self._fontFace
    end
end

--- Returns or modifies the font size of a given Style.
--
-- @param size nil to read the fontSize, or a positive number to modify it.
-- @return the fontSize if size == nil, or self otherwise.
function Style:fontSize(size)
    if size then
        assert (type(size) == 'number' and size > 0)
        self._fontSize = size
        return self
    else
        return self._fontSize
    end
end

--- Returns or modifies the background image of a given Style.
--
-- @param path nil to read the backgroundImage, or a string with the image path
-- to modify it.
-- @return the path to the backgroundImage if path == nil, or self otherwise.
function Style:backgroundImage(path)
    if path then
        assert(type(path) == 'string', 'path must be a string')
        assert(Utils.isReadable(path) ,"File isn't readable")
        self._backgroundImage = path

        return self
    else
        return self._backgroundImage
    end
end

