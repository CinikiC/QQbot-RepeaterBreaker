#release a web
function BuildWeb ($deployMode, $outDir, $csproj) {
    Remove-Item $outDir -Force -Recurse -ErrorAction SilentlyContinue
    mkdir $outDir
    msbuild /nologo /t:_WPPCopyWebApplication /m /v:minimal /p:Configuration=$deployMode /p:WebProjectOutputDir=$outDir $csproj 
}

#nuget restore
function NugetRestoreAll ($nugetexe) {
    Get-ChildItem *.sln -File -Recurse | ForEach-Object {
        Exec {
            cmd /c ""$nugetexe" restore $_" 
        }
    }  
    
}

function RebuildAllSln ($deployMode) {
    Get-ChildItem *.sln -File -Recurse | ForEach-Object {
        Exec {
            msbuild /t:"Clean;Rebuild" /p:Configuration=$deployMode /m /v:minimal /nologo  $_ }
    }
}

function BuildProj ($deployMode, $csproj) {
    Exec { 
        msbuild /t:"Clean;Rebuild" /p:Configuration=$deployMode /m /v:minimal /nologo  $csproj 
    }
}

function PackWebDeploy ($deployMode, $csproj, $publishProfile) {
    Exec { 
        msbuild $csproj /p:DeployOnBuild=true /p:PublishProfile=$publishProfile /p:Configuration=$deployMode /m /v:minimal /nologo 
    }
}    

<#
.SYNOPSIS
Adds correct path to MSBuild to Path environment variable.
#>
function Initialize-MSBuild {
    [CmdletBinding()]
    param ()
    Write-Output "Initialize-MSBuild is not necessary ,you can remove this function"
}