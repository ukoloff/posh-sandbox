#
# Update Sigur persons
#
param(
  [switch]$install,
  [switch]$remove
)

$Server = 'srvskud-ekbh1'
$src = "\\omzglobal.com\uxm\Exchange\employee_changes.csv"

if ($install) {
  $me = Split-Path $PSCommandPath -Leaf
  $dir = Split-Path $PSCommandPath -Parent
  $Action = New-ScheduledTaskAction -Execute "powershell" -Argument ".\$me" -WorkingDirectory $dir
  $Trigger = New-ScheduledTaskTrigger -Daily -At 3:45 -RandomDelay 00:27:00
  $Task = New-ScheduledTask -Action $Action -Trigger $Trigger
  Register-ScheduledTask -TaskName $me -TaskPath uxm -InputObject $Task -User "System" -Force
  exit
}

if ($remove) {
  $me = Split-Path $PSCommandPath -Leaf
  Unregister-ScheduledTask -TaskName $me -TaskPath '\uxm\' -Confirm:$false
  exit
}

$cred = Get-StoredCredential -Target 'mysql:SKUD'

Open-MySqlConnection -Server $Server -Port 3305 -Database  tc-db-main -Credential $cred

$Users = Import-Csv  $src -Delimiter ";" -Encoding UTF8

function findField($name) {
  $id = Invoke-SqlScalar @"
    select
      PARAM_IDX
    from
      sideparamtypes
    where
      TABLE_ID = 0
      and NAME = @name
      and `TYPE` = 'STRING'
      and READONLY
"@ -Parameters @{name = $name }
  if ($null -ne $id) { return $id }
  Write-Error "Parameter<string,readonly> not found: $name"
  exit
}

$ids = [PSCustomObject]@{
  department       = findField 'Отдел'
  departmentNumber = findField '№ Отдела'
}

function getUsers($user, $adAttr, $dbAttr) {
  Invoke-SqlQuery @"
    Select ID
    From personal
    Where
      $dbAttr = @$adAttr
      And
      EXTID is NULL
    Limit 2
"@ -ParamObject $user -WarningAction Ignore
}

function syncUser($user, $id) {
  foreach ($f in $ids.PSObject.Properties) {
    $n = Invoke-SqlUpdate @"
      Insert Into
        sideparamvalues
      Set
        TABLE_ID=0,
        OBJ_ID=@id,
        PARAM_IDX=@idx,
        VALUE=@value
      On DUPLICATE KEY UPDATE
        VALUE=@value
"@ -Parameters @{
      id    = $id
      idx   = $f.Value
      value = $user.($f.Name)
    }
  }
}

$Found = 0
$NotFound = 0
foreach ($user in $Users) {
  foreach ($p in $user.PSObject.Properties) {
    $p.Value = $p.Value.Trim()
  }
  if ($user.company -ne 'УЗХМ') { continue }

  $user.department = $user.department -replace '\s*/.*', ''
  $user.department = $user.department -replace '\s*\([^()]*\)\s*$', ''

  [array]$x = getUsers $user displayName NAME
  $n = $x.Count
  if ($n -eq 1) {
    $Found++
    syncUser $user $x[0].ID
    continue
  }
  [array]$x = getUsers $user employeeID TABID
  $t = $x.Count
  if ($t -eq 1) {
    $Found++
    syncUser $user $x[0].ID
    continue
  }
  $NotFound++
  Write-Output "$n`t$t`t$($user.employeeID)`t$($user.displayName)"
}
Write-Output "Found: $Found"
Write-Output "Not found: $NotFound"

Close-SqlConnection
