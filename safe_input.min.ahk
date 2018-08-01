safe_mouse_move_to(xDest, yDest, randScale = 1, speedScale = 128, maxAngleVar = 0.3) {
	DllCall( "QueryPerformanceFrequency", Int64P, ticksPerSec)
	overflowX := 0
	overflowY := 0
	Random, scaleVar, -100, 100
	speedScale += speedScale / 4 * randScale * scaleVar / 100.0
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
			angle := ATan(Abs(distY) / Abs(distX)) + abs(angleVar) * Ln(1 + 2.71828182 * dist / 4096) ; eulers number
		speed := Ln(1 + dist) * speedScale * tpl
		if(distX != 0)
			overflowX := overflowX + Cos(angle) * distX / abs(distX) * speed
		if(distY != 0)
			overflowY := overflowY + Sin(angle) * distY / abs(distY) * speed
		cutX := Mod(overflowX, 1.0)
		cutY := Mod(overflowY, 1.0)
		deltaX := overflowX - cutX
		deltaY := overflowY - cutY
		overflowX := cutX
		overflowY := cutY
		DllCall("mouse_event", "UInt", 1, "UInt", deltaX, "UInt", deltaY)
	}
}