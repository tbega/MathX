# MathX

**MathX** is a comprehensive utility library for Roblox development, extending the standard library with almost **60 essential usage functions** for Scalars, Vectors, Physics, Colors, Randomness, and Formatting.

## Installation

1. Create a `ModuleScript` in `ReplicatedStorage` named `MathX`.
2. Paste the library code.

## API Reference

### Scalar Math
*Fundamental operations for numbers.*

*   **`Lerp(a, b, t)`**  
    Standard linear interpolation.
*   **`LerpUnclamped(a, b, t)`**  
    Linear interpolation without `0-1` clamping (allows extrapolation).
*   **`InverseLerp(min, max, v)`**  
    Returns a `0-1` value representing where `v` falls between `min` and `max`.
*   **`Map(v, inMin, inMax, outMin, outMax)`**  
    Remaps a value from one range to another.
*   **`RemapClamp(v, inMin, inMax, outMin, outMax)`**  
    Remaps and clamps the result to the output range.
*   **`SmoothStep(e0, e1, x)`**  
    Hermite interpolation (smooth ease-in-out).
*   **`SmootherStep(e0, e1, x)`**  
    Ken Perlin's version of SmoothStep (better smoothing).
*   **`ApproxEq(a, b, epsilon)`**  
    Checks if numbers are essentially equal (defaults to `1e-5`).
*   **`Round(num, places)`**  
    Rounds to specific decimal places.
*   **`Snap(n, step)`**  
    Snaps `n` to the nearest multiple of `step`.
*   **`Wrap(x, min, max)`**  
    Wraps a value between min and max (handles negatives correctly).
*   **`PingPong(t, length)`**  
    Bounces a value back and forth between 0 and `length`.
*   **`MoveTowards(curr, target, maxDelta)`**  
    Moves `curr` towards `target` by at most `maxDelta`.
*   **`DeltaAngle(curr, target)`**  
    Calculates the shortest difference between two angles (-180 to 180).
*   **`Clamp(v, min, max)`**  
    Standard clamp alias.

### Vectors & 3D Space
*Distance, direction, and spatial calculations.*

*   **`DistSq(v1, v2)`**  
    Squared distance (Faster than `.Magnitude`).
*   **`AngleBetween(v1, v2)`**  
    Returns the unsigned angle (0-180) between two vectors.
*   **`SignedAngle(v1, v2, axis)`**  
    Returns the signed angle relative to an axis.
*   **`Project(v, target)`**  
    Projects vector `v` onto `target`.
*   **`Reflect(dir, normal)`**  
    Reflects a vector off a surface normal.
*   **`FlattenVector(v)`**  
    Removes the Y-component and normalizes (good for character movement).
*   **`DirectionTo(from, to)`**  
    Returns the normalized direction from A to B.
*   **`IsLookingAt(origin, fwd, target, angle)`**  
    Returns true if `fwd` is pointing within `angle` degrees of `target`.
*   **`ClampMagnitude(v, max)`**  
    Limits a vector's length to `max`.
*   **`Slerp(v1, v2, t)`**  
    Spherical Linear Interpolation (rotates one vector towards another).
*   **`BezierQuad(t, p0, p1, p2)`**  
    Calculates a point on a Quadratic Bezier curve.
*   **`BezierCubic(t, p0, p1, p2, p3)`**  
    Calculates a point on a Cubic Bezier curve.
*   **`ClosestPointOnSegment(A, B, P)`**  
    Finds the closest point on segment `A-B` to point `P`.
*   **`ClosestPointOnRay(origin, dir, point)`**  
    Finds the closest point on an infinite ray to a point.

### CFrame & Transform
*Position and orientation utilities.*

*   **`LookAt(pos, target, up)`**  
    Robust CFrame.lookAt wrapper (handles edge cases better).
*   **`AlignToNormal(pos, normal)`**  
    Creates a CFrame at `pos` with `UpVector` matching `normal`.

### Physics & Movement
*Simulations and trajectory predictions.*

*   **`Spring(target, curr, vel, damp, freq, dt)`**  
    Damped harmonic oscillator. Returns `newPos, newVel`.
*   **`Trajectory(origin, target, speed, gravity)`**  
    Calculates the launch velocity needed to hit a target with an arc.
*   **`PredictPos(shooter, targetPos, targetVel, speed)`**  
    Estimates where a moving target will be when a projectile arrives.

### Shapes & Geometry
*Random points and intersections.*

*   **`RayPlaneIntersect(rayOrigin, rayDir, planePos, planeNormal)`**  
    Finds the point where a ray hits a plane.
*   **`RandomPointInSphere(radius)`**  
    Returns a random Vector3 inside a sphere.
*   **`RandomPointInBox(center, size)`**  
    Returns a random Vector3 inside an aligned box.
*   **`PointsOnCircle(radius, count)`**  
    Returns a list of points evenly distributed on a circle (XZ plane).

### Color
*Manipulation and conversion.*

*   **`HexToColor(hex)`** / **`ColorToHex(c)`**  
    Converts between Color3 and Hex strings (e.g. `#FF0000`).
*   **`ShiftBrightness(c, val)`**  
    Lightens or darkens a color.
*   **`Mix(c1, c2, t)`**  
    Mixes two colors using perceptual blending (RMS).
*   **`Grayscale(c)`**  
    Converts a color to grayscale based on luminance.
*   **`Invert(c)`**  
    Inverts the color (1 - RGB).

### Randomness
*Probability and chance.*

*   **`Gaussian(mean, scale)`**  
    Returns a random number on a Bell Curve.
*   **`WeightedChoice(options)`**  
    Selects an item based on `W` (weight). Example: `{{Value="A", W=10}, {Value="B", W=1}}`.
*   **`Shuffle(t)`**  
    Randomizes a table array in-place.
*   **`PickRandom(t)`**  
    Returns a random element from a table.
*   **`Chance(percent)`**  
    Returns true `percent`% of the time.
*   **`RandomVec3()`**  
    Returns a random unit direction vector.

### Formatting
*String formatting utilities.*

*   **`Abbreviate(n)`**  
    Formats large numbers: `1500 -> "1.5k"`, `1000000 -> "1M"`.
*   **`Comma(n)`**  
    Formats numbers with commas: `10000 -> "10,000"`.
*   **`ToTime(seconds)`**  
    Formats seconds to standard time: `90 -> "01:30"`.

---

## Examples

### Projectile Trajectory (Grenade Toss)
```lua
local launchVel = MathX.Trajectory(
    character.PrimaryPart.Position, 
    mouse.Hit.Position, 
    100, -- Speed
    workspace.Gravity
)

if launchVel then
    grenade.AssemblyLinearVelocity = launchVel
end
```

### Spring Physics (Smooth UI / Camera)
```lua
-- Runs every frame
local currentPos = 0
local currentVel = 0
local targetPos = 10

RunService.RenderStepped:Connect(function(dt)
    currentPos, currentVel = MathX.Spring(targetPos, currentPos, currentVel, 0.8, 4, dt)
    camera.FieldOfView = 70 + currentPos -- Bouncy FOV
end)
```
