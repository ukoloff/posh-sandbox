var http = require('node:http')
const cluster = require('node:cluster')
var cp = require('node:child_process')
var iconv = require('iconv-lite')

var restart = require('./restart')

var www = http.createServer(handler)
www.listen(80)

function handler(req, resp) {
  restart()
  console.log(`[${cluster.worker.id}]`, req.method, req.url)
  resp.writeHead(200)
  resp.end('hello world\n')
}
