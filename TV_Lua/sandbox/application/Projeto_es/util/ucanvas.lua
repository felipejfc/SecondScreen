local ustring = require(SB_REQUIRE_UTIL .."ustring")
local old_canvas = _G["canvas"]
local new_canvas = {}	

local border_x = 0
local border_y = 0
local min_x = 0
local min_y = 0
local max_width = 0
local max_height = 0

new_canvas.get_old_canvas = function()	
	_G["canvas"] = old_canvas
end

new_canvas.new = function(self, ...)
	
	return old_canvas:new(...)
end

new_canvas.attrSize = function(self)
	return old_canvas:attrSize()
end

new_canvas.attrColor = function(self, ...)
	return old_canvas:attrColor(...)
end

new_canvas.attrClip = function(self, ...)
	local info = debug.getinfo(2)
	local caller = ustring.last_path_name(info.source)
	if (caller == "smartbar_main") then
		return old_canvas:attrClip(...)		
	end	
end

new_canvas.attrCrop = function(self, ...)
	print("self",  ...)
	--return old_canvas:attrCrop(...)
end

new_canvas.attrFont = function(self, ...)	
	return old_canvas:attrFont(...)
end

new_canvas.drawLine = function(self, x1, y1, x2, y2)
	if (border_x == nil) then border_x = 0 end
	if (border_y == nil) then border_y = 0 end
	
	return old_canvas:drawLine(x1 + border_x, y1 + border_y, x2 + border_x, y2 + border_y)
end

new_canvas.drawRect = function(self, mode, x, y, width, height)
	if (border_x == nil) then border_x = 0 end
	if (border_y == nil) then border_y = 0 end
	
	return old_canvas:drawRect(mode, x + border_x, y + border_y, width, height)
end

new_canvas.drawText = function(self, x, y, text)
	if (border_x == nil) then border_x = 0 end
	if (border_y == nil) then border_y = 0 end

	return old_canvas:drawText(x + border_x, y + border_y, text)
end

new_canvas.measureText = function(self, text)
	return old_canvas:measureText(text)
end

new_canvas.compose = function(self, x, y, canvas_src)
	if (border_x == nil) then border_x = 0 end
	if (border_y == nil) then border_y = 0 end
	
	return old_canvas:compose(x + border_x, y + border_y, canvas_src)
end

new_canvas.flush = function(self)
	return old_canvas:flush()
end

new_canvas.clear = function(self, x, y, wight, height)
	return old_canvas:clear(x, y, wight, height)
end

new_canvas.drawLabel = function (self, x, y, text, style)
	require(SB_REQUIRE_UTIL .."label")  -- a component, usually described in its own file	
	style = style or styles.normal
	-- Now we will create 1 label
	local l1 = Label:new(text)
		
	-- Initializing the labels
	l1.x = x
	l1.y = y
	l1.w = 120
	l1.h = 30
	
	-- initializing the screen
	l1:setStyle(style)
	l1:paint()
	return l1
end

new_canvas.clearDrawArea = function (self, x, y, wight, height)
	-- clear the canvas
	canvas:attrColor(0,0,0,0)
	canvas:clear(x, y, wight, height)		
end

return new_canvas
