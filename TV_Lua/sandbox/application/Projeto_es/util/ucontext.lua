SMALL_CONTEXT = "SMALL"
EXTENDED_CONTEXT = "EXTENDED"

local ustring = require(SB_REQUIRE_UTIL .."ustring")
local context = {}
local x1, y1, weight1, height1 = 0, 0, 0, 0
local x2, y2, weight2, height2 = 0, 0, 0, 0 
local layout = SMALL_CONTEXT
local smartbarFile = "smartbarMain.lua"

context.layout = function()
	return layout
end

context.getCoordinates = function()
	return x1, y1, weight1, height1
end

context.getHorizontalCoordinates = function()
	return x2, y2, weight2, height2
end

context.setCoordinates = function(x, y, weight, height)
	local info = debug.getinfo(2)
	local caller = ustring.getFileName(info.source)
	
	if (caller == smartbarFile) then
		x1, y1, weight1, height1 = x, y, weight, height
	end	
end

context.setHorizontalCoordinates = function(x, y, weight, height)
	local info = debug.getinfo(2)
	local caller = ustring.getFileName(info.source)
	
	if (caller == smartbarFile) then
		x2, y2, weight2, height2 = x, y, weight, height
	end	
end

context.setLayout = function(layout2)
	local info = debug.getinfo(2)
	local caller = ustring.getFileName(info.source)
	
	if (caller == smartbarFile) then
		if ( layout2 == EXTENDED_CONTEXT ) then
			layout = EXTENDED_CONTEXT
			
		elseif ( layout2 == SMALL_CONTEXT ) then
			layout = SMALL_CONTEXT
		end		
	end	
end

return context