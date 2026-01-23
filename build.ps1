# build.ps1
param(
    [string]$Configuration = "Release",
    [string]$OutputDir = "dist"
)

# 检查是否安装了MSBuild
$msbuild = Get-Command "msbuild" -ErrorAction SilentlyContinue
if ($null -eq $msbuild) {
    Write-Error "MSBuild not found. Please install Visual Studio or Build Tools."
    exit 1
}

# 检查是否安装了NuGet
$nuget = Get-Command "nuget" -ErrorAction SilentlyContinue
if ($null -eq $nuget) {
    Write-Error "NuGet not found. Please install NuGet CLI."
    exit 1
}

# 还原NuGet包
Write-Host "Restoring NuGet packages..."
nuget restore excel2json.sln

# 构建项目
Write-Host "Building solution..."
msbuild excel2json.sln /p:Configuration=$Configuration /p:Platform="Any CPU"

# 创建输出目录
New-Item -ItemType Directory -Path $OutputDir -Force

# 复制构建结果
Copy-Item -Path "bin\$Configuration\*" -Destination $OutputDir -Recurse

Write-Host "Build completed. Output in ./$OutputDir/"