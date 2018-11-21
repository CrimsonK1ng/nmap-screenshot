description = [[
Gets a screenshot from the host
]]

---
--@output
--PORT  STATE SERVICE
-- 80/tcp open  http
--
--p
--80/tcp  open  http
--| http-screenshot:
--|_  Saved to screenshot-nmap-127.0.0.1:80.png
--443/tcp open  https
--| http-screenshot:
--|_  failed (verify wkhtmltoimage-i386 is in your path)
--@args tool The tool used to gather the screenshots. Will output as above if tool is not installed
--@args useget Set to force GET requests instead of HEAD.

author = "Al Straumann aleksandar.straumann protonmail"

license = "GPLv2"

categories = {"discovery", "safe"}

-- Updated the NSE Script imports and variable declarations
local shortport = require "shortport"
local nmap = require "nmap"
local stdnse = require "stdnse"

portrule = shortport.http

action = function(host, port)
    -- Get arguments supplied to file
    local tool = stdnse.get_script_args(SCRIPT_NAME..".tool") or "wkhtmltoimage"
	-- Check to see if ssl is enabled, if it is, this will be set to "ssl"
	local ssl = port.version.service_tunnel

	-- The default URLs will start with http://
	local prefix = "http"

	-- Screenshots will be called screenshot-namp-<IP>:<port>.png
    local filename = "screenshot-nmap-" .. host.ip .. "-" .. port.number .. ".png"
	
	-- If SSL is set on the port, switch the prefix to https
	if ssl == "ssl" then
		prefix = "https"	
	end

	-- Default execute the shell command wkhtmltoimage <url> <filename>
	local cmd = "wkhtmltoimage -n " .. prefix .. "://" .. host.ip .. ":" .. port.number .. " " .. filename .. " 2> /dev/null   >/dev/null"

    -- This reflects the updated version 12 of wkhtml
    if string.match(tool, "wkhtmltoimage") then
	    cmd = "wkhtmltoimage -n " .. prefix .. "://" .. host.ip .. ":" .. port.number .. " " .. filename .. " 2> /dev/null   >/dev/null"
    elseif string.match(tool, "chromium-browser") then
        cmd="chromium-browser --no-sandbox --headless --screenshot=" .. filename .. " " .. prefix .. "://" .. host.ip .. ":" .. port.number .. " 2> /dev/null   >/dev/null"
    elseif string.match(tool, "chrome") then
        cmd="chrome --headless --disable-gpu --screenshot=" .. filename .." --window-size=1280,1696 " .. prefix .. "://" .. host.ip .. ":" .. port.number .. " 2> /dev/null >/dev/null"
    elseif string.match(tool, "firefox") then
        cmd="firefox -screenshot " .. filename .. " " .. prefix .. "://" .. host.ip .. ":" .. port.number .. " 2> /dev/null   >/dev/null"
    end

	local ret = os.execute(cmd)

	-- If the command was successful, print the saved message, otherwise print the fail message
	local result = "failed (verify " ..tool.. " is in your path)"

	if ret then
		result = "Saved to " .. filename
	end

	-- Return the output message
	return stdnse.format_output(true,  result)

end
