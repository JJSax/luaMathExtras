

local mextras = {
	_VERSION = "0.0.1"
}
mextras.__index = math

mextras.tau = math.pi * 2
mextras.phi = (1 + math.sqrt(5)) / 2
mextras.e = 2.71828182845904523536

function mextras.factorial(n)
	if n == 1 then return 1 end
	if n < 0 then return 0 end

	return n * mextras.factorial(n-1)
end

function mextras.sign(n)
	if n < 0 then return -1 end
	if n > 0 then return  1 end
	return 0
end

function mextras.clamp(n, mn, mx)
	if n > mx then return mx end
	if n < mn then return mn end
	return n
end

function mextras.round(num, numDecimalPlaces)
	if numDecimalPlaces and numDecimalPlaces > 0 then
		local mult = 10 ^ numDecimalPlaces
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end

function mextras.inRange(num, mn, mx)
	return num >= mn and num <= mx
end

function mextras.converge(inp, toNumber, amount, stopper)
	-- this takes input number, and moves it towards toNumber by amount.  Can be needing to move up or down.
	local dir = mextras.sign(toNumber - inp)
	local n = inp + (amount * dir)

	if stopper and (
		(dir > 0 and n > toNumber) or (dir < 0 and n < toNumber)
	) then
		return toNumber
	end
	return n
end

-- example x = 5 wrapNum(x, 1, 1, 5).  x + 1 is out of range so it will loop back to 1
function mextras.wrap(x, d, a, b)
	-- credit https://pymorton.wordpress.com/2015/02/16/wrap-integer-values-to-fixed-range/
	x = x + d
	return (x - a) % (b - a + 1) + a
end

function mextras.difference(f, s)
	return math.abs(f - s)
end
mextras.diff = mextras.difference

function mextras.center(first, second)
	return (second - first) / 2
end

function mextras.map(n, start1, stop1, start2, stop2, clamp)
	-- translated from the P5 library.
	local mapped = (n - start1) / (stop1 - start1) * (stop2 - start2) + start2
	if not clamp then
		return mapped
	end
	if start2 < stop2 then
		return mextras.clamp(mapped, start2, stop2)
	else
		return mextras.clamp(mapped, stop2, start2)
	end
end

function mextras.fSqrt(n)
	-- Only to be used with a positive n. Which is basically all the time.
	return n ^ 0.5
end

function mextras.dist(x1, y1, x2, y2, sqrt)
	local dx = x1 - x2
	local dy = y1 - y2
	local s = dx * dx + dy * dy
	if sqrt then return s end
	return mextras.fSqrt(s)
end

function mextras.degrees(radians)
	return radians * (180 / math.pi)
end

function mextras.radians(degrees)
	return degrees * (math.pi / 180)
end

local function tAverage(tabOfValues)
	local sum = 0
	for i, v in ipairs(tabOfValues) do
		sum = sum + v
	end
	return sum / #tabOfValues
end

function mextras.ave(...)

	if type(...) == "number" then
		return tAverage({...})
	end

	return tAverage(...)

end
mextras.average = mextras.ave

function mextras.lerp(low, high, progress)
	return low * (1 - progress) + high * progress
end

function mextras.deadzone(value, size)
	return math.abs(value) >= size and value or 0
end

function mextras.threshold(value, threshold)
	return math.abs(value) >= threshold
end

function mextras.tolerance(value, threshold)
	return math.abs(value) <= threshold
end

function mextras.angle(x1, y1, x2, y2)
	return math.atan2(y2 - y1, x2 - x1)
end

function mextras.vector(angle, magnitude)
	return math.cos(angle) * magnitude, math.sin(angle) * magnitude
end

return mextras