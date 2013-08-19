--- Enumerations module
--

--- Creates a new enum with the given names of constants
--
-- @param names a table with the names of the constants
--
-- @usage
--
-- WeekDays = enum {
--      "Monday",
--      "Tuesday",
--      "Wednesday",
--      "Thursday",
--      "Friday",
--      "Saturday",
--      "Sunday"
--      }
function enum( names )
    local __enumID=0;
    local t={}
    for _,k in ipairs(names) do
        t[k]=__enumID
        __enumID = __enumID+1
    end
    return t
end

