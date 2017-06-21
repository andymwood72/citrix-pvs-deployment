# requires that the PVS Console and PVS Server components have been deployed. 
# for information on running configuration wizard silently refer to 
# http://docs.citrix.com/en-us/provisioning/7-13/install/silent-config-wizard.html
# This script creates the configwizard.ans file based on parameters passed to the script
# andrew.wood@gilwood-cs.co.uk June 2017

# newfarm is explicity referenced as "true" or "false" to allow integration with Citrix Smart Tools

param(
    [Parameter(Mandatory=$true)][string] $NewFarm,
    [Parameter(Mandatory=$true)][string] $DBServer,
    [Parameter(Mandatory=$true)][string] $DBInstance,
    [Parameter(Mandatory=$false)][string] $DBName,
    [Parameter(Mandatory=$false)][string] $SiteName = "Site",
    [Parameter(Mandatory=$true)][string] $FarmName = "Farm",
    [Parameter(Mandatory=$false)][string] $CollectionName  = "Collection",
    [Parameter(Mandatory=$true)][string] $StoreName = "Store",
    [Parameter(Mandatory=$true)][string] $StorePath = "c:\store",
    [Parameter(Mandatory=$false)][string] $StreamNetworkAdapterIP,
    [Parameter(Mandatory=$false)][string] $ManagementNetworkAdapterIP,
    [Parameter(Mandatory=$true)][string] $LicServer
)

if (-not $StreamNetworkAdapterIP ) {
 $myip = test-connection $env:computername -count 1 | select ipv4address
 $StreamNetworkAdapterIP = $myip.ipv4address
}

if (-not $ManagementNetworkAdapterIP ) {
 $myip = test-connection $env:computername -count 1 | select ipv4address
 $ManagementNetworkAdapterIP = $myip.ipv4address
}
   
$installpath="C:\Program Files\Citrix\Provisioning Services"
$appdatapath="C:\ProgramData\Citrix\Provisioning Services"

#for complete list of parameters 
#https://www.gourami.eu/2017/02/17/citrix-provisioning-services-automatedunattended-installation-guide/
if ( $NewFarm.ToLower() -eq "true" ) {
    $FarmConfig = 1
    $DBConfig ="DatabaseNew=$DBName
FarmNew=$FarmName
SiteNew=$SiteName
CollectionNew=$CollectionName"
} else {
    $FarmConfig = 2
    # Note: although it actually takes FarmExisting it needs DBNAME, not Farmname
    $DBConfig="FarmExisting=$DBName
ExistingSite=$SiteName
ExistingStore=$StoreName"
}

#Set IPServiceType and PXEService to 'other' - additional 
#parameters required if these are to be set, 
$installstring ="FarmConfiguration=$FarmConfig
DatabaseServer=$DBServer
$DBConfig
DatabaseInstance=$DBInstance
Store=$StoreName
DefaultPath=$StorePath
LicenseServer=$LicServer
LicenseServerPort=27000
IPServiceType=3
PXEServiceType=2
Network=1
PasswordManagementInterval=7
StreamNetworkAdapterIP=$StreamNetworkAdapterIP
ManagementNetworkAdapterIP=$ManagementNetworkAdapterIP
IpcPortBase=6890
IpcPortCount=20
SoapPort=54321
BootstrapFile=C:\ProgramData\Citrix\Provisioning Services\Tftpboot\ARDBP32.BIN
LS1=$StreamNetworkAdapterIP,0.0.0.0,0.0.0.0,6910
AdvancedVerbose=0
AdvancedInterrultSafeMode=0
AdvancedMemorySupport=1
AdvancedRebootFromHD=0
AdvancedRecoverSeconds=50
AdvancedLoginPolling=5000
AdvancedLoginGeneral=30000
"

if (-not (Test-Path $(join-path $appdatapath configwizard.ans)))
    {
        New-Item -Path $(join-path $appdatapath configwizard.ans) -ItemType File
    }
Set-Content -Path $(join-path $appdatapath configwizard.ans) -Value $installstring -Encoding Unicode

New-Item -Path $StorePath -ItemType directory -Force | out-null

$exe = '"'+$(join-path $installpath configwizard.exe)+'"'

$ans = '"'+$(join-path $appdatapath configwizard.ans)+'"'
$cmd=$exe+" /a:"+$ans
write-host $cmd
write-host "configuring"
invoke-expression "& $cmd" 
$NTBackupProcess = (Get-Process | Where-Object { $_.ProcessName -ieq "configwizard" }) 
$NTBackupProcess.WaitForExit()
write-host "install complete --- output"
get-content $(join-path $appdatapath configwizard.out)
