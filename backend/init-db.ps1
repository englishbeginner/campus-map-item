# 校园地图数据库初始化 PowerShell 脚本
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "校园地图数据库初始化" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 获取 MySQL 密码
$securePassword = Read-Host "请输入 MySQL root 密码" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
$plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

Write-Host ""
Write-Host "正在执行 SQL 脚本..." -ForegroundColor Yellow

# 执行 SQL 脚本
$sqlScriptPath = "C:\Users\Administrator\Desktop\idea\campus-map\create_database.sql"
Get-Content $sqlScriptPath | mysql -u root -p$plainPassword

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "数据库创建成功！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "数据库创建失败！请检查错误信息。" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
}

Write-Host ""
Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
