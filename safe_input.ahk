safe_move_to(xDest, yDest, randScale = 1, speedScale = 4, minSpeed = 64, maxSpeed = 1024, maxAngleVar = 0.3) {
	DllCall( "QueryPerformanceFrequency", Int64P, ticksPerSec)
	secPerTick = 1.0/ticksPerSec
	
	overflowX = 0
	overflowY = 0
	
	; Pre-initialize these to improve performance
	tpl := 0		; Time in seconds per loop
	cutX := 0
	cutY := 0
	deltaX := 0
	deltaY := 0
	
	Random, scaleVar, -100, 100
	speedScale += scaleVar * randScale / 100.0
	Random, angleVar, -maxAngleVar ,maxAngleVar ; angle variance from optimal angle in radians
	
	MouseGetPos, xPos, yPos
	DllCall("QueryPerformanceCounter", "Int64*", currTick)
	prevTick := currTick
	while(xPos != xDest or yPos != yDest)
	{
		DllCall("QueryPerformanceCounter", "Int64*", currTick)
		tpl := (currTick - prevTick) * secPerTick
		prevTick = currTick
		
		dist := sqrt((xDest-xPos)**2+(yDest-yPos)**2)
		speed := Ln(dist) * speedScale * tpl
		
		
		DllCall("mouse_event", "UInt", 1, "UInt", deltaX, "UInt", deltaY)
	}
}