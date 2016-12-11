const assert = require('assert')
const fs = require('fs')

const input = fs.readFileSync(`${__dirname}/input.txt`, 'utf8')
require('../mini-lodash')

function part1(inp) {
  return getValidRooms(inp).sum('id')
}

function part2(inp) {
  return getValidRooms(inp)
    .map(room => Object.assign(room, { decrypted: decryptName(room) }))
    .filter(({ decrypted }) => decrypted.indexOf('northpole') >= 0)
    .shift()
    .id
}

function getValidRooms(inp) {
  const chunks = inp.trim().split('\n')
  return chunks.map(parse).filter(isValid)
}

function decryptName({ name, id }) {
  return name.split('').map(l => rollLetter(l, id)).join('')
}

function rollLetter(l, num) {
  if (l === '-') return ' '
  let code = l.charCodeAt(0) + (num % 26)
  if (code > 122) code -= 26
  return String.fromCharCode(code)
}

function parse(str) {
  const [last, ...parts] = str.split('-').reverse()
  const [id, checksum] = last.split('[')
  return { name: parts.join('-'), id: +id, checksum: checksum.replace(']', '') }
}

function isValid(room) {
  const allLetters = room.name.split('-').join('').split('')
  const expected = allLetters.uniq().sort(frequencySort(allLetters)).join('').substr(0, 5)
  return expected === room.checksum
}

const frequencySort = (allLetters) => (a, b) => {
  const countA = allLetters.count(a)
  const countB = allLetters.count(b)
  if (countA !== countB) return countB - countA
  return a > b ? 1 : -1
}

assert.equal(part1('aaaaa-bbb-z-y-x-123[abxyz]\na-b-c-d-e-f-g-h-987[abcde]\nnot-a-real-room-404[oarel]\ntotally-real-room-200[decoy]\n'), 1514)
console.log(`part1: ${part1(input)}`)
assert.equal(part1(input), 185371)

assert.equal(decryptName({ name: 'qzmt-zixmtkozy-ivhz', id: 343 }), 'very encrypted name')
console.log(`part2: ${part2(input)}`)
assert.equal(part2(input), 984)
