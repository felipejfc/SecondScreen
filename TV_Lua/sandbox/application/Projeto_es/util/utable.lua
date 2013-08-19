local utable = {}

utable.containsItem = function (tableSet, item)
	for _, v in pairs(tableSet) do 
		if(v == item) then
			return true
		end
	end
	return false
end


return utable