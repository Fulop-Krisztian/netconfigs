<#
.SYNOPSIS
  Sets up a sample Active Directory environment with custom OU structure, users, groups, computers, GPOs,
  and configures allowed logon hours using a BitArray conversion.

.DESCRIPTION
  This script creates:
    1. A top-level OU called "Company" under the domain root.
    2. Three sub-OUs under "Company":
         • Employees – for user accounts.
         • Workstations – for computer accounts.
         • SecurityGroups – for groups.
    3. Five sample groups in SecurityGroups.
    4. 15 sample user accounts in Employees (each with a home directory and a logon script).
    5. Allowed logon hours for each user are set to Monday–Friday from 08:00 to 18:00. (Active Directory
       stores logon hours as a 21-byte array, so the script converts the allowed hours accordingly.)
    6. Users are added to the sample groups.
    7. 5 sample computer accounts in Workstations.
    8. Four dummy Group Policy Objects (GPOs) are created and linked to the Employees OU.
    9. A sample logon script is created in a NETLOGON folder.

.NOTES
  - Adjust the variables (domain name, base DN, paths, passwords, etc.) as needed.
  - Ensure that the ActiveDirectory and GroupPolicy modules are available.
#>

# Import required modules
Import-Module ActiveDirectory
Import-Module GroupPolicy

# =========================== CONFIGURATION VARIABLES ===========================
$domainName = "contoso.com"                # e.g. yourdomain.com
$baseDN     = "DC=contoso,DC=com"            # Adjust to match your domain's distinguished name

# Define our top-level OU and sub-OUs
$companyOU         = "OU=Company,$baseDN"
$ouEmployees       = "OU=Employees,$companyOU"
$ouWorkstations    = "OU=Workstations,$companyOU"
$ouSecurityGroups  = "OU=SecurityGroups,$companyOU"

# Location for home directories (this example uses a local folder)
$homeDirsRoot = "C:\HomeDirs"

# Location for logon scripts (in production this would typically be the NETLOGON share)
$netlogonPath = "C:\Netlogon"
$logonScriptName = "MapDrive.cmd"   # Logon script file name

# Sample group names
$groupNames = @("IT", "HR", "Finance", "Sales", "Marketing")

# Sample GPO names
$gpoNames = @("Logon Hours Enforcement", "Drive Mapping", "User Restrictions", "Password Policy")
# ==============================================================================

# ============================= 1. CREATE TOP-LEVEL OU =============================
Write-Output "Checking for top-level OU: Company..."
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq 'Company'" -SearchBase $baseDN -ErrorAction SilentlyContinue)) {
    Write-Output "Creating top-level OU: Company..."
    New-ADOrganizationalUnit -Name "Company" -Path $baseDN
} else {
    Write-Output "OU 'Company' already exists. Skipping creation."
}

# ========================= 2. CREATE SUB-OUs UNDER COMPANY ========================
Write-Output "Creating sub-OUs under Company..."
foreach ($ou in @(
    @{Name="Employees";       Path=$companyOU},
    @{Name="Workstations";    Path=$companyOU},
    @{Name="SecurityGroups";  Path=$companyOU}
))
{
    $ouDN = "OU=$($ou.Name),$($ou.Path)"
    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$ouDN'" -ErrorAction SilentlyContinue)) {
        Write-Output "Creating OU '$($ou.Name)' in $($ou.Path)..."
        New-ADOrganizationalUnit -Name $ou.Name -Path $ou.Path
    }
    else {
        Write-Output "OU '$($ou.Name)' already exists under $($ou.Path). Skipping."
    }
}

# ============================= 3. CREATE GROUPS ==================================
Write-Output "Creating groups in OU=SecurityGroups..."
foreach ($grp in $groupNames) {
    if (-not (Get-ADGroup -Filter "Name -eq '$grp'" -SearchBase $ouSecurityGroups -ErrorAction SilentlyContinue)) {
        Write-Output "Creating group '$grp'..."
        New-ADGroup -Name $grp -Path $ouSecurityGroups -GroupScope Global | Out-Null
    }
    else {
        Write-Output "Group '$grp' already exists in $ouSecurityGroups. Skipping."
    }
}

# ============================= 4. CREATE USERS ===================================
Write-Output "Creating user accounts in OU=Employees..."
# Ensure the home directories root exists
if (-not (Test-Path $homeDirsRoot)) {
    Write-Output "Creating home directories root: $homeDirsRoot"
    New-Item -ItemType Directory -Path $homeDirsRoot | Out-Null
}

