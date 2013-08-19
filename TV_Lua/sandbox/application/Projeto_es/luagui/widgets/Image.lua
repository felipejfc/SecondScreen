--- Class representing an Image

require(SB_REQUIRE_LUAGUI .. "widgets.Object")

Image = inheritsFrom(Object)

Image["_path"] = ""
Image["_lcanvas"] = nil

-- Image metatable.
local ImageMt = {
    __index = Image
}

--- Reads or sets the path of the image
--
--  @name Image:path()
--  @param path Path to the image file. Must be a string
--  @return The path to the image, if <code>path == nil</code>, or <code>
--  self</code>, otherwise
Image.path = accessorFor(
    "_path",
    function(path) return type(path) == 'string' end
    )


--- Reads or sets the canvas object
--
--  @name Image:lcanvas()
--  @param (optional) lcanvas The canvas to set.
--  @return The image (canvas) itself, if <code>lcanvas == nil</code>, or <code>
--  self</code>, otherwise
Image.lcanvas = accessorFor("_lcanvas")

--- Instantiates a new Image object.
--
--@param path a string containing the path to the image resource
function Image:new(path)
    local newImage = {}

    for k, v in pairs(Image) do
        if type(v) == 'table' and nil ~= v.isAn and v:isAn(Object) then
            local vClass = v:class()
            newImage[k] = vClass:new(v)
        else
            newImage[k] = Image[k]
        end
    end
    setmetatable(newImage, ImageMt)

    if path then newImage:path(path) end

    return newImage
end


--- Loads the image pointed by path, if any
--
-- @return <code>self</code>
function Image:loadImage()
    self:lcanvas(canvas:new(self:path()))
    return self
end

