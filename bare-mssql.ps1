#
# Backup & Restore MS SQL
#
using namespace System.Windows.Forms

$Server = "SRVSQL-1C"
$BackupFolder = 'e$'
$fallbackFolder = 'Backup_test'
$DBs = "conv", "ERP_WORK", "ZUP_20", "SandBox"

Import-Module SqlServer
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    x:Name="Window"
    Title="MS SQL Backup / Restore"
    Height="200" MinWidth="500"
    WindowStartupLocation="CenterScreen"
    SizeToContent="WidthAndHeight"
>
<StackPanel Margin="5">
  <TextBlock Text="База данных" />
  <ComboBox x:Name="db" IsEditable="true" />
  <CheckBox x:Name="importdb" Content="Взять список баз с $Server" />
  <TabControl x:Name="Op">
    <TabItem Header="Backup">
      <StackPanel>
        <TextBlock Text="Destination" />
        <Grid>
          <Grid.ColumnDefinitions>
            <ColumnDefinition Width="*"/>
            <ColumnDefinition Width="Auto" />
          </Grid.ColumnDefinitions>
          <TextBox x:Name="dst" MaxLength="50"  />
          <Button x:Name="btnDst" Grid.Column="1" Content="Обзор" Padding="5 0" />
        </Grid>
        <CheckBox x:Name="overwrite" Content="Отключить запрос на перезапись" />
      </StackPanel>
    </TabItem>
    <TabItem Header="Restore">
      <StackPanel>
        <TextBlock Text="Existing backup" />
        <Grid>
          <Grid.ColumnDefinitions>
            <ColumnDefinition Width="*"/>
            <ColumnDefinition Width="Auto" />
          </Grid.ColumnDefinitions>
          <TextBox x:Name="src" MaxLength="50"  />
          <Button x:Name="btnSrc" Grid.Column="1" Content="Обзор" Padding="5 0" />
        </Grid>
        <TextBlock />
      </StackPanel>
    </TabItem>
  </TabControl>
  <TextBlock />
  <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" >
    <Button Content="Go!" x:Name="btnGo" IsDefault="True" Padding="9 0"/>
    <Button Content="Закрыть" IsCancel="True" Padding="9 0" Margin="7 0"/>
  </StackPanel>
</StackPanel>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# https://blog.it-kb.ru/2014/10/10/wpf-forms-for-powershell-scripts/
$xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | % {
  Set-Variable -Name ($_.Name) -Value $window.FindName($_.Name) -Scope Global
}

function setDBs() {
  $db.ItemsSource = $DBs
}

function loadDBs() {
  $conn = New-Object System.Data.SqlClient.SQLConnection("Integrated Security=True;Server=$Server")
  $conn.Open()

  $cmd = $conn.CreateCommand()
  $cmd.CommandText = "Select name From sys.databases Order By 1"
  $r = $cmd.ExecuteReader()
  while ($r.Read()) { $r.GetValue(0) }
}

function fetchDBs() {
  $db.ItemsSource = loadDBs
}

$prevDB = $null

function updatePaths() {
  if ($prevDB -eq $db.Text) { return }
  $prevDB = $db.Text
  if ($prevDB -eq "") {
    $dst.Text = ""
    $src.Text = ""
    return
  }
  $folder = bakFolder
  $file = bakFile
  $dst.Text = $folder + $file
  $src.Text = $folder
}

$btnDst.add_click({ browseBackup; })
$btnSrc.add_click({ browseRestore; })
$btnGo.add_click({ Validate; })

$importdb.Add_Checked({ fetchDBs })
$importdb.Add_Unchecked({ setDBs })
setDBs

$db.Add_DropDownClosed({ updatePaths })
$db.Add_LostFocus({ updatePaths })

function bakFolder() {
  return "\\$Server\$BackupFolder\$($db.Text)\"
}

function bakFile() {
  return "$($db.Text)_$(Get-Date -uformat '%Y%m%d_%H%M%S').bak"
}

function normalizeDB {
  $v = $db.Text.Trim()
  $db.Text = $v
  if (!$v) { $db.Focus() }
}

function browseBackup {
  normalizeDB
  if (!$db.Text) { return }
  $Fo = bakFolder
  $Fi = bakFile
  $dst.Text = $Fo + $Fi
  $d = New-Object OpenFileDialog
  $d.Title = "Select folder to backup DB to"
  $d.Filter = 'Backup files|*.bak|All files|*.*'
  $d.ValidateNames = 0
  $d.CheckFileExists = 0
  $d.CheckPathExists = 1
  $d.InitialDirectory = $Fo
  $d.FileName = $Fi

  if ($d.ShowDialog() -eq "OK") {
    $dst.Text = $d.FileName
  }
}
function browseRestore() {
  normalizeDB
  if (!$db.Text) { return }
  $Fo = bakFolder
  $d = New-Object OpenFileDialog
  $d.Title = "Select file to restore DB from"
  $d.Filter = 'Backup files|*.bak|All files|*.*'
  $d.InitialDirectory = $Fo

  if ($d.ShowDialog() -eq "OK") {
    $src.Text = $d.FileName
  }
}

function Validate {
  normalizeDB
  if (!$db.Text) { return }

  switch ($Op.SelectedIndex) {
    0 { ValidateBackup; }
    1 { ValidateRestore; }
  }
}

function ValidateBackup {
  if (!$dst.Text) {
    browseBackup
    return
  }
  if (!$overwrite.IsChecked -and (Test-Path $dst.Text)) {
    $res = $dst.Text
    $res = [System.Windows.Forms.Messagebox]::Show("Overwrite <$res>?", "Backup",
      [System.Windows.Forms.MessageBoxButtons]::YesNo,
      [System.Windows.Forms.MessageBoxIcon]::Hand
    )
    if ($res -ne "Yes") { return }
  }
  $window.DialogResult = 1
}

function ValidateRestore {
  if (!$src.Text) {
    browseRestore
    return
  }
  $window.DialogResult = 1
}

function DoBackup {
  Write-Output "Action:`t`tBackup"
  Write-Output "Server:`t`t$Server"
  Write-Output "Database:`t$($db.Text)"
  Write-Output "Destination:`t$($dst.Text)"
  Write-Output "Starting:`t$(Get-Date)"
  Backup-SqlDatabase -ServerInstance $Server -Database $db.Text -BackupFile $dst.Text
  Write-Output "Finished:`t$(Get-Date)"
}

function DoRestore {
  Write-Output "Action:`t`tRestore"
  Write-Output "Server:`t`t$Server"
  Write-Output "Database:`t$($db.Text)"
  Write-Output "Backup:`t`t$($src.Text)"
  Write-Output "Starting:`t$(Get-Date)"
  Restore-SqlDatabase -ServerInstance $Server -Database $db.Text -BackupFile $src.Text -ReplaceDatabase
  Write-Output "Finished:`t$(Get-Date)"
}

if ($window.ShowDialog()) {
  switch ($Op.SelectedIndex) {
    0 { DoBackup; }
    1 { DoRestore; }
  }
  Write-Output "Нажмите любую клавищу для завершения..."
  [Console]::ReadKey(1) | Out-Null
}
