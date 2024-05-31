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
  cp.spawnSync('reg add HKCU\\SOFTWARE\\Classes\\.cal /ve /d SuperCalc4 /f',
    {
      stdio: 'inherit',
      shell: true,
    })
  cp.spawnSync(`reg add HKCU\\SOFTWARE\\Classes\\SuperCalc4\\shell\\open\\command /ve /d "${process.argv[0]} ${process.argv[1]} ""%1""" /f`,
    {
      stdio: 'inherit',
      shell: true,
    })
}

function uninstall() {
  cp.spawnSync('reg delete HKCU\\SOFTWARE\\Classes\\.cal /f',
    {
      stdio: 'inherit',
      shell: true,
    })
  cp.spawnSync(`reg delete HKCU\\SOFTWARE\\Classes\\SuperCalc4 /f`,
    {
      stdio: 'inherit',
      shell: true,
    })
}

function launch(cal) {
  const path = require('path')
  console.log('Launching:', path.resolve(cal))
  setTimeout(x => x, 3000)
}
