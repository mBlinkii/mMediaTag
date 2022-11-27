@echo off
echo    FONTS
echo.>> ..\ElvUI_CustomMedia\ElvUI_CustomMedia.lua
for %%F in (..\ElvUI_CustomMedia\Fonts\*.ttf) do (
echo       %%~nF
echo mAddFont("%%~nF", "%%~nxF"^) >> ..\ElvUI_CustomMedia\ElvUI_CustomMedia.lua
)
echo.>> ..\ElvUI_CustomMedia\ElvUI_CustomMedia.lua
for %%F in (..\ElvUI_CustomMedia\Fonts\*.otf) do (
echo       %%~nF
echo LSM:Register("font", "%%~nF", [[Interface\Addons\ElvUI_CustomMedia\Fonts\%%~nxF]]^) >> ..\ElvUI_CustomMedia\ElvUI_CustomMedia.lua
)
echo.
echo    STATUSBAR
echo.>> ..\ElvUI_CustomMedia\ElvUI_CustomMedia.lua
for %%F in (..\ElvUI_CustomMedia\Statusbar\*.*) do (
echo       %%~nF
echo LSM:Register("statusbar", "%%~nF", [[Interface\Addons\ElvUI_CustomMedia\Statusbar\%%~nxF]]^) >> ..\ElvUI_CustomMedia\ElvUI_CustomMedia.lua
)
:end_of_file
echo.
echo ADDING THE FILE/S COMPLETED!
Pause