﻿Framework "4.6"
properties {
    $rootNow = Resolve-Path .
    $nugetexe = "$rootNow\buildTools\NuGet.exe"
    $configuration = "Debug"
    $releaseBase = "$rootNow\bin"
    $pluginName = (Get-ChildItem *.csproj).Name.Replace(".csproj", "")
}

$InstalledPlatforms = Get-ChildItem NewbeLibs\Platform

function Copy-FrameworkItems ($dest) {
    Write-Output "开始复制-框架主体"
    Get-ChildItem "$rootNow\NewbeLibs\Framework\" |
        Where-Object {
        $_.PsIsContainer -eq $false
    } |
        ForEach-Object {
        Copy-Item -Path  "$rootNow\NewbeLibs\Framework\$_" -Destination $dest
    }
    Write-Output "结束复制-框架主体"
}

function Copy-FrameworkExtensionItems ($dest) {
    Write-Output "开始复制-框架扩展"
    if (Test-Path "$rootNow\NewbeLibs\Framework\Extensions\") {
        Get-ChildItem "$rootNow\NewbeLibs\Framework\Extensions\" |
            ForEach-Object {
            Copy-Item -Path  "$rootNow\NewbeLibs\Framework\Extensions\$_\*" -Destination $dest -Recurse
        }
    }
    else {
        Write-Output "未发现扩展"
    }
    Write-Output "结束复制-框架扩展"
}

Task Default -depends Pack

Task Clean -Description "清理" {
    Write-Output $InstalledPlatforms
    $InstalledPlatforms | ForEach-Object {
        Exec {
            Remove-Item "$releaseBase\$_" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

Task Init -depends Clean -Description "初始化参数" {

}

Task Nuget -depends Init -Description "nuget restore" {
    Exec {
        cmd /c """$nugetexe"" restore  -PackagesDirectory ""$rootNow\..\packages"""
    }
}

Task Build -depends Nuget -Description "编译" {
    Exec {
        msbuild /p:Configuration=$configuration
    }
}

# 生成CQP的JSON文件
function WriteCqpJsonFile ($targetFilePath) {
    # 加载所有的DLL
    Get-ChildItem  "$releaseBase\$configuration\*" *.dll | ForEach-Object {
       [void][reflection.assembly]::LoadFile($_)
   }

   # 创建实例
   $pluginInfo = New-Object "$pluginName.PluginInfo"

   # 读取文件
   $jsonFile = "$rootNow\NewbeLibs\Platform\CQP\Content\Newbe.Mahua.CQP.json"
   $jsonText = Get-Content $jsonFile -Encoding "utf8"
   $json = $jsonText | ConvertFrom-Json

   # 内容赋值
   $json.name = $pluginInfo.Name
   $json.version = $pluginInfo.Version
   $json.author = $pluginInfo.Author
   $json.description = $pluginInfo.Description
   $versionNos = ""
   # 版本号每个部分*10，因此版本号，每个版本不能超过10
   $pluginInfo.version.Split(".") | ForEach-Object {
       $v = [string](10 *[int]$_)
       $versionNos += $v
   }
   $json.version_id = [int] $versionNos

   # 写入文件
   $encoding = [System.Text.Encoding]::GetEncoding("gb2312")
   [System.IO.File]::WriteAllText("$targetFilePath", ($json | ConvertTo-Json),$encoding)
}

Task PackCQP -depends Build -Description "CQP打包" {
    if ($InstalledPlatforms | Where-Object {$_.Name -eq "CQP"}) {
        New-Item -ItemType Directory "$releaseBase\CQP"
        New-Item -ItemType Directory "$releaseBase\CQP\$pluginName"
        New-Item -ItemType Directory "$releaseBase\CQP\app"
        Copy-FrameworkItems -dest "$releaseBase\CQP\"
        Copy-Item -Path  "$rootNow\NewbeLibs\Platform\CQP\CLR\*" -Destination "$releaseBase\CQP" -Recurse
        Copy-FrameworkExtensionItems -dest "$releaseBase\CQP\$pluginName"
        Copy-Item -Path "$releaseBase\$configuration\*", "$rootNow\NewbeLibs\Platform\CQP\CLR\*"   -Destination "$releaseBase\CQP\$pluginName" -Recurse
        Copy-Item -Path "$rootNow\NewbeLibs\Platform\CQP\Native\Newbe.Mahua.CQP.Native.dll" -Destination  "$releaseBase\CQP\app\$pluginName.dll"
        WriteCqpJsonFile -targetFilePath "$releaseBase\CQP\app\$pluginName.json"
    }
}

Task PackAmanda -depends Build -Description "Amanda打包" {
    if ($InstalledPlatforms | Where-Object {$_.Name -eq "Amanda"}) {
        New-Item -ItemType Directory "$releaseBase\Amanda"
        New-Item -ItemType Directory "$releaseBase\Amanda\$pluginName"
        New-Item -ItemType Directory "$releaseBase\Amanda\plugin"
        Copy-FrameworkItems -dest "$releaseBase\Amanda\"
        Copy-Item -Path  "$rootNow\NewbeLibs\Platform\Amanda\CLR\*" -Destination "$releaseBase\Amanda" -Recurse
        Copy-FrameworkExtensionItems -dest "$releaseBase\Amanda\$pluginName"
        Copy-Item -Path "$releaseBase\$configuration\*", "$rootNow\NewbeLibs\Platform\Amanda\CLR\*"   -Destination "$releaseBase\Amanda\$pluginName" -Recurse
        Copy-Item -Path "$rootNow\NewbeLibs\Platform\Amanda\Native\Newbe.Mahua.Amanda.Native.dll" -Destination  "$releaseBase\Amanda\plugin\$pluginName.plugin.dll"
    }
}

Task PackMPQ -depends Build -Description "MPQ打包" {
    if ($InstalledPlatforms | Where-Object {$_.Name -eq "MPQ"}) {
        New-Item -ItemType Directory "$releaseBase\MPQ"
        New-Item -ItemType Directory "$releaseBase\MPQ\$pluginName"
        New-Item -ItemType Directory "$releaseBase\MPQ\Plugin"
        Copy-FrameworkItems -dest "$releaseBase\MPQ\"
        Copy-Item -Path  "$rootNow\NewbeLibs\Platform\MPQ\CLR\*" -Destination "$releaseBase\MPQ" -Recurse
        Copy-FrameworkExtensionItems -dest "$releaseBase\MPQ\$pluginName"
        Copy-Item -Path "$releaseBase\$configuration\*", "$rootNow\NewbeLibs\Platform\MPQ\CLR\*"   -Destination "$releaseBase\MPQ\$pluginName" -Recurse
        Copy-Item -Path "$rootNow\NewbeLibs\Platform\MPQ\Native\Newbe.Mahua.MPQ.Native.dll" -Destination  "$releaseBase\MPQ\Plugin\$pluginName.xx.dll"
    }
}

Task Pack -depends PackCQP, PackAmanda, PackMPQ -Description "打包"

