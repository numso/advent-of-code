const assert = require('assert')

function run(row, col) {
  let prev = 20151125
  let x = 1
  let y = 1
  let nextRow = 2
  while (true) {
    if (x === row && y === col) return prev
    prev = (prev * 252533) % 33554393
    if (x === 1) {
      x = nextRow
      nextRow++
      y = 1
    } else {
      x--
      y++
    }
  }
}

assert.equal(run(1, 1), 20151125)
assert.equal(run(2, 1), 31916031)
assert.equal(run(1, 2), 18749137)
assert.equal(run(2, 2), 21629792)
assert.equal(run(4, 6), 31527494)
assert.equal(run(5, 1), 77061)
const ans = run(2947, 3029)
console.log(`part1: ${ans}`)
assert.equal(ans, 19980801)
