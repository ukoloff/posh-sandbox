const cluster = require('node:cluster')

if (cluster.isPrimary)  {
  require('./master')
} else {
  require('./slave')
}
