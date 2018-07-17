Framework "4.6"
properties {
    $rootNow = Resolve-Path .
    $nugetexe = "$rootNow\buildTools\NuGet.exe"
    $deployMode = "Release"
    $releaseDir = "$rootNow/build/$deployMode"
}
#默认任务
Task Default -depends Build

Task Clean -Description "清理上一次编译结果" {
    Remove-Item $releaseDir -Force -Recurse -ErrorAction SilentlyContinue
}

Task Init -depends Clean -Description "初始化参数" {

}

Task Nuget -depends Init -Description "nuget restore" {
    NugetRestoreAll -nugetexe $nugetexe
}

Task Build -depends Nuget -Description "编译所有解决方案" {
    RebuildAllSln -deployMode $deployMode
}

