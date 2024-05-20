var http = require('node:http')
var https = require('node:https')
var cp = require('node:child_process')
var iconv = require('iconv-lite')

var www = http.createServer(handler)
www.listen(80)

function handler(req, resp) {
  // console.log(req.method, req.url)
  resp.setHeader('Content-Type', 'application/json')

  let xUser
  req2promise(https.get('https://ad.ekb.ru/auth/basic/',
    {
      headers: { Authorization: req.headers['authorization'] },
    }))
    .then(resp => {
      if (resp.statusCode != 200 || !(xUser = resp.headers['x-user'])) {
        return Promise.reject({
          name: 401,
          message: 'Basic authentication required'
        })
      }
    })
    .then(_ => read(req))
    .then(JSON.parse)
    .then(body => pwsh(body.Command || 'host', {
      in: body,
      user: xUser,
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

function req2promise(req) {
  // Convert http request into Promise
  return new Promise(handler)

  function handler(resolve, reject) {
    req.on('error', reject)
    req.on('response', resp)

    function resp(resp) {
      resp.resume() // Discard body
      resolve(resp)
    }
  }
}

function read(stream) {
  return new Promise(handler)

  function handler(resolve) {
    var body = ''
    stream.on('data', chunk => body += chunk)
    stream.on('end', _ => resolve(body))
  }
}

function pwsh(cmd, defaults = {}) {
  return new Promise(handler)

  function handler(resolve, reject) {
    var ps = cp.spawn('powershell', ['-Command', '-'], { stdio: 'pipe' })
    var out = ''
    var err = ''
    ps.on('error', reject)
    ps.stdout.on('data', chunk => out += iconv.decode(chunk, 'cp866'))
    ps.stderr.on('data', chunk => err += iconv.decode(chunk, 'cp866'))
    ps.on('close', code => resolve({ ...defaults, out, err, code }))

    ps.stdin.write(cmd)
    ps.stdin.end()
  }
}
