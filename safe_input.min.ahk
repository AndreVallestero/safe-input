SafeMouseMove(xDest, yDest, speedScale = 2048, randScale = 1, maxAngleVar = 0.3) {
	DllCall( "QueryPerformanceFrequency", Int64P, ticksPerSec)
	overflowX := 0
	overflowY := 0
	Random, scaleVar, -1.0, 1.0
	speedScale += speedScale / 4 * randScale * scaleVar
	Random, angleVar, -maxAngleVar ,maxAngleVar
	MouseGetPos, xPos, yPos
	DllCall("QueryPerformanceCounter", "Int64*", currTick)
	prevTick := currTick
	while(xPos != xDest or yPos != yDest){
		DllCall("QueryPerformanceCounter", "Int64*", currTick)
		tpl := (currTick - prevTick) / ticksPerSec
		prevTick := currTick
		MouseGetPos, xPos, yPos
		distX := xDest-xPos
		distY := yDest-yPos
		dist := Sqrt(distX**2 + distY**2)
		if(distX = 0)
			angle := 1.5707963
		else
			angle := ATan(Abs(distY) / Abs(distX)) + angleVar * Ln(1 + 2.71828182 * dist / 2048)
		speed := Ln(1 + dist * 64 / speedScale) * speedScale * tpl
		if(distX != 0)
			overflowX := overflowX + Cos(angle) * distX / abs(distX) * speed
		if(distY != 0)
			overflowY := overflowY + Sin(angle) * distY / abs(distY) * speed
		remainderX := Mod(overflowX, 1.0)
		remainderY := Mod(overflowY, 1.0)
		deltaX := overflowX - remainderX
		deltaY := overflowY - remainderY
		overflowX := remainderX
		overflowY := remainderY
		DllCall("mouse_event", "UInt", 1, "UInt", deltaX, "UInt", deltaY)
	}
}