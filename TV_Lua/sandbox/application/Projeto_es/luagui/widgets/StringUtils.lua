require(SB_REQUIRE_LUAGUI .. "widgets.Object")

String = inheritsFrom(Object)

local StringMt = { __index = String }

function length(s) end
function isAscii(s) end
function specialCharacters(s) end
function sub(s) end

