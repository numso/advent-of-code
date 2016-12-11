const assert = require('assert')
const fs = require('fs')
const sleep = require('sleep')

const testInput = fs.readFileSync(`${__dirname}/test-input.txt`, 'utf8')
const input = fs.readFileSync(`${__dirname}/input.txt`, 'utf8')
require('../mini-lodash')

const WIDTH = 50
const HEIGHT = 6

function part1(inp) {
  const instructions = inp.trim().split('\n')
  const board = instructions.reduce(tick, {})
  return tally(board)
}

function tally(board) {
  let count = 0
  for (const key in board) {
    if (board[key]) count++
  }
  return count
}

function tick(oldBoard, instruction) {
  const instr = parse(instruction)
  const board = Object.assign({}, oldBoard)
  if (instr.type === 'rect') {
    for (let i = 0; i < instr.width; ++i) {
      for (let j = 0; j < instr.height; ++j) {
        board[`${i}-${j}`] = true
      }
    }
  } else if (instr.type === 'row') {
    for (let i = 0; i < WIDTH; ++i) {
      const next = (i - instr.count + WIDTH) % WIDTH
      board[`${i}-${instr.which}`] = oldBoard[`${next}-${instr.which}`]
    }
  } else {
    for (let i = 0; i < HEIGHT; ++i) {
      const next = (i - instr.count + HEIGHT) % HEIGHT
      board[`${instr.which}-${i}`] = oldBoard[`${instr.which}-${next}`]
    }
  }
  debug(board)
  return board
}

function parse(instr) {
  if (instr.startsWith('rect')) {
    const [a, b] = instr.replace('rect ', '').split('x')
    return { type: 'rect', width: +a, height: +b }
  }
  if (instr.startsWith('rotate row')) {
    const [a, b] = instr.replace('rotate row y=', '').split(' by ')
    return { type: 'row', which: +a, count: +b }
  }
  const [a, b] = instr.replace('rotate column x=', '').split(' by ')
  return { type: 'column', which: +a, count: +b }
}

function debug(board) {
  for (let i = 0; i < HEIGHT; ++i) {
    for (let j = 0; j < WIDTH; ++j) {
      process.stdout.cursorTo(j, i)
      process.stdout.write(board[`${j}-${i}`] ? '#' : '.')
    }
  }
  sleep.usleep(10000)
}

assert.equal(part1(testInput), 6)
const ans = part1(input)
console.log(`\npart1: ${ans}`)
assert.equal(ans, 115)

// console.log(`part2: ${part2(input)}`)
// assert.equal(part2(input), 'EFEYKFRFIJ')
