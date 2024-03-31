@echo off
TITLE Sync All Repo

for /f "delims=" %%D in ('dir /a:d /b') do (
	cd %%~nxD
	echo ==============================
	echo Start Syncing At : %%~nxD
	echo ==============================
	for /f "delims=" %%D in ('dir /a:d /b') do (
		cd %%~nxD
		echo Current Sync Folder : %%~nxD
		git reset --hard head
		cd..
		echo:
	)
	cd %~dp0
)
pause
