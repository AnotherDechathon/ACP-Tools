@echo off
TITLE Clone GitHub Repository

set /p whyNot="Are you sure you want to clone all GutHub Reposiroty (y/n)? "
if /i "%whyNot%" == "y" (
	for /f "tokens=*" %%A in (GithubRepoLink.txt) do (
		if %%A == Sec1 ( mkdir %%A & cd %%A )
		if %%A == Sec2 ( cd.. & mkdir %%A & cd %%A )
		git clone %%A
	)
)
if /i "%whyNot%" == "n" exit
echo Invalid Option
pause
