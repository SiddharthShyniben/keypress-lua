local function getch_unix()
	os.execute("stty -echo raw")
	os.execute("stty cbreak </dev/tty >/dev/tty 2>&1")
	local key = io.read(1)
	os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1")
	return key
end

local function get_key()
	local key = getch_unix()
	if utf8.codepoint(key) == 27 then
		getch_unix()
		local k = getch_unix()

		local map = {
			a = "up",
			b = "down",
			c = "left",
			d = "right",
		}

		return map[string.lower(k)]
	elseif utf8.codepoint(key) == 13 then
		return "enter"
	else
		return key
	end
end

----------------------------------------------------------------------
-- usage -------------------------------------------------------------
----------------------------------------------------------------------

local opts = {
	"Options",
	"Go",
	"Here",
	"Lol",
}

local i = 1

local function render()
	os.execute("clear") -- ansi escape code to clear screen
	for j, opt in ipairs(opts) do
		if i == j then
			print("\x1b[31m" .. opt .. "\x1b[0m")
		else
			print(opt)
		end
	end
end

render()
while true do
	local key = get_key()
	if key then
		if key == "down" then
			i = i + 1
			if i > 4 then
				i = 1
			end
		end

		if key == "up" then
			i = i - 1
			if i < 1 then
				i = 4
			end
		end

		if key == "enter" then
			io.write("\027[H\027[2J")
			print("you chose: " .. opts[i])
			break
		end

		render()
	end
end
