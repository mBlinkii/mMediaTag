@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
echo ElvUI CustomMedia CREATED BY ATWOOD
echo.
echo ADDING THE FILE/S...
echo local LSM = LibStub("LibSharedMedia-3.0") > ..\media\CustomMedia.lua
echo.
echo    FONTS
echo.>>  ..\media\CustomMedia.lua
for %%F in (..\media\Fonts\*.ttf) do (
echo       %%~nF
echo LSM:Register("font", "%%~nF", [[Interface\Addons\media\Fonts\%%~nxF]]^) >> ..\media\CustomMedia.lua
)
echo.>> ..\media\CustomMedia.lua
for %%F in (..\media\Fonts\*.otf) do (
echo       %%~nF
echo LSM:Register("font", "%%~nF", [[Interface\Addons\CustomMedia\Fonts\%%~nxF]]^) >> ..\media\CustomMedia.lua
)
echo.
echo    STATUSBAR
echo.>> ..\media\CustomMedia.lua
for %%F in (..\media\textures\*.*) do (
SET String=%%~nF
CALL :UpCase String
SET name=mMediaTag
SET m=%name% %String%
SET m
echo LSM:Register("statusbar", "%m%", [[Interface\Addons\ElvUI_mMediaTag\media\textures\%%~nxF]]^) >> ..\media\CustomMedia.lua
)
:end_of_file
echo.
echo ADDING THE FILE/S COMPLETED!
echo.
echo THANKS FOR INSTALLING AND USING MY ADDON! REGARDS ATWOOD :-)
echo.
pause

:LoCase
:: Subroutine to convert a variable VALUE to all lower case.
:: The argument for this subroutine is the variable NAME.
SET %~1=!%~1:A=a!
SET %~1=!%~1:B=b!
SET %~1=!%~1:C=c!
SET %~1=!%~1:D=d!
SET %~1=!%~1:E=e!
SET %~1=!%~1:F=f!
SET %~1=!%~1:G=g!
SET %~1=!%~1:H=h!
SET %~1=!%~1:I=i!
SET %~1=!%~1:J=j!
SET %~1=!%~1:K=k!
SET %~1=!%~1:L=l!
SET %~1=!%~1:M=m!
SET %~1=!%~1:N=n!
SET %~1=!%~1:O=o!
SET %~1=!%~1:P=p!
SET %~1=!%~1:Q=q!
SET %~1=!%~1:R=r!
SET %~1=!%~1:S=s!
SET %~1=!%~1:T=t!
SET %~1=!%~1:U=u!
SET %~1=!%~1:V=v!
SET %~1=!%~1:W=w!
SET %~1=!%~1:X=x!
SET %~1=!%~1:Y=y!
SET %~1=!%~1:Z=z!
GOTO:EOF

:UpCase
:: Subroutine to convert a variable VALUE to all upper case.
:: The argument for this subroutine is the variable NAME.
SET %~1=!%~1:a=A!
SET %~1=!%~1:b=B!
SET %~1=!%~1:c=C!
SET %~1=!%~1:d=D!
SET %~1=!%~1:e=E!
SET %~1=!%~1:f=F!
SET %~1=!%~1:g=G!
SET %~1=!%~1:h=H!
SET %~1=!%~1:i=I!
SET %~1=!%~1:j=J!
SET %~1=!%~1:k=K!
SET %~1=!%~1:l=L!
SET %~1=!%~1:m=M!
SET %~1=!%~1:n=N!
SET %~1=!%~1:o=O!
SET %~1=!%~1:p=P!
SET %~1=!%~1:q=Q!
SET %~1=!%~1:r=R!
SET %~1=!%~1:s=S!
SET %~1=!%~1:t=T!
SET %~1=!%~1:u=U!
SET %~1=!%~1:v=V!
SET %~1=!%~1:w=W!
SET %~1=!%~1:x=X!
SET %~1=!%~1:y=Y!
SET %~1=!%~1:z=Z!
GOTO:EOF
Pause