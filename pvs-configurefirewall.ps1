# script to configure windows firewall prior to a Citrix PVS install
# use DisableFirewall as "true" to completely disable windows domain firewall profile
# alternatively use "false" and explicitly add required ports inbound/outbound for Citrix PVS services

# use explicit true/false flags to allow compatibility with Citrix Smart Tools

# andrew.wood@gilwood-cs.co.uk June 2017
param (
    [Parameter(Mandatory=$true)][string] $DisableFirewall 
    )

function newfwrule {
    param (
        $fwDisplayName,
        $fwLocalPort
        )
        
	$rule = Get-NetFirewallRule -displayname $fwDisplayName -erroraction silentlycontinue
	
	if ($rule -eq $null) {
        New-NetFirewallRule -displayname $fwDisplayName -Group "Citrix PVS" -Protocol "UDP" -LocalPort $fwLocalPort -Direction "Outbound" -Action  "Allow"
        New-NetFirewallRule -displayname $fwDisplayName -Group "Citrix PVS" -Protocol "UDP" -LocalPort $fwLocalPort -Direction "Inbound" -Action  "Allow"
	} else {
		write-host "rule $fwDisplayName already exists"
	}
}

if ($DisableFirewall.ToLower() -eq "true")  { 
    # Quick and simple, disable the firewall 
    Set-NetFirewallProfile -Profile Domain -Enabled False
} else {
    # https://support.citrix.com/article/CTX117374
    newfwrule -fwdisplayname "Citrix PVS: Soap-Soap Comms (MAPI)" -fwLocalport "6892" 
    newfwrule -fwdisplayname "Citrix PVS: Soap-Soap Comms (IPC)" -fwLocalport "6904" 
    newfwrule -fwdisplayname "Citrix PVS: Soap to Stream Process Manager communication" -fwLocalport "6905"
    newfwrule -fwdisplayname "Citrix PVS: Soap to Stream Service communication" -fwLocalport "6894"
    newfwrule -fwdisplayname "Citrix PVS: Soap to Mgmt Daemon communication" -fwLocalport "6898"
    newfwrule -fwdisplayname "Citrix PVS: Inventory to Inventory communication" -fwLocalport "6895"
    newfwrule -fwdisplayname "Citrix PVS: Notifier to Notifier Communication" -fwLocalport "6903"
    
}

exit 0
