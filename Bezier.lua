local Bezier = {}

local B = {} -- lookup table for Bernstein polynomials

for n = 1, 16 do -- pre-calculate up to degree 16
	B[n] = {}
	for i = 0, n do
		B[n][i] = 1
		for j = 1, i do
			B[n][i] = B[n][i] * (n - j + 1) / j
		end
	end
end

function Bezier.new(points)
	-- Constructs a new Bezier object with the given control points
	local obj = setmetatable({}, {__index = Bezier})
	
	obj.points = points or {}
	obj.n = #points
	
	return obj
end

function Bezier:CalculatePositionAt(t)
	-- Calculates the position of the curve at the given parameter value
	if self.n == 0 then
		error("Cannot calculate position of Bezier curve with no control points")
	elseif self.n == 1 then
		return self.points[1]
	end

	local p = Vector3.new()
	for i = 1, self.n do
		p += self.points[i].Position * B[self.n - 1][i - 1] * t^(i - 1) * (1 - t)^(self.n - i)
	end
	return p
end

return Bezier
