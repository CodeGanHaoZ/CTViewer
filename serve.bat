@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo.
echo   汽车拆解可视化 · 本地预览
echo   http://localhost:8123/car-exploded.html
echo   关闭此窗口即停止服务
echo.
start "" "http://localhost:8123/car-exploded.html"
where python >nul 2>nul && (python -m http.server 8123) || (py -m http.server 8123)
