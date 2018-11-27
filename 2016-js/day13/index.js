const assert = require('assert')
require('../mini-lodash')

function part1(num, target) {
  const visited = {}
  const toVisit = [{ loc: '1,1', steps: 0 }]
  while (true) {
    const cur = toVisit.shift()
    const tiles = getSurroundingTiles(cur.loc, num)
    tiles.forEach(tile => {
      if (!visited[tile]) {
        visited[tile] = cur.steps + 1
        toVisit.push({ loc: tile, steps: cur.steps + 1 })
      }
    })
    if (visited[target]) return visited[target]
  }
}

function part2(num, dist) {
  const visited = {}
  const toVisit = [{ loc: '1,1', steps: 0 }]
  while (true) {
    const cur = toVisit.shift()
    const tiles = getSurroundingTiles(cur.loc, num)
    tiles.forEach(tile => {
      if (!visited[tile]) {
        visited[tile] = cur.steps + 1
        toVisit.push({ loc: tile, steps: cur.steps + 1 })
      }
    })
    if (cur.steps >= dist) {
      return Object.keys(visited).map(key => visited[key]).filter(num => num <= dist).length
    }
  }
}

function getTile(x, y, num) {
  if (x < 0 || y < 0) return null
  const id = ((x * x) + (3 * x) + (2 * x * y) + y + (y * y)) + num
  const bin = id.toString(2)
  const numOnes = bin.split('').filter(char => char === '1').length
  if (numOnes % 2 !== 0) return null
  return `${x},${y}`
}

function getSurroundingTiles(tile, num) {
  const [x, y] = tile.split(',')
  return [
    getTile(+x + 1, +y, num),
    getTile(+x - 1, +y, num),
    getTile(+x, +y + 1, num),
    getTile(+x, +y - 1, num),
  ].filter(a => a)
}

assert.equal(part1(10, '7,4'), 11)
const ans = part1(1352, '31,39')
console.log(`part1: ${ans}`)
assert.equal(ans, 90)

const ans2 = part2(1352, 50)
console.log(`part2: ${ans2}`)
assert.equal(ans2, 135)
