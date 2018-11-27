const assert = require('assert')
const fs = require('fs')

const input = fs.readFileSync(`${__dirname}/input.txt`, 'utf8')

function part1(inp) {
  const input = inp.trim()
  let count = 0
  for (let i = 0; i < input.length; ++i) {
    const char = input[i]
    if (char === '(') {
      const j = input.indexOf(')', i)
      let [a, b] = input.slice(i + 1, j).split('x')
      a = +a
      b = +b
      count += a * b
      i = j + a
    } else {
      count++
    }
  }
  return count
}

function part2(inp) {
  const input = inp.trim()
  return calc(input, 1)
}

function calc(input, modifier) {
  let count = 0
  for (let i = 0; i < input.length; ++i) {
    const char = input[i]
    if (char === '(') {
      const j = input.indexOf(')', i)
      let [a, b] = input.slice(i + 1, j).split('x')
      a = +a
      b = +b
      const sliced = input.slice(j + 1, j + 1 + a)
      count += calc(sliced, b)
      i = j + a
    } else {
      count++
    }
  }
  return count * modifier
}

assert.equal(part1('ADVENT'), 6)
assert.equal(part1('A(1x5)BC'), 7)
assert.equal(part1('(3x3)XYZ'), 9)
assert.equal(part1('A(2x2)BCD(2x2)EFG'), 11)
assert.equal(part1('(6x1)(1x3)A'), 6)
assert.equal(part1('X(8x2)(3x3)ABCY'), 18)
console.log(`part1: ${part1(input)}`)
assert.equal(part1(input), 110346)

assert.equal(part2('(3x3)XYZ'), 9)
assert.equal(part2('X(8x2)(3x3)ABCY'), 20)
assert.equal(part2('(27x12)(20x12)(13x14)(7x10)(1x12)A'), 241920)
assert.equal(part2('(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN'), 445)
console.log(`part2: ${part2(input)}`)
assert.equal(part2(input), 10774309173)
