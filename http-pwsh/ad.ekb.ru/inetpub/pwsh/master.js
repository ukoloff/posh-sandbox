const cluster = require('node:cluster')
const numCPUs = require('node:os').availableParallelism()

for (let i = 0; i < numCPUs; i++) {
  cluster.fork()
}

cluster.on('exit', (worker, code, signal) => {
  console.log(`worker [${worker.id}]${worker.process.pid} died`)
  cluster.fork()
})
