const assert = require('assert')
const fs = require('fs')

const input = fs.readFileSync(`${__dirname}/input.txt`, 'utf8')

function part1(inp) {
  const chunks = inp.trim().split('\n')
  return chunks.map(parse).filter(isValid).length
}

function part2(inp) {
  const chunks = inp.trim().split('\n')
  const parsed = chunks.map(parse)
  const newArray = []
  for (let i = 0; i < parsed.length; i += 3) {
    newArray.push([parsed[i][0], parsed[i + 1][0], parsed[i + 2][0]])
    newArray.push([parsed[i][1], parsed[i + 1][1], parsed[i + 2][1]])
    newArray.push([parsed[i][2], parsed[i + 1][2], parsed[i + 2][2]])
  }
  return newArray.filter(isValid).length
}

function parse(str) {
  return str.split(' ')
    .filter(num => num !== '')
    .map(num => +num)
}

function isValid(parsed) {
  const [a, b, c] = parsed.sort((a, b) => a > b)
  return a + b > c
}


assert.equal(part1('    5   10   25\n  541  588  421\n  827  272  126'), 1)
console.log(`part1: ${part1(input)}`)
assert.equal(part1(input), 993)

assert.equal(part2('    5   10   25\n  541  588  421\n  827  272  126'), 0)
console.log(`part2: ${part2(input)}`)
assert.equal(part2(input), 1849)
