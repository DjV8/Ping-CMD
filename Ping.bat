@echo off
setlocal EnableDelayedExpansion

rem Destination adress (ip / url)
set "IP=8.8.8.8"

rem warning ping
set wP=85

rem danger ping
set dP=150

set lC=0

set pingNum=0

set ps=0

rem console size
mode con: cols=15 lines=4


:Loop
	rem set ping to 0 in case checkin it fails
	set pingNum=0

	rem check ping
	for /F "delims=" %%l in ('ping "%IP%" -n 2 ^| findstr /C:"Reply from"') do (
		set "line=%%l"
		for /F "tokens=7 delims== " %%p in ("%%l") do set pingTime=%%p
	)
	
	set /A pingNum=%pingTime:~0,-2%
	
	rem it didn't wrok
	if !pingNum! == 0 (
		set /a ps=%ps%+1
		goto :colorGotSet
	)
	
	rem it did work
	if NOT !pingNum! == 0 (
		if !pingNum! LEQ %wP% (
			set color=2F
			goto :colorGotSet
		)
		if !pingNum! GEQ %wP% (
			if !pingNum! LEQ %dP% (
				set color=E0
				goto :colorGotSet
			)
		)
		if !pingNum! GEQ %dP% (
			set color=4F
			goto :colorGotSet
		)
	)


:colorGotSet
	if !color! neq %lC% (
		color !color!
		set lC=!color!
	)
	cls
	
	echo.
	echo Ping: %pingTime%
	echo Lost: %ps%
	
	goto :Loop