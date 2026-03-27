@echo off
chcp 65001 >nul
echo ========================================
echo 校园地图数据库初始化
echo ========================================
echo.
set /p MYSQL_PASSWORD="请输入 MySQL root 密码："
echo 正在执行 SQL 脚本...
type "C:\Users\Administrator\Desktop\idea\campus-map\create_database.sql" | mysql -u root -p%MYSQL_PASSWORD%
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo 数据库创建成功！
    echo ========================================
) else (
    echo.
    echo ========================================
    echo 数据库创建失败！请检查错误信息。
    echo ========================================
)
pause
