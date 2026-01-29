--!strict
local MathX = {}

local rng = Random.new()
local abs, pi, sin, cos, acos, asin, tan, atan2, sqrt, exp, floor, ceil = math.abs, math.pi, math.sin, math.cos, math.acos, math.asin, math.tan, math.atan2, math.sqrt, math.exp, math.floor, math.ceil
local max, min, clamp = math.max, math.min, math.clamp

function MathX.Lerp(a: number, b: number, t: number): number
	return a + (b - a) * t
end

function MathX.LerpUnclamped(a: number, b: number, t: number): number
	return a + (b - a) * t
end

function MathX.InverseLerp(min: number, max: number, v: number): number
	if min == max then return 0 end
	return (v - min) / (max - min)
end

function MathX.Map(v: number, inMin: number, inMax: number, outMin: number, outMax: number): number
	return outMin + (outMax - outMin) * ((v - inMin) / (inMax - inMin))
end

function MathX.RemapClamp(v: number, inMin: number, inMax: number, outMin: number, outMax: number): number
	local t = (v - inMin) / (inMax - inMin)
	t = clamp(t, 0, 1)
	return outMin + (outMax - outMin) * t
end

function MathX.SmoothStep(edge0: number, edge1: number, x: number): number
	x = clamp((x - edge0) / (edge1 - edge0), 0, 1)
	return x * x * (3 - 2 * x)
end

function MathX.SmootherStep(edge0: number, edge1: number, x: number): number
	x = clamp((x - edge0) / (edge1 - edge0), 0, 1)
	return x * x * x * (x * (x * 6 - 15) + 10)
end

function MathX.ApproxEq(a: number, b: number, epsilon: number?): boolean
	return abs(a - b) < (epsilon or 1e-5)
end

function MathX.Round(num: number, places: number?): number
	local mult = 10 ^ (places or 0)
	return floor(num * mult + 0.5) / mult
end

function MathX.Snap(n: number, step: number): number
	return floor(n / step + 0.5) * step
end

function MathX.Wrap(x: number, min: number, max: number): number
	return min + (x - min) % (max - min)
end

function MathX.PingPong(t: number, length: number): number
	t = t % (length * 2)
	return length - abs(t - length)
end

function MathX.MoveTowards(current: number, target: number, maxDelta: number): number
	if abs(target - current) <= maxDelta then return target end
	return current + math.sign(target - current) * maxDelta
end

function MathX.DeltaAngle(current: number, target: number): number
	local diff = (target - current) % 360
	return diff > 180 and diff - 360 or diff
end

function MathX.Clamp(v: number, min: number, max: number): number
	return math.clamp(v, min, max)
end

function MathX.DistSq(v1: Vector3, v2: Vector3): number
	local x, y, z = v1.X - v2.X, v1.Y - v2.Y, v1.Z - v2.Z
	return x*x + y*y + z*z
end

function MathX.AngleBetween(v1: Vector3, v2: Vector3): number
	return math.deg(acos(clamp(v1.Unit:Dot(v2.Unit), -1, 1)))
end

function MathX.SignedAngle(v1: Vector3, v2: Vector3, axis: Vector3): number
	local angle = MathX.AngleBetween(v1, v2)
	local cross = v1:Cross(v2)
	if cross:Dot(axis) < 0 then
		angle = -angle
	end
	return angle
end

function MathX.Project(v: Vector3, target: Vector3): Vector3
	local dot = v:Dot(target)
	local magSq = target.Dot(target, target)
	return target * (dot / magSq)
end

function MathX.Reflect(dir: Vector3, normal: Vector3): Vector3
	return dir - (2 * dir:Dot(normal) * normal)
end

function MathX.FlattenVector(v: Vector3): Vector3
	return Vector3.new(v.X, 0, v.Z).Unit
end

function MathX.DirectionTo(from: Vector3, to: Vector3): Vector3
	return (to - from).Unit
end

function MathX.IsLookingAt(origin: Vector3, forward: Vector3, target: Vector3, maxAngleDeg: number): boolean
	local dir = (target - origin).Unit
	return forward:Dot(dir) >= cos(math.rad(maxAngleDeg))
end

