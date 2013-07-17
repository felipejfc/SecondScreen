local main = {}
local fastTime = false
local language = nil

main.init = function()	
	require("application")
	require("config")
	require("remoteControl")
	
	mock = MOCK
	
	--[[	
	require(SB_REQUIRE_CODE_SRC .. "smartbarMain")	
	local res, msg = pcall(runSmartbarMain)
	if (not res) then
	print(msg)
	end --]]	
	
	-- [[	
	require(SB_REQUIRE_CODE_SRC .. "view.loginView")	
	local res, msg = pcall(runLoginView)
	if (not res) then
	print(msg)
	end --]]

	--[[
	require(SB_REQUIRE_CODE_SRC .. "view.settingsMainView")
	local res, msg = pcall(runMainSettings) 
	if (not res) then
	print(msg)
	end --]]

end





local time = nil
function generateTimestamp()
	if(time == nil)then
		local http = require("socket.http")
		b = http.request("http://morpheus.embedded.ufcg.edu.br/mmi/time.aspx")
		
		if b == nil then b = "1357757259 UTC" end 
		
		aa, bb = string.find(b,"UTC")
		time = time or string.sub(b,aa-11,aa-1);
		
		time = tonumber(time) - 10800
		-- O servidor agora retorna o timestamp UTC não precisa mais dessa correção...
		updateTime()
	end
	return tostring(tonumber(time))
end



function updateTime()

	event.timer(1000,
		function ()
			if(not fastTime) then
				time=time+1
			else
				time=time+61
			end
			updateTime()
		end
	)

end
return main
