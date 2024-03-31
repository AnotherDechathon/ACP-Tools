@echo off
TITLE Pull All Repo

for /f "delims=" %%D in ('dir /a:d /b') do (
	cd %%~nxD
	echo ==============================
	echo Start Pull At : %%~nxD
	echo ==============================
	for /f "delims=" %%D in ('dir /a:d /b') do (
		cd %%~nxD
		echo Current Pull Folder : %%~nxD
		git pull
		cd..
		echo:
	)
	cd %~dp0
)
pause
