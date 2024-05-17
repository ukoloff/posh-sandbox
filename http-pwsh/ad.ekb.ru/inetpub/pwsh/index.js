var http = require('node:http')
var cp = require('node:child_process')
var iconv = require('iconv-lite')

var www = http.createServer(handler)
www.listen(80)

function handler(req, resp) {
  console.log(req.method, req.url)
  resp.setHeader('Content-Type', 'application/json')
  read(req, body =>
    resp.end(JSON.stringify({
      method: req.method,
      msg: "Hello, world!",
      ctime: new Date,
      in: JSON.parse(body)
    })))
}

function read(stream, cb) {
  var body = ''
  stream.on('data', chunk => body += chunk)
  stream.on('end', chunk => cb(body))
}
