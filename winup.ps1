#Prereq
Install-PackageProvider -Name NuGet -Force

#install
Install-Module pswindowsupdate -Force

Import-Module PSWindowsUpdate

#Clear Windows Update registry items
Set-ItemProperty HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name DisableDualScan -value "0"
Set-ItemProperty HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name WUServer -Value $null
Set-ItemProperty HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate -Name WUStatusServer -Value $null

#Add ServiceID for Windows Update
Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d -Confirm:$false
#pause and give the service time to update
Start-Sleep 30

#Scan against Microsoft, return list of software (as opposed to driver) updates
Get-WUInstall -MicrosoftUpdate Software -ListOnly

#Hide unwanted updates here - replace # sign with appropriate information. Read help files for the full extent
#Hide-WindowsUpdate -KBArticleID "KB#######" -Confirm:$false
#Hide-WindowsUpdate -Title "###some update text###"
#optional
#Hide-WindowsUpdate -UpdateType Driver -Confirm:$false

#Now install the updates and do not autoreboot - we always want sccm to coordinate reboots
Get-WUInstall -MicrosoftUpdate Software -AcceptAll -IgnoreReboot
