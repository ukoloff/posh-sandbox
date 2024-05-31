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
  cp.spawn('reg', ['add',  'HKCU\\SOFTWARE\\Classes\\.cal', '/ve', '/d', 'SuperCalc4', '/f'], {stdio: 'inherit'})
}

function uninstall() {
  cp.spawn('reg', ['delete',  'HKCU\\SOFTWARE\\Classes\\.cal', '/f'],  {stdio: 'inherit'})
}

function launch(cal) {

}