function MathX.ClampMagnitude(v: Vector3, maxMag: number): Vector3
	if v.Magnitude > maxMag then
		return v.Unit * maxMag
	end
	return v
end

function MathX.Slerp(v1: Vector3, v2: Vector3, t: number): Vector3
	t = clamp(t, 0, 1)
	local dot = clamp(v1:Dot(v2), -1, 1)
	local theta = acos(dot) * t
	local relV = (v2 - v1 * dot).Unit
	return v1 * cos(theta) + relV * sin(theta)
end

function MathX.BezierQuad(t: number, p0: Vector3, p1: Vector3, p2: Vector3): Vector3
	local l1 = p0:Lerp(p1, t)
	local l2 = p1:Lerp(p2, t)
	return l1:Lerp(l2, t)
end

function MathX.BezierCubic(t: number, p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3): Vector3
	local a = p0:Lerp(p1, t)
	local b = p1:Lerp(p2, t)
	local c = p2:Lerp(p3, t)
	local d = a:Lerp(b, t)
	local e = b:Lerp(c, t)
	return d:Lerp(e, t)
end

function MathX.ClosestPointOnSegment(A: Vector3, B: Vector3, P: Vector3): Vector3
	local AP = P - A
	local AB = B - A
	local t = clamp(AP:Dot(AB) / AB:Dot(AB), 0, 1)
	return A + AB * t
end

function MathX.ClosestPointOnRay(origin: Vector3, dir: Vector3, point: Vector3): Vector3
	return origin + MathX.Project(point - origin, dir)
end

function MathX.LookAt(pos: Vector3, target: Vector3, up: Vector3?): CFrame
	return CFrame.lookAt(pos, target, up)
end

function MathX.AlignToNormal(pos: Vector3, normal: Vector3): CFrame
	local up = Vector3.new(0, 1, 0)
	local right = (math.abs(normal:Dot(up)) > 0.99) and Vector3.new(1, 0, 0) or up:Cross(normal).Unit
	local forward = normal:Cross(right).Unit
	return CFrame.fromMatrix(pos, right, normal, forward)
end

function MathX.Spring(target: number, current: number, vel: number, damping: number, frequency: number, dt: number)
	local d = 2 * pi * frequency
	local c = 2 * d * damping
	local k = d * d

	local diff = current - target
	local accel = -k * diff - c * vel

	vel += accel * dt
	current += vel * dt
	return current, vel
end

function MathX.Trajectory(origin: Vector3, target: Vector3, speed: number, gravity: number): Vector3?
	local diff = target - origin
	local x = Vector3.new(diff.X, 0, diff.Z).Magnitude
	local y = diff.Y

	local root = speed^4 - gravity * (gravity * x^2 + 2 * y * speed^2)
	if root < 0 then return nil end

	local theta = atan2(speed^2 - sqrt(root), gravity * x)
	local dir = Vector3.new(diff.X, 0, diff.Z).Unit

	return dir * (speed * cos(theta)) + Vector3.new(0, speed * sin(theta), 0)
end

function MathX.PredictPos(shooter: Vector3, targetPos: Vector3, targetVel: Vector3, projectileSpeed: number): Vector3
	local dist = (targetPos - shooter).Magnitude
	local timeToHit = dist / projectileSpeed
	return targetPos + targetVel * timeToHit
end

function MathX.RandomPointInSphere(radius: number): Vector3
	local u = rng:NextNumber()
	local v = rng:NextNumber()
	local theta = 2 * pi * u
	local phi = acos(2 * v - 1)
	local r = radius * (rng:NextNumber() ^ (1/3))
	local sinPhi = sin(phi)
	return Vector3.new(r * sinPhi * cos(theta), r * sinPhi * sin(theta), r * cos(phi))
end

function MathX.RandomPointInBox(center: Vector3, size: Vector3): Vector3
	local rx = (rng:NextNumber() - 0.5) * size.X
	local ry = (rng:NextNumber() - 0.5) * size.Y
	local rz = (rng:NextNumber() - 0.5) * size.Z
	return center + Vector3.new(rx, ry, rz)
end

function MathX.PointsOnCircle(radius: number, count: number): {Vector3}
	local points = {}
	local step = (2 * pi) / count
	for i = 1, count do
		local theta = step * i
		table.insert(points, Vector3.new(radius * cos(theta), 0, radius * sin(theta)))
	end
	return points
