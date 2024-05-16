var fs = require('node:fs')

module.exports = restart

var times = {}

function restart() {
  for (let m of Object.values(require.cache)) {
    var f = m.filename
    var mtime = fs.statSync(f).mtime.getTime()
    if (!(f in times)) {
      times[f] = mtime
    }
    if (times[f] != mtime) {
      process.exit()
    }
  }
}
