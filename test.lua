
local mextras = require "init"
print(_VERSION)

local history = {}
local fail = "%s test failed at line %d. Error: %s"
local succeed = "%s test successful"
local totals = {[fail] = 0, [succeed] = 0}

local function test(label, test, expect)
	if expect == nil then expect = true end
	local status, msg = pcall(test)
	local phrase = (not status or msg ~= expect) and fail or succeed
	totals[phrase] = totals[phrase] + 1
	table.insert(history,
		string.format(phrase, label, debug.getinfo(2).currentline, msg)
	)
end


test(
	"factorial",
	function()
		local answers = {1, 2, 6, 24, 120, 720}
		for i = 1, #answers do
			if mextras.factorial(i) ~= answers[i] then
				return false
			end
		end
		return true
	end
)

test(
	"sign",
	function()
		local signs = {
			{ 4,  1},
			{ 1,  1},
			{ 0,  0},
			{-1, -1},
			{-5, -1}
		}

		for i, v in ipairs(signs) do
			if mextras.sign(v[1]) ~= v[2] then
				return false
			end
		end
		return true
	end
)

test(
	"clamp",
	function()
		local tests = {
			{1, 2, 5, 2},
			{3, 1, 6, 3},
			{4, 1, 4, 4},
			{6, 2, 4, 4}
		}

		for k, v in ipairs(tests) do
			if mextras.clamp(v[1], v[2], v[3]) ~= v[4] then
				return false
			end
		end
		return true
	end
)

test(
	"round",
	function()
		local tests = {
			{2.3, 1, 2.3},
			{5.6, 0, 6},
			{10.5, 0, 11},
			{10500.2234898, 5, 10500.22349},
			{0, 1, 0},
			{-1354.925457, 2, -1354.93}
		}
		for k, v in ipairs(tests) do
			if mextras.round(v[1], v[2]) ~= v[3] then
				return false
			end
		end
		return true
	end
)

test(
	"inRange",
	function()
		local Ttests = {
			{2, 2, 3},
			{3, 2, 3},
			{19, 10, 30},
			{100, 49, 1000}
		}
		for k, v in ipairs(Ttests) do
			if not mextras.inRange(v[1], v[2], v[3]) then
				return false
			end
		end

		local Ftests = {
			{1, 2, 3},
			{1.99, 2, 3},
			{6.01, 1, 6},
			{1000, 49, 100}
		}
		for k, v in ipairs(Ftests) do
			if mextras.inRange(v[1], v[2], v[3]) then
				return false
			end
		end
		return true
	end
)

test(
	"converge",
	function()
		local tests = {
			{2, 10, 3, 5},
			{3, 20, 3, 6},
			{19, 10, 30, -11},
			{68, 49, 3, 65},
			{19, 10, 0, 19}
		}
		for k, v in ipairs(tests) do
			if mextras.converge(v[1], v[2], v[3], false) ~= v[4] then
				print(v[1], v[2], v[3], v[4], mextras.converge(v[1], v[2], v[3], v[4]))
				return false
			end
		end

		return true
	end
)

test(
	"convergeStopper",
	function()
		local tests = {
			{2, 10, 3, 5},
			{3, 20, 30, 20},
			{19, 10, 30, 10},
			{68, 49, 3, 65}
		}
		for k, v in ipairs(tests) do
			if mextras.converge(v[1], v[2], v[3], true) ~= v[4] then
				print(v[1], v[2], v[3], v[4], mextras.converge(v[1], v[2], v[3], v[4]))
				return false
			end
		end

		return true
	end
)

test(
	"center",
	function()
		local tests = {
			{35, 100, 32.5},
			{86, 100, 7},
			{76, 100, 12},
			{ 1, 100, 49.5}
		}
		for k, v in ipairs(tests) do
			if mextras.center(v[1], v[2]) ~= v[3] then
				return false
			end
		end

		return true
	end
)

test(
	"map",
	function()
		local tests = {
			{50, 0, 100, 0, 1, false, 0.5},
			{25, 0, 100, 0, 1, false, 0.25},
			{75, 0, 100, 0, 1, false, 0.75},
			{100, 0, 100, 0, 1, false, 1},
			{0, 0, 100, 0, 1, false, 0},
			{120, 0, 100, 0, 1, true, 1},
			{-10, 0, 100, 0, 1, true, 0},
			{200, 0, 100, 0, 1, true, 1},
		}
		for k, v in ipairs(tests) do
			if mextras.map(v[1], v[2], v[3], v[4], v[5], v[6]) ~= v[7] then
				return false
			end
		end

		return true
	end
)


test(
	"fSqrt",
	function()
		for i = 1, 100 do
			local t = math.random(1, 10000)
			if mextras.fSqrt(t) ~= math.sqrt(t) then
				return false
			end
		end
		return true
	end
)

test(
	"dist",
	function()
		local tests = {
			{0, 0, 0, 0, false, 0},
			{0, 0, 3, 4, false, 5},
			{2, 3, 5, 7, false, 5},
			{-2, -3, -5, -7, false, 5},
			{1, 1, 1, 1, false, 0},
			{0, 0, 3, 4, true, 25},
			{1, 1, 1, 1, true, 0},
		}
		for k, v in ipairs(tests) do
			if mextras.dist(v[1], v[2], v[3], v[4], v[5]) ~= v[6] then
				print(k, v[6], mextras.dist(v[1], v[2], v[3], v[4], v[5]))
				return false
			end
		end

		return true
	end
)


test(
	"degrees",
	function()
		local tests = {
			{0, 0},
			{math.pi, 180},
			{math.pi / 2, 90},
			{math.pi * 2, 360},
			{math.pi / 4, 45},
			{math.pi / 6, 30.0},
			{math.pi * 1.5, 270},
			{-math.pi, -180},
			{-math.pi / 2, -90},
			{-math.pi * 2, -360},
		}
		for k, v in ipairs(tests) do
			if mextras.degrees(v[1]) ~= v[2] then
				-- print(k, v[1], mextras.degrees(v[1]))
				--! Dealing with floating point shinanigans!!!
				print(mextras.degrees(v[1]), v[2])
				print(mextras.degrees(v[1]) - v[2])
				return false
			end
		end

		return true
	end
)


test(
	"radians",
	function()
		local tests = {
			{0, 0},
			{180, math.pi},
			{90, math.pi / 2},
			{360, math.pi * 2},
			{45, math.pi / 4},
			{30, math.pi / 6},
			{270, math.pi * 1.5},
			{-180, -math.pi},
			{-90, -math.pi / 2},
			{-360, -math.pi * 2},
		}
		for k, v in ipairs(tests) do
			if mextras.radians(v[1]) ~= v[2] then
				return false
			end
		end

		return true
	end
)


test(
	"average",
	function()
		-- mextras.average()
		return false
	end
)

test(
	"lerp",
	function()
		-- mextras.lerp()
		return false
	end
)

test(
	"deadzone",
	function()
		-- mextras.deadzone()
		return false
	end
)

test(
	"threshold",
	function()
		-- mextras.threshold()
		return false
	end
)

test(
	"tolerance",
	function()
		-- mextras.tolerance()
		return false
	end
)

for k,v in ipairs(history) do
	print(k, v)
end
print()
print(("Total Successful: %d - Total Fails: %d"):format(totals[succeed], totals[fail]))