end

function MathX.RayPlaneIntersect(rayOrigin: Vector3, rayDir: Vector3, planePoint: Vector3, planeNormal: Vector3): Vector3?
	local denom = planeNormal:Dot(rayDir)
	if abs(denom) < 1e-6 then return nil end

	local t = (planePoint - rayOrigin):Dot(planeNormal) / denom
	if t < 0 then return nil end

	return rayOrigin + rayDir * t
end

function MathX.HexToColor(hex: string): Color3
	hex = hex:gsub("#", "")
	return Color3.fromRGB(
		tonumber("0x" .. hex:sub(1, 2)) or 0,
		tonumber("0x" .. hex:sub(3, 4)) or 0,
		tonumber("0x" .. hex:sub(5, 6)) or 0
	)
end

function MathX.ColorToHex(c: Color3): string
	return string.format("#%02X%02X%02X", floor(c.R * 255), floor(c.G * 255), floor(c.B * 255))
end

function MathX.ShiftBrightness(c: Color3, val: number): Color3
	local h, s, v = c:ToHSV()
	return Color3.fromHSV(h, s, clamp(v + val, 0, 1))
end

function MathX.Mix(c1: Color3, c2: Color3, t: number): Color3
	return Color3.new(
		sqrt((1 - t) * (c1.R^2) + t * (c2.R^2)),
		sqrt((1 - t) * (c1.G^2) + t * (c2.G^2)),
		sqrt((1 - t) * (c1.B^2) + t * (c2.B^2))
	)
end

function MathX.Grayscale(c: Color3): Color3
	local gray = c.R * 0.299 + c.G * 0.587 + c.B * 0.114
	return Color3.new(gray, gray, gray)
end

function MathX.Invert(c: Color3): Color3
	return Color3.new(1 - c.R, 1 - c.G, 1 - c.B)
end

function MathX.Gaussian(mean: number, scale: number): number
	local u1 = rng:NextNumber()
	local u2 = rng:NextNumber()
	local z0 = sqrt(-2 * math.log(u1)) * cos(2 * pi * u2)
	return z0 * scale + mean
end

function MathX.WeightedChoice(options: {{Value: any, W: number}}): any
	local total = 0
	for _, data in ipairs(options) do total += data.W end

	local r = rng:NextNumber() * total
	local count = 0
	for _, data in ipairs(options) do
		count += data.W
		if r <= count then return data.Value end
	end
	return nil
end

function MathX.Shuffle<T>(t: {T})
	for i = #t, 2, -1 do
		local j = rng:NextInteger(1, i)
		t[i], t[j] = t[j], t[i]
	end
end

function MathX.PickRandom<T>(t: {T}): T?
	if #t == 0 then return nil end
	return t[rng:NextInteger(1, #t)]
end

function MathX.Chance(percent: number): boolean
	return rng:NextNumber() * 100 <= percent
end

function MathX.RandomVec3(): Vector3
	local theta = rng:NextNumber() * 2 * pi
	local z = rng:NextNumber() * 2 - 1
	local root = sqrt(1 - z * z)
	return Vector3.new(root * cos(theta), root * sin(theta), z)
end

function MathX.Abbreviate(n: number): string
	local s = {"", "k", "M", "B", "T", "Q"}
	local i = 1
	while n >= 1000 and i < #s do
		n /= 1000
		i += 1
	end
	return (string.format("%.1f%s", n, s[i]):gsub("%.?0+([kMBTQ])", "%1"))
end

function MathX.Comma(n: number): string
	local f = tostring(n)
	while true do
		local k
		f, k = string.gsub(f, "^(-?%d+)(%d%d%d)", '%1,%2')
		if k == 0 then break end
	end
	return f
end

function MathX.ToTime(seconds: number): string
	seconds = floor(seconds)
	local h = floor(seconds / 3600)
	local m = floor((seconds % 3600) / 60)
	local s = seconds % 60

	if h > 0 then
		return string.format("%02d:%02d:%02d", h, m, s)
	else
		return string.format("%02d:%02d", m, s)
	end
end

return MathX
