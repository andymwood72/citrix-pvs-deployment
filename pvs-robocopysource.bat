:: Script to copy the source PVS .iso from an SMB location to the temp folder on a host
echo %1

echo %temp%\pvs
robocopy.exe %2 %temp%\pvs /mir

exit 0