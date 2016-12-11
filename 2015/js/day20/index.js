const assert = require('assert')
require('../../../2016/js/mini-lodash')

function part1(inp) {
  for (let i = 1; true; ++i) {
    const factors = getFactors(i)
    const sum = factors.sum()
    if (i % 50000 === 0) console.log(i, sum * 10)
    if (sum * 10 >= inp) return i
  }
}

function part2(inp) {
  const houses = []
  for (let i = 1; true; ++i) {
    for (let j = 1; j <= 50; ++j) {
      const a = i * j
      houses[a] = houses[a] || 0
      houses[a] += 11 * i
    }
    if (houses[i] >= inp) return i
  }
}

function getFactors(num) {
  if (num === 1) return [1]
  let factors = [1, num]
  const last = Math.floor(num / 2)
  for (let i = 2; i <= last; ++i) {
    if (num % i === 0) factors.push(i)
  }
  return factors
}

assert.equal(part1(150), 8)
assert.equal(part1(100), 6)
const ans = part1(34000000)
console.log(`part1: ${ans}`)
assert.equal(ans, 786240)

assert.equal(part2(150), 8)
assert.equal(part2(100), 6)
const ans2 = part2(34000000)
console.log(`part2: ${ans2}`)
assert.equal(ans2, 831600)