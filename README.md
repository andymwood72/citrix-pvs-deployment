# Automating Citrix Provisioning Service deployment scripts
 
Scripts to automate the deployment of PVS - this scripts can be incorporated into a Citricx Smart Tools 
(https://manage-docs.citrix.com/hc/en-us/articles/212715083-Smart-Tools-concepts) Smart Build Blueprint. 

## XenDesktop 7 Site Export and Import Script

Exports XenDesktop 7.x site information and imports to another 'Site' via remote command or XML file.

**PLEASE USE WITH CAUTION. USING THE PVS CONFIGURATION SCRIPT CAN OVERWRITE SETTINGS**

### Requirements
- .iso for PVS version available on a network share
- PowerShell v3 or greater
- service account with permissions to install PVS 
- SQL Service available to host/provide access to the PVS farm configuration

### Changelog

- 21-06-2017: Initial release

### PVS Test Versions

- 7.13

### What is installed / configured
- the installation media from the SMB location to %TEMP% on the host
- firewall for domain profile is optionally configured with correct ports; or disabled
- require .net version is installed 

### What is not configured?
- automated boot post the .Net install
- DHCP deployment Configuration
- Installation of a SQL service
- Migration of vDisks from an existing environment
- Creation of new vDisks
- Population of Collections

### Usage
If configuring as a Citrix Smart Tools Blueprint, 
a) configure each script as an independent Smart Build script
b) Create a Blueprint to apply to a server
c) Add script pvs-robocopysource.bat; Input of PVSSource [string]
d) Add script pvs-configurefirewall.ps1; Input of DisableFirewall [String]
e) Add script pvs-dotnetupdate.bat; 
f) Add a reboot step
d) Add script pvs-installpvsserver.bat 
d) Add script pvs-installpvsconsole.bat 
d) Add script pvs-configure.ps1; input strings for NewFarm(m); DBServer(m); DBInstance, DBName, SiteName, FarmName, CollectionName, StoreName, StoprePath, StreamNetworkAdapterIP, ManagementNetworkAdapterIP, LicServer

If running manually, run scripts as in order for Blueprint. 


...end