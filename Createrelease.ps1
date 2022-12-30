#determine os type AND verify dependencies are present 
if ($Env:OS -eq "Windows_NT"){
    $OSType="Windows"
    
    $cmdName="7z"
    if (!(Get-Command $cmdName -errorAction SilentlyContinue))
    {
        write-host "`n $cmdName dependency not installed, use chocolatey (https://chocolatey.org/), 'choco install 7zip' command for installation`n" -ForegroundColor yellow
        Start-Sleep -Seconds 10
        exit
    }


}
else{
    $OSType="Linux"
    $cmdName="7za"
    if (!(Get-Command $cmdName -errorAction SilentlyContinue))
    {
        write-host "`n $cmdName dependency not installed, use package manger of your os command for installation example sudo apt install p7zip or sudo yum install p7zip for ubuntu/centos respectively" -ForegroundColor yellow
        write-host " in case command fails add extra repositories sudo add-apt-repository universe && sudo apt update for ubuntu and sudo yum install epel-release for centos. Than try again." -ForegroundColor yellow
        Start-Sleep -Seconds 10
        exit
    }
}

#constants
$projectpath="C:\Users\Administrator\Documents\LogverzReleases" # change accroding to local path
$componentpath=$projectpath+"\LogverzCore"
$buildrelativepath="ProjectBuild"
$buildfullpath="$projectpath\$buildrelativepath\build"

$repobaseurl="https://logleads@dev.azure.com/logleads/LogverzPortal/_git/"


#create product bundle (init.zip)
Import-Module $($projectpath+"\LogverzCore\infrastructure\tools\build.psm1") -Verbose:$false
$extrafiles= get-extrafiles -filepath $($componentpath+"\infrastructure\tools\buildextrafiles.csv")

build-webapp-source -builddirectory $buildfullpath -repo $($repobaseurl+"Portal") -appname "Portal" -branchname "dev" -OSType $OSType
build-webapp-source -builddirectory $buildfullpath -repo $($repobaseurl+"PortalAccess") -appname "PortalAccess" -branchname "dev" -OSType $OSType

set-init-sources -projectpath $projectpath -extrafiles $extrafiles -builddirectory $buildrelativepath -componentpath $componentpath -OSType $OSType

#creating new commit and uploading release. 
#Broken don't use: Install-Module -Name PSGitHub && Import-Module PSGitHub && Remove-Module PSGitHub && Uninstall-Module PSGitHub

#Install-Module -Name PowerShellForGitHub
#Set-GitHubAuthentication
#automated release management token:

Import-Module PowerShellForGitHub
Get-GitHubRepository -RepositoryName LogverzCompendium -OwnerName logleads





#https://www.powershellgallery.com/packages/PSGitHub/0.15.165/Content/Functions%5CPublic%5CNew-GitHubRelease.ps1
#https://github.com/deadlydog/New-GitHubRelease


#temp: 
#$builddirectory=$buildrelativepath
#$projectpath="$componentpath\infrastructure\coturncontrol\"
#$zipfilename="coturncontrol.zip"
#$componentpath="/home/ec2-user/7ziptesting/webrtcproxycontrol/"
#$controlbundle=$($componentpath+$zipfilename)
