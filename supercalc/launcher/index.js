var cp = require('child_process')

const dosBox = "C:\\Program Files (x86)\\DOSBox-0.74-3\\DOSBox.exe"

if (process.argv.length != 3) {
  process.exit(1)
}

switch (process.argv[2]) {
  case '--install':
    install();
    break;
  case '--uninstall':
    uninstall();
    break;
  default:
    launch(process.argv[2])
}

function install() {
  var ps = cp.spawn('powershell', ['-command', '-'], { stdio: ['pipe', 'inherit', 'inherit'] })
  ps.stdin.write(`
    Set-Location HKCU:\\SOFTWARE\\Classes
    New-Item -path .cal -force -value "SuperCalc4"
    New-Item -path SuperCalc4\\shell\\open\\command -force -value '"${process.argv[0]}" "${process.argv[1]}" "%1"'
  `)
  ps.stdin.end()
}

function uninstall() {
  var ps = cp.spawn('powershell', ['-command', '-'], { stdio: ['pipe', 'inherit', 'inherit'] })
  ps.stdin.write(`
    Set-Location HKCU:\\SOFTWARE\\Classes
    Remove-Item -path .cal
    Remove-Item -path SuperCalc4 -Recurse
  `)
  ps.stdin.end()
}

function launch(cal) {
  const path = require('path')
  cal = path.resolve(cal)

  var ps = cp.spawn('powershell', ['-command', '-'], { stdio: ['pipe', 'inherit', 'inherit'] })
  ps.stdin.write(`
    $DosBox = '${dosBox}'
    $CAL = '${cal}'
    # https://blog.idera.com/database-tools/converting-file-paths-to-8-3-part-1/
    # $CAL = (New-Object -ComObject Scripting.FileSystemObject).GetFile($CAL).ShortPath
    $Folder = Split-Path $CAL -Parent
    $CAL = Split-Path $CAL -Leaf
    $commands = "mount d: $Folder", "d:", "sc4 $CAL", "exit"
    $commands = ($commands|% {'-c "' + $_ + '"'}) -join ' '
    &$DosBox $commands
  `)
  ps.stdin.end()
}
