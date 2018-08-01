SafeMouseMove(xDest, yDest, speedScale = 512, randScale = 1, maxAngleVar = 0.3) {
	DllCall( "QueryPerformanceFrequency", Int64P, ticksPerSec)
	
	overflowX := 0
	overflowY := 0
	
	; Pre-initialize these to improve performance
	tpl := 0		; Time in seconds per loop
	remainderX := 0
	remainderY := 0
	deltaX := 0
	deltaY := 0
	
	Random, scaleVar, -1.0, 1.0
	speedScale += speedScale / 4 * randScale * scaleVar
	Random, angleVar, -maxAngleVar ,maxAngleVar ; angle variance from optimal angle in radians
	
	MouseGetPos, xPos, yPos
	DllCall("QueryPerformanceCounter", "Int64*", currTick)
	prevTick := currTick
	while(xPos != xDest or yPos != yDest) {
		DllCall("QueryPerformanceCounter", "Int64*", currTick)
		tpl := (currTick - prevTick) / ticksPerSec
		prevTick := currTick
		
		MouseGetPos, xPos, yPos
		distX := xDest-xPos
		distY := yDest-yPos
		dist := Sqrt(distX**2 + distY**2)
		if(distX = 0)
			angle := 1.5707963 ; pi / 2
		else
			angle := ATan(Abs(distY) / Abs(distX)) + angleVar * Ln(1 + 2.71828182 * dist / 4096) ; eulers number
		
		speed := Ln(1 + dist * 16 / speedScale) * speedScale * tpl
		
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