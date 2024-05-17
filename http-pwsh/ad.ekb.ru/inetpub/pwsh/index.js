var http = require('node:http')
var cp = require('node:child_process')
var iconv = require('iconv-lite')

var www = http.createServer(handler)
www.listen(80)

function handler(req, resp) {
  console.log(req.method, req.url)
  resp.setHeader('Content-Type', 'application/json')
  var body = ''
  req.on('data', chunk => body += chunk)
  req.on('end', chunk => {
    resp.end(JSON.stringify({
      method: req.method,
      msg: "Hello, world!",
      ctime: new Date,
      data: JSON.parse(body)
    }))
  })
}
