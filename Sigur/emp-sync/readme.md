# Update Sigur persons

Set fields for all employees inside Sigur
+ Department
+ DepartmentNo

## Setup

```powershell
Install-Module -Name SimplySql
```

```powershell
# Store Credentials:

Install-Module CredentialManager

$cred = Get-Credential
New-StoredCredential -Target mysql:SKUD -Credentials $cred -Persist LocalMachine
```

If running as System, store credentials for that account
