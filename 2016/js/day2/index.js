const assert = require('assert')
const fs = require('fs')

const input = fs.readFileSync(`${__dirname}/input.txt`, 'utf8')

const part1options = {
  '0,0': 1,
  '1,0': 2,
  '2,0': 3,
  '0,1': 4,
  '1,1': 5,
  '2,1': 6,
  '0,2': 7,
  '1,2': 8,
  '2,2': 9,
}

const part2options = {
  '2,0': 1,
  '1,1': 2,
  '2,1': 3,
  '3,1': 4,
  '0,2': 5,
  '1,2': 6,
  '2,2': 7,
  '3,2': 8,
  '4,2': 9,
  '1,3': 'A',
  '2,3': 'B',
  '3,3': 'C',
  '2,4': 'D',
}

function part1(inp) {
  return runner(inp, part1options, { x: 1, y: 1 })
}

function part2(inp) {
  return runner(inp, part2options, { x: 0, y: 2 })
}

function runner(inp, options, initialLocation) {
  const chunks = inp.trim().split('\n')
  const getNum = c => options[`${c.x},${c.y}`]
  let lastDiscovered = initialLocation
  return chunks
    .map((chunk) => lastDiscovered = decodeNumber(getNum, chunk, lastDiscovered))
    .map(getNum)
    .join('')
}

function decodeNumber(getNum, letters, startingCoords) {
  let coords = Object.assign({}, startingCoords)
  for (let i = 0; i < letters.length; ++i) {
    coords = applyInstruction(getNum, coords, letters[i])
  }
  return coords
}

function applyInstruction(getNum, coords, instr) {
  const newCoords = Object.assign({}, coords)
  if (instr === 'U') newCoords.y--
  if (instr === 'D') newCoords.y++
  if (instr === 'L') newCoords.x--
  if (instr === 'R') newCoords.x++
  return getNum(newCoords) ? newCoords : coords
}


assert.equal(part1('ULL\nRRDDD\nLURDL\nUUUUD'), 1985)
console.log(`part1: ${part1(input)}`)
assert.equal(part1(input), 98575)

assert.equal(part2('ULL\nRRDDD\nLURDL\nUUUUD'), '5DB3')
console.log(`part2: ${part2(input)}`)
assert.equal(part2(input), 'CD8D4')
