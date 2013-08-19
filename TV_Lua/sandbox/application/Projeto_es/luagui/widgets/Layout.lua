--- Layout class.
require(SB_REQUIRE_LUAGUI .. "widgets.Drawable")

Layout = inheritsFrom(Drawable)

--- Parent of the layout.
--Default: nil
Layout._parent = nil

--- Children of the layout.
--Default: empty table
Layout._children = {}

--- Width of the layout.
--Default: 100
--@see Drawable._width
Layout._width = 100

--- Height of the layout.
--Default: 100
--@see Drawable._height
Layout._height = 100

--- Layout metatable.
local LayoutMt = { __index = Layout }

--- Instantiates a new layout or clone a given one.
--@param l Layout to be cloned or nil.
--@return Layout object.
function Layout:new(l)
    local newLayout = {}

    local src = l or Layout

    for k, v in pairs(src) do
        if type(v) == 'table' and nil ~= v.isAn and v:isAn(Object) then
            local vClass = v:class()
            newLayout[k] = vClass:new(v)
        else
            newLayout[k] = src[k]
        end
    end

    return setmetatable(newLayout, LayoutMt)
end

--- Getter and setter for the parent.
--@param value Parent to be set.
--@return self or the current parent.
--@name Layout:parent()
Layout.parent = accessorFor("_parent",
        function(value)
            if not value.parent then return self ~= value end

            local current = value:parent()

            while nil ~= current do
                if self == current then return false end
                if not current.parent then break end
                current = current:parent()
            end

            return true
        end
    )

--- Getter and setter for the children.
--@param child Child to be set.
--@return Children of the layout.
--@name Layout:children()
Layout.children = accessorFor("_children")

--- Adds a child to the layout children list.
--@param child Child to be added.
--@return self.
function Layout:add(child)
    assert(nil ~= child)
    assert(self ~= child)
    assert(child.draw)

    for k, v in pairs(self:children()) do
        assert(self ~= v)
    end

    table.insert(self._children, child)
    return self
end

--- Clears the layout children list.
--@return self.
function Layout:clear()
    self._children = {}
    return self
end

--- Abstract method to draw the layout.
--@param lcanvas Target canvas to draw on.
function Layout:draw(lcanvas) assert(false, 'This method is abstract') end

--- Returns the child at an index.
--@param i Position of the child to be fetched.
--@return Child on the given position if it exists, nil otherwise.
function Layout:childAt(i)
    return self:children()[i]
end

--- Returns the index of a given child.
--@param child Child to search the index for.
--@return Index of the child if available, nil otherwise.
function Layout:indexOf(child)
    for k, v in pairs(self:children()) do
        if v:equals(child) then
            return k
        end
    end

    return nil
end

--- Removes the given child of the layout children list.
--@param child Child to be removed.
--@return self.
function Layout:remove(child)
    return self:removeLayoutAt(self:indexOf(child))
end

--- Removes a child fron the given index.
--@return self.
function Layout:removeLayoutAt(index)
    table.remove(self._children, index)
    return self
end

