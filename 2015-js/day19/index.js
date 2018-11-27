const assert = require('assert')
const fs = require('fs')

const testInput = fs.readFileSync(`${__dirname}/test-input.txt`, 'utf8')
const testInput2 = fs.readFileSync(`${__dirname}/test-input2.txt`, 'utf8')
const input = fs.readFileSync(`${__dirname}/input.txt`, 'utf8')

function part1(inp) {
  const { replacements, formula } = parse(inp)
  const newFormulas = {}
  replacements.map(r => fusion(formula, r, newFormulas))
  return Object.keys(newFormulas).length
}

function part2(inp) {
  // halp
}

function fusion(formula, [from, to], newFormulas) {
  let pointer = 0
  while (true) {
    const i = formula.indexOf(from, pointer)
    if (i === -1) return
    const newFormula = formula.slice(0, pointer) + formula.slice(pointer).replace(from, to)
    newFormulas[newFormula] = true
    pointer = i + 1
  }
}

function parse(inp) {
  const [_replacements, formula] = inp.trim().split('\n\n')
  const replacements = _replacements.split('\n').map(r => r.split(' => '))
  return { replacements, formula }
}

assert.equal(part1(testInput), 4)
assert.equal(part1(testInput2), 7)
const ans = part1(input)
console.log(`part1: ${ans}`)
assert.equal(ans, 535)

assert.equal(part2(testInput), 3)
assert.equal(part2(testInput2), 6)
const ans2 = part2(input)
console.log(`part2: ${ans2}`)
// assert.equal(ans2, )
