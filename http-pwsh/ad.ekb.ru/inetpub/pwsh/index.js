var http = require('node:http')
var cp = require('node:child_process')
var iconv = require('iconv-lite')

var www = http.createServer(handler)
www.listen(81, '127.0.0.1')

function handler(req, resp) {
  // console.log(req.method, req.url)
  resp.setHeader('Content-Type', 'application/json')
  read(req)
    .then(JSON.parse)
    .then(body => pwsh(body.Command || 'host', {
      in: body,
      method: req.method,
      ctime: new Date
    }))
    .catch(e => ({
      error: e.name,
      message: e.message
    }))
    .then(data =>
      resp.end(JSON.stringify({
        etime: new Date,
        ...data
      })))
}

function read(stream) {
  return new Promise(resolve => {
    var body = ''
    stream.on('data', chunk => body += chunk)
    stream.on('end', _ => resolve(body))
  })
}

function pwsh(cmd, defaults = {}) {
  return new Promise(resolve => {
    var ps = cp.spawn('powershell', ['-Command', '-'], { stdio: 'pipe' })
    var out = ''
    var err = ''
    ps.stdout.on('data', chunk => out += iconv.decode(chunk, 'cp866'))
    ps.stderr.on('data', chunk => err += iconv.decode(chunk, 'cp866'))
    ps.on('close', code => resolve({ ...defaults, out, err, code }))

    ps.stdin.write(cmd)
    ps.stdin.end()
  })
}
