@echo off
fix-relocations.exe cspsp.prx
prxEncrypter.exe cspsp.prx
pack-pbp EBOOT.PBP PARAM.SFO icon.png NULL NULL pic1.png NULL data.psp NULL
pause