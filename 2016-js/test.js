const fs = require('fs')
const days = [...Array(25)]

let [_, __, only, omitted = ''] = process.argv
omitted = omitted.split(',')

const toRun = days
  .map((_, i) => i + 1)
  .map(num => `day${num}`)
  .filter(fs.existsSync)
  .filter(num => only ? num === only : !omitted.includes(num))

toRun.map(file => {
  console.log(`\x1b[36mRunning ${file}\x1b[0m`)
  require(`./${file}`)
})

if (!toRun.length && only) {
  console.log(`\x1b[31m${only} does not exist\x1b[0m`)
}
