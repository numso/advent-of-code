const assert = require('assert')
const fs = require('fs')
const _ = require('lodash')

const input = fs.readFileSync(`${__dirname}/18.in`, 'utf8')
const sample = `
.#.#...|#.
.....#|##|
.|..|...#.
..|#.....#
#.#|||#|#|
...#.||...
.|....|...
||...#|.#|
|.||||..|.
...#.|..|.
`

function part1 (inp) {
  let map = parse(inp)
  for (let i = 0; i < 10; ++i) map = next(map)
  return count(map, '#') * count(map, '|')
}

function parse (inp) {
  return inp
    .trim()
    .split('\n')
    .map(line => line.split(''))
}

const getCell = (map, x, y) => {
  if (y < 0 || y >= map.length) return '.'
  if (x < 0 || x >= map[y].length) return '.'
  return map[y][x]
}

const nextCell = (cell, adjacents) => {
  const numTrees = _.filter(adjacents, a => a === '|').length
  const numLumberyards = _.filter(adjacents, a => a === '#').length
  if (cell === '.') return numTrees >= 3 ? '|' : '.'
  if (cell === '|') return numLumberyards >= 3 ? '#' : '|'
  if (cell === '#') return numTrees >= 1 && numLumberyards >= 1 ? '#' : '.'
}

function part2 (inp) {
  let map = parse(inp)
  for (let i = 1; i <= 1000000000; ++i) {
    map = next(map)
    console.log(`${i}: ${count(map, '#') * count(map, '|')}`)
  }
  return count(map, '#') * count(map, '|')
}

function next (map) {
  // console.clear()
  // print(map)

  return map.map((line, y) =>
    line.map((cell, x) => {
      const adjacents = [
        getCell(map, x - 1, y - 1),
        getCell(map, x - 1, y),
        getCell(map, x - 1, y + 1),
        getCell(map, x, y - 1),
        getCell(map, x, y + 1),
        getCell(map, x + 1, y - 1),
        getCell(map, x + 1, y),
        getCell(map, x + 1, y + 1)
      ]
      return nextCell(cell, adjacents)
    })
  )
}

function count (map, char) {
  let count = 0
  for (let i = 0; i < map.length; ++i) {
    for (let j = 0; j < map[i].length; ++j) {
      if (map[i][j] === char) count++
    }
  }
  return count
}

const print = map => console.log(map.map(line => line.join('')).join('\n'))

assert.strictEqual(part1(sample), 1147)
console.log(part1(input)) // 515496
console.log(part2(input)) // 233058
