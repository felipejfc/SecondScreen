require(SB_REQUIRE_LUAGUI .. "widgets.Layout")

GridLayout = inheritsFrom(Layout)

local function positiveInteger(x)
    return (type(x) == 'number') and (math.floor(x) == x) and (x > 0)
end

function GridLayout:new(parent)
    local newLayout = {}

    local src = GridLayout

    for k, v in pairs(src) do
        if type(v) == 'table' and nil ~= v.isAn and v:isAn(Object) then
            local vClass = v:class()
            newLayout[k] = vClass:new(v)
        else
            newLayout[k] = src[k]
        end
    end

    setmetatable(newLayout, LinearLayoutMt)

    if nil ~= parent and parent.isA and parent:isA(Drawable) then
        newLayout:x(parent:x())
            :y(parent:y())
            :width(parent:width())
            :height(parent:height())
        if parent.layout then parent:layout(newLayout) end
    end

    newLayout._children = {}

    return newLayout
end

function GridLayout:children(i, j, drawable)
    assert(
        positiveInteger(i) and positiveInteger(j),
        "i and j must be positive integers"
        )

    if not drawable then
        if self._children[i] then
            return self._children[i][j]
        end
        return nil
    end

    if not self._children[i] then self._children[i] = {} end

    assert(drawable.draw)
    self._children[i][j] = drawable

    return self
end

function GridLayout:lineHeight(i)
    if not self._children[i] then
        return 0
    end

    local height = 0

    for k, v in pairs(self._children[i]) do
        print(height)
        if v:height() > height then height = v:height() end
    end

    return height
end

function GridLayout:columnWidth(i)
    local width = 0

    for k, v in pairs(self._children) do
        print(width)
        if v[i] and width < v[i]:width() then
            width = v[i]
        end
    end

    return width
end

function GridLayout:draw(lcanvas)
    local lcanvas = lcanvas or canvas

    local x = 0
    local y = 0

    for k, v in pairs(self._children) do
        for l, u in pairs(v) do
            u:x(x)
            u:y(y)
            u:draw(lcanvas)
            x = x + GridLayout:columnWidth(l)
        end
        x = 0
        y = y + GridLayout:lineHeight(k)
    end
end
