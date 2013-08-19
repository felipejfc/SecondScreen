local lfs = require("lfs")
local fs = {}

fs.attrLs = function (path)	
	local response = ""
	for file in lfs.dir(path) do		
		if file ~= "." and file ~= ".." then			
			local f = path..'/'..file
			response =  f .. ";" .. response 
		end
	end	
	return response
end

fs.attrDir = function (path)
	local response = ""
	for file in lfs.dir(path) do
		if file ~= "." and file ~= ".." then
			local f = path..'/'..file			
			local attr = lfs.attributes (f)			
			if attr.mode == "directory" then
				for file2 in lfs.dir(f) do
					if file2 ~= "." and file2 ~= ".." then
						local f2 = f..'/'..file2
						response =  f2 .. ";" .. response
						
					end
				end
			end
		end
	end
	return response
end

fs.sleep = function(miliseconds)
	local t0 = event.uptime ()
	while event.uptime () - t0 <= miliseconds do end
end

fs.delete = function(name)
   local mode = lfs.attributes(name, "mode")

   if mode == "file" then
      return os.remove(name)
   elseif mode == "directory" then
      for file in lfs.dir(name) do
         if file ~= "." and file ~= ".." then
         	local f = name..'/'..file         	
            local ok, err = fs.delete(f)
            if not ok then return nil, err end
         end
      end
      local ok, err = lfs.rmdir(name)
      if not ok then return nil, err end
   end
   return true
end

return fs