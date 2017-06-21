:: Install .net requirement from the PVS installation that has been copied locally. 
:: if running from smart tools - use a reboot step after running this script; if not running from smart tools, 
:: there will need to be a reboot before starting other installation steps

%temp%\pvs\Server\ISSetupPrerequisites\{6CF14221-8501-4A82-B1D4-3D344CB66D23}\NDP452-KB2901907-x86-x64-AllOS-ENU.exe /q /norestart

exit 0