# Create 15 users (user1 to user15)
for ($i = 1; $i -le 15; $i++) {
    $samAccountName = "user$i"
    $displayName    = "User $i"
    $password       = ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force

    # Create a home folder for this user
    $userHome = Join-Path $homeDirsRoot $samAccountName
    if (-not (Test-Path $userHome)) {
        Write-Output "Creating home directory for $samAccountName : $userHome"
        New-Item -ItemType Directory -Path $userHome | Out-Null
    }

    # Check if the user already exists in the Employees OU
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$samAccountName'" -SearchBase $ouEmployees -ErrorAction SilentlyContinue)) {
        Write-Output "Creating user: $samAccountName in OU=Employees..."
        New-ADUser `
            -Name $displayName `
            -SamAccountName $samAccountName `
            -GivenName "User" `
            -Surname "$i" `
            -Path $ouEmployees `
            -AccountPassword $password `
            -Enabled $true `
            -ChangePasswordAtLogon $false `
            -HomeDirectory $userHome `
            -HomeDrive "H:" `
            -ScriptPath $logonScriptName
    }
    else {
        Write-Output "User $samAccountName already exists in OU=Employees. Skipping."
    }
}

# =================== 5. SET ALLOWED LOGON HOURS FOR USERS =========================
Write-Output "Configuring allowed logon hours for users (Monday-Friday, 08:00-18:00)..."
#
# Active Directory stores allowed logon hours as 168 bits (21 bytes). Each bit represents one hour of the week.
# For Monday-Friday, 08:00-18:00, the allowed hour indices (starting with 0 = Sunday 00:00–01:00) are:
#   Monday:    32–41
#   Tuesday:   56–65
#   Wednesday: 80–89
#   Thursday:  104–113
#   Friday:    128–137
#

# --- Helper functions using BitArray ---

# Reverse the bits in a single byte.
function Reverse-Byte {
    param([byte]$b)
    $result = 0
    for ($i = 0; $i -lt 8; $i++) {
        if ($b -band (1 -shl $i)) {
            $result = $result -bor (1 -shl (7 - $i))
        }
    }
    return $result
}

# Convert an array of allowed hour indices (0–167) into a 21-byte array required by AD.
function Convert-AllowedHoursToByteArray {
    param(
        [int[]]$AllowedIndices
    )

    # Create a BitArray of 168 bits (all false by default)
    $bits = New-Object System.Collections.BitArray(168, $false)
    foreach ($index in $AllowedIndices) {
        if ($index -ge 0 -and $index -lt 168) {
            $bits[$index] = $true
        }
    }

    # Prepare a 21-byte array; BitArray.CopyTo copies in little-endian order.
    $rawBytes = New-Object byte[] 21
    $bits.CopyTo($rawBytes, 0)

    # AD expects each byte with the most significant bit representing the first hour in the group.
    # Reverse the bits in each byte.
    for ($i = 0; $i -lt $rawBytes.Length; $i++) {
        $rawBytes[$i] = Reverse-Byte $rawBytes[$i]
    }
    return $rawBytes
}

# Define the allowed hour indices for Monday-Friday 08:00-18:00.
$allowedIndices = (32..41) + (56..65) + (80..89) + (104..113) + (128..137)
$allowedLogonHours = Convert-AllowedHoursToByteArray -AllowedIndices $allowedIndices

# Retrieve all users in the Employees OU and update their logonHours attribute.
$employeeUsers = Get-ADUser -Filter * -SearchBase $ouEmployees
foreach ($user in $employeeUsers) {
    Write-Output "Setting allowed logon hours for user: $($user.SamAccountName)..."
    # Clear existing logon hours and set new ones in a single operation
    Set-ADUser -Identity $user -Clear logonHours -Replace @{ logonHours = $allowedLogonHours }
}

# ========================= 6. ADD USERS TO GROUPS ===============================
Write-Output "Assigning users to groups..."
# For demonstration, assign users as follows:
#   IT:         user1–user3
#   HR:         user4–user6
#   Finance:    user7–user9
#   Sales:      user10–user12
#   Marketing:  user13–user15
$groupMapping = @{
    "IT"        = 1..3;
    "HR"        = 4..6;
    "Finance"   = 7..9;
    "Sales"     = 10..12;
    "Marketing" = 13..15;
}
foreach ($grp in $groupMapping.Keys) {
    foreach ($i in $groupMapping[$grp]) {
        $samAccountName = "user$i"
        Write-Output "Adding $samAccountName to group $grp..."
        Add-ADGroupMember -Identity $grp -Members $samAccountName -ErrorAction SilentlyContinue
    }
}

# ======================== 7. CREATE COMPUTER ACCOUNTS ============================
Write-Output "Creating computer accounts in OU=Workstations..."
# Create 5 sample computer accounts (ClientPC1 to ClientPC5)
for ($i = 1; $i -le 5; $i++) {
    $computerName = "ClientPC$i"
    if (-not (Get-ADComputer -Filter "Name -eq '$computerName'" -SearchBase $ouWorkstations -ErrorAction SilentlyContinue)) {
        Write-Output "Creating computer account: $computerName..."
        New-ADComputer -Name $computerName -Path $ouWorkstations -Enabled $true
    }
    else {
        Write-Output "Computer $computerName already exists in OU=Workstations. Skipping."
    }
}

# ======================== 8. CREATE AND LINK GPOs ===============================
Write-Output "Creating and linking GPOs..."
foreach ($gpo in $gpoNames) {
    if (-not (Get-GPO -Name $gpo -ErrorAction SilentlyContinue)) {
        Write-Output "Creating GPO: $gpo"
        New-GPO -Name $gpo | Out-Null
    }
    else {
        Write-Output "GPO '$gpo' already exists. Skipping creation."
    }
    Write-Output "Linking GPO '$gpo' to OU=Employees..."
    New-GPLink -Name $gpo -Target $ouEmployees -ErrorAction SilentlyContinue
}

# ========================= 9. CREATE THE LOGON SCRIPT ============================
Write-Output "Creating the logon script for drive mapping..."
if (-not (Test-Path $netlogonPath)) {
    Write-Output "Creating NETLOGON folder at $netlogonPath..."
    New-Item -ItemType Directory -Path $netlogonPath | Out-Null
}
$logonScriptPath = Join-Path $netlogonPath $logonScriptName
if (-not (Test-Path $logonScriptPath)) {
    $scriptContent = @'
@echo off
REM Map drive H: to the user’s home folder share on the file server
net use H: \\fileserver\HomeDirs\%username%
'@
    Write-Output "Writing logon script to $logonScriptPath..."
    Set-Content -Path $logonScriptPath -Value $scriptContent -Encoding ASCII
}
else {
    Write-Output "Logon script already exists at $logonScriptPath. Skipping creation."
}

Write-Output "AD environment setup complete."
