const assert = require('assert')
const fs = require('fs')

const input = fs.readFileSync(`${__dirname}/input.txt`, 'utf8')

const map = {
  north: { x: 0, y: -1 },
  west: { x: -1, y: 0 },
  south: { x: 0, y: 1 },
  east: { x: 1, y: 0 }
}
const directions = Object.keys(map)

function part1(inp) {
  return runner(inp, {}, a => a)
}

function part2(inp) {
  const visitor = (state, count) => markVisited(state, +count.join(''))
  return runner(inp, { visited: [] }, visitor)
}

function runner(inp, extraState, fn) {
  const instructions = inp.trim().split(', ')
  let state = Object.assign({ x: 0, y: 0, dir: 'north' }, extraState)
  for (let i = 0; i < instructions.length; ++i) {
    const [turn, ...count] = instructions[i]
    state = applyTurn(state, turn)
    state = fn(state, count)
    if (state.ans) return state.ans
    state = getNextLocation(state, +count.join(''))
  }
  return Math.abs(state.x) + Math.abs(state.y)
}

function applyTurn(state, turn) {
  const modifier = turn === 'L' ? 1 : -1
  const newIndex = (directions.indexOf(state.dir) + modifier + 4) % 4
  return Object.assign({}, state, { dir: directions[newIndex] })
}

function getNextLocation(state, count) {
  const test = map[state.dir]
  const x = state.x + (test.x * count)
  const y = state.y + (test.y * count)
  return Object.assign({}, state, { x, y })
}

function markVisited(state, count) {
  const test = map[state.dir]
  const visited = Object.assign({}, state.visited)
  for (let i = 0; i < count; ++i) {
    const x = state.x + (test.x * i)
    const y = state.y + (test.y * i)
    if (visited[`${x},${y}`]) {
      return { ans: Math.abs(x) + Math.abs(y) }
    }
    visited[`${x},${y}`] = true
  }
  return Object.assign({}, state, { visited })
}


assert.equal(part1('R2, L3'), 5)
assert.equal(part1('R2, R2, R2'), 2)
assert.equal(part1('R5, L5, R5, R3'), 12)
assert.equal(part1('R25, L5, R10, R3'), 37)
console.log(`part1: ${part1(input)}`)
assert.equal(part1(input), 146)

assert.equal(part2('R8, R4, R4, R8'), 4)
console.log(`part2: ${part2(input)}`)
assert.equal(part2(input), 131)
