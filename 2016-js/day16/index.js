const assert = require('assert')

function run(initial, size) {
  let cur
  for (cur = initial; cur.length < size; cur = next(cur));
  cur = cur.substr(0, size)
  for (cur = checksum(cur); cur.length % 2 === 0; cur = checksum(cur));
  return cur
}

const invert = (char) => char === '0' ? '1' : '0'
function next(str) {
  const str2 = str.split('').reverse().map(invert).join('')
  return `${str}0${str2}`
}

function checksum(str) {
  let resp = ''
  for (let i = 0; i < str.length; i += 2) {
    const [a, b] = str.substr(i, 2)
    resp += a === b ? '1' : '0'
  }
  return resp
}

assert.equal(run('10000', 20), '01100')
const ans = run('10111011111001111', 272)
console.log(`part1: ${ans}`)
assert.equal(ans, '11101010111100010')

const ans2 = run('10111011111001111', 35651584)
console.log(`part2: ${ans2}`)
assert.equal(ans2, '01001101001000101')
