const assert = require('assert')
const fs = require('fs')
const _ = require('lodash')

const input = fs.readFileSync(`${__dirname}/17.in`, 'utf8')
const sample = `
x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=1..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504
`

function part1 (inp) {
  const [map, minX] = parse(inp)
  map[0][500 - minX + 1] = '+'
  traverseDown(map, 500 - minX + 1, 1)
  // print(map)
  let count = 0
  for (let y = 0; y < map.length; ++y) {
    for (let x = 0; x < map[y].length; ++x) {
      if (map[y][x] === '|' || map[y][x] === '~') count++
    }
  }
  return count
}

function part2 (inp) {
  const [map, minX] = parse(inp)
  map[0][500 - minX + 1] = '+'
  traverseDown(map, 500 - minX + 1, 1)
  // print(map)
  let count = 0
  for (let y = 0; y < map.length; ++y) {
    for (let x = 0; x < map[y].length; ++x) {
      if (map[y][x] === '~') count++
    }
  }
  return count
}

function traverseDown (map, x, _y) {
  let y = _y
  while (y < map.length && map[y][x] !== '#') {
    map[y][x] = '|'
    y++
  }
  if (y >= map.length) return
  spreadOut(map, x, y - 1)
}

function spreadOut (map, _x, y) {
  let x = _x
  let overflows = false
  while (x >= 0 && map[y][x] !== '#') {
    if (map[y + 1][x] !== '#' && map[y + 1][x] !== '~') {
      traverseDown(map, x, y)
      if (map[y + 1][x] === '|') {
        overflows = true
        break
      }
    }
    map[y][x] = '|'
    x--
  }
  x = _x
  while (x <= map[0].length && map[y][x] !== '#') {
    if (map[y + 1][x] !== '#' && map[y + 1][x] !== '~') {
      traverseDown(map, x, y)
      if (map[y + 1][x] === '|') {
        overflows = true
        break
      }
    }
    map[y][x] = '|'
    x++
  }
  if (!overflows) {
    x = _x
    while (x >= 0 && map[y][x] !== '#') {
      map[y][x] = '~'
      x--
    }
    x = _x
    while (x <= map[0].length && map[y][x] !== '#') {
      map[y][x] = '~'
      x++
    }
    spreadOut(map, _x, y - 1)
  }
}

function parse (inp) {
  const lines = inp
    .trim()
    .split('\n')
    .map(line => {
      const [, a, b, , c, d] = /(.)=(\d+), (.)=(\d+)\.\.(\d+)/.exec(line)
      return [a === 'y', +b, +c, +d]
    })
  const xs = _.flatten(lines.map(([a, b, c, d]) => (a ? [c, d] : b)))
  const ys = _.flatten(lines.map(([a, b, c, d]) => (a ? b : [c, d])))
  const minX = Math.min(...xs)
  const maxX = Math.max(...xs)
  // const minY = Math.min(...ys)
  const maxY = Math.max(...ys)
  const map = [...new Array(maxY + 1)].map(line =>
    [...new Array(maxX - minX + 3)].map(() => '.')
  )
  _.forEach(lines, ([reverse, x, y1, y2]) => {
    for (let y = y1; y <= y2; ++y) {
      if (reverse) map[x][y - minX + 1] = '#'
      else map[y][x - minX + 1] = '#'
    }
  })
  return [map, minX]
}

function print (map) {
  console.log(map.map(line => line.join('')).join('\n'))
}

assert.strictEqual(part1(sample), 57)
console.log(part1(input) - 7)
console.log(part2(input))
