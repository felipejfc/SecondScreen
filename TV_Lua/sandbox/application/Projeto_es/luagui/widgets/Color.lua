--- Represents a color.
require(SB_REQUIRE_LUAGUI .. "widgets.Object")

Color = inheritsFrom(Object)

--- Color red component.
--Default: 0
Color.r = 0

--- Color green component.
--Default: 0
Color.g = 0

--- Color blue component.
--Default: 0
Color.b = 0

--- Color alpha component.
--Default: 255
Color.a = 255

--- Color metatable
local ColorMt = {
    __index = Color,
    _type = 'Color'
}

--- Returns true if the value of each channel of this color is equal to the
-- value of the corresponding field of the other color.
--
-- @param other The color to compare.
-- @return true if this color is equal to the other, or false.
function Color:equals(other)
    if (not other) or (not other.class) or (other.class() ~= Color.class()) then
        return false
    end

    return self:r() == other:r() and
    self:g() == other:g() and
    self:b() == other:b() and
    self:a() == other:a()
end
ColorMt.__eq = Color.equals

--- Fails if the type one of the parameters is neither number or nil.
--
-- @param ... table with arguments to verify
-- @return nil
local function assertNilOrNumber(...)
    for k, v in pairs(...) do
        assert(type(v) == 'number' or type(v) == 'nil')
    end
end

--- Fixes a parameter to match range [0, 255].
--
-- @param n number to fix.
-- @return 0 if n < 0, 255 if n > 0 or n if 0 <= n <= 255.
local function fixed(n)
    if n < 0 then
        return 0
    elseif n > 255 then
        return 255
    else return n
    end
end

--- Instanciates a new Color object.
-- @param r Red value.
-- @param g Green value.
-- @param b Blue value.
-- @param a Alpha value.
function Color:new(r, g, b, a)
    local color = {}
    if type(r) == 'table' then
        assert(r.class and r.class() == Color.class())
        color._r = r:r() or Color.r
        color._g = r:g() or Color.g
        color._b = r:b() or Color.b
        color._a = r:a() or Color.a

    else assertNilOrNumber({r, g, b, a})

        color._r = r or Color.r
        color._g = g or Color.g
        color._b = b or Color.b
        color._a = a or Color.a
    end

    return setmetatable(color, ColorMt)
end

--- Returns the value of the red channel, if nil is given, or changes it, if
-- value is a number.
--
-- @param nil or a number in range [0, 255].
-- @return The current value of the red channel, if value == nil, or self
-- otherwise.
function Color:r(value)
    assertNilOrNumber({value})

    if value then
        self._r = fixed(value)
        return self
    else
        return self._r
    end
end

--- Returns the value of the green channel, if nil is given, or changes it, if
-- value is a number.
--
-- @param nil or a number in range [0, 255].
-- @return The current value of the green channel, if value == nil, or self
-- otherwise.
function Color:g(value)
    assertNilOrNumber({value})

    if value then
        self._g = fixed(value)
        return self
    else
        return self._g
    end
end

--- Returns the value of the blue channel, if nil is given, or changes it, if
-- value is a number.
--
-- @param nil or a number in range [0, 255].
-- @return The current value of the blue channel, if value == nil, or self
-- otherwise.
function Color:b(value)
    assertNilOrNumber({value})

    if value then
        self._b = fixed(value)
        return self
    else
        return self._b
    end
end

--- Returns the value of the alpha channel, if nil is given, or changes it, if
-- value is a number.
--
-- @param nil or a number in range [0, 255].
-- @return The current value of the alpha channel, if value == nil, or self
-- otherwise.
function Color:a(value)
    assertNilOrNumber({value})

    if value then
        self._a = fixed(value)
        return self
    else
        return self._a
    end
end

