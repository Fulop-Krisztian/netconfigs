<#
.SYNOPSIS
    Installs AD DS and promotes the server to a domain controller with optional parameters.

.DESCRIPTION
    This script installs AD DS and creates a new forest with either provided parameters or
    default values (contoso.com/Password123). Handles password conversion automatically.

.PARAMETER DomainName
    FQDN for the new forest. Default: contoso.com

.PARAMETER AdminPassword
    Plain text DSRM password. Default: Password123

.PARAMETER NetbiosName
    NetBIOS name for the domain. Inferred from DomainName if not provided.

.EXAMPLE
    .\adinstall.ps1
    # Installs with contoso.com, Password123, and CONTOSO NetBIOS

.EXAMPLE
    .\adinstall.ps1 -DomainName "example.com" -AdminPassword "P@ssw0rd!"
    # Uses example.com, provided password, and EXAMPLE NetBIOS

.NOTES
    Run as Administrator. Will prompt for confirmation before installation.
    Server must be rebooted manually after completion.
#>

param (
    [string]$DomainName = "contoso.com",
    [string]$AdminPassword = "Password123",
    [string]$NetbiosName = ($DomainName -split '\.')[0].ToUpper()
)

# Convert plain text password to SecureString
$securePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force

# Import required module
Import-Module ServerManager

# Install AD DS if missing
if (-not (Get-WindowsFeature AD-Domain-Services).Installed) {
    Write-Output "Installing AD Domain Services..."
    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
}

# Check for existing domain controller
if (Test-Path "AD:\") {
    Write-Output "This server is already a domain controller."
    exit
}

# Confirm installation
Write-Output "Installing AD Forest with these settings:`nDomain: $DomainName`nNetBIOS: $NetbiosName`n"

# Promote to domain controller
Write-Output "Creating new AD Forest '$DomainName'..."
Install-ADDSForest `
    -DomainName $DomainName `
    -DomainNetbiosName $NetbiosName `
    -SafeModeAdministratorPassword $securePassword `
    -InstallDNS `
    -Force `
    -NoRebootOnCompletion:$true

Write-Output "Domain controller promotion complete. Reboot required to finish installation."
