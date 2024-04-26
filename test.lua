
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

local function ce(v1, v2)
	-- close enough
	return math.abs(v1 - v2) < 0.0000000001
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
	"wrap",
	function()
		local tests = {
			{1, 4, 1, 3, 2},
			{5, 20, 4, 8, 5},
			{-40, 3, -50, 40, -37},
			{1, 12, -5, 40, 13}
		}
		for k, v in ipairs(tests) do
			if mextras.wrap(v[1], v[2], v[3], v[4]) ~= v[5] then
				return false
			end
		end

		return true
	end
)

test(
	"difference",
	function()
		local tests = {
			{1, 5, 4},
			{2, 5, 3},
			{11, 5, 6},
			{321, 345, 24},
			{431, 345, 86},
			{231, 345, 114},
			{231, 587, 356},
			{-2341, 235, 2576},
			{-2341, -345, 1996},
			{1243, -235, 1478},
			{-834, 2345, 3179},
			{71, 53, 18},
			{81, 5, 76}
		}

		for k,v in ipairs(tests) do
			if not mextras.difference(v[1], v[2]) == v[3] then
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
			if not ce(mextras.fSqrt(t), math.sqrt(t)) then
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
			if not ce(mextras.degrees(v[1]), v[2]) then
				return false
			end
		end

		return true
	end
)

---deprecated, now testing lua function
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
		local tests = {
			{{1,2,3}, 2},
			{{{1,2,3}}, 2},
			{{15,20,31}, 22},
			{{{15,20,31}}, 22},
			{{20,20,30,33}, 25.75},
			{{{20,20,30,33}}, 25.75}
		}
		for k, v in ipairs(tests) do
			print(mextras.average(table.unpack(v[1])))
			if not mextras.average(table.unpack(v[1])) == v[2] then
				return false
			end
		end

		return true
	end
)

test(
	"lerp",
	function()
		local tests = {
			{0, 100, 0, 0},
			{0, 100, 0.25, 25},
			{0, 100, 0.5, 50},
			{0, 100, 0.75, 75},
			{0, 100, 1, 100},
			{-50, 50, 0, -50},
			{-50, 50, 0.5, 0},
			{-50, 50, 1, 50},
		}
		for k, v in ipairs(tests) do
			if mextras.lerp(v[1], v[2], v[3]) ~= v[4] then
				return false
			end
		end

		return true
	end
)

test(
	"deadzone",
	function()
		local tests = {
			{0, 0, 0},
			{10, 5, 10},
			{5, 5, 5},
			{20, 15, 20},
		}
		for k, v in ipairs(tests) do
			if mextras.deadzone(v[1], v[2]) ~= v[3] then
			  print(table.unpack(v))
			  print(mextras.deadzone(v[1], v[2]))
				return false
			end
		end

		return true
	end
)

test(
	"threshold",
	function()
		local tests = {
			{0, 0, true},
			{10, 5, true},
			{-10, 5, true},
			{5, 5, true},
			{-5, 5, true},
			{20, 15, true},
			{-20, 15, true},
			{0, 0, true},
			{10, 15, false},
			{-10, 15, false},
			{5, 15, false},
			{-5, 15, false},
			{20, 25, false},
			{-20, 25, false},
		}
		for k, v in ipairs(tests) do
			if mextras.threshold(v[1], v[2]) ~= v[3] then
			  print(k, v[1], v[2])
				return false
			end
		end

		return true
	end
)

test(
	"tolerance",
	function()
		local tests = {
			{0, 0, true},
			{10, 5, false},
			{-10, 5, false},
			{5, 5, true},
			{-5, 5, true},
			{20, 15, false},
			{-20, 15, false},
			{0, 0, true},
			{10, 5, false},
			{-10, 5, false},
			{5, 5, true},
			{-5, 5, true},
			{20, 15, false},
			{-20, 15, false},
		}
		for k, v in ipairs(tests) do
			if mextras.tolerance(v[1], v[2]) ~= v[3] then
				return false
			end
		end

		return true
	end
)


for k,v in ipairs(history) do
	print(k, v)
end
print()
print(("Total Successful: %d - Total Fails: %d"):format(totals[succeed], totals[fail]))