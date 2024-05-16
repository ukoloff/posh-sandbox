var http = require('node:http')
var cp = require('node:child_process')
var iconv = require('iconv-lite')

var www = http.createServer(handler)
www.listen(80)

function handler(req, resp) {
  console.log(req.method, req.url)
  resp.writeHead(200)
  resp.end('hello world\n')
}
