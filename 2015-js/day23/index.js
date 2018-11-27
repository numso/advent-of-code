const assert = require('assert')
const fs = require('fs')

const testInput = fs.readFileSync(`${__dirname}/test-input.txt`, 'utf8')
const input = fs.readFileSync(`${__dirname}/input.txt`, 'utf8')
require('../../../2016/js/mini-lodash')

function run(inp, register, a = 0) {
  const instructions = inp.trim().split('\n').map(parse)
  let state = { cur: 0, a, b: 0 }
  while (state.cur >= 0 && state.cur < instructions.length) {
    state = tick(instructions, state)
  }
  return state[register]
}

function tick(instructions, state) {
  const { cur, a, b } = state
  const instr = instructions[cur]
  switch (instr.type) {
    case 'increment': {
      const newState = { cur: cur + 1, a, b }
      newState[instr.register]++
      return newState
    }
    case 'triple': {
      const newState = { cur: cur + 1, a, b }
      newState[instr.register] *= 3
      return newState
    }
    case 'half': {
      const newState = { cur: cur + 1, a, b }
      newState[instr.register] /= 2
      return newState
    }
    case 'jump': return { cur: cur + instr.num, a, b }
    case 'jump-if-one': {
      if (state[instr.register] === 1) return { cur: cur + instr.num, a, b }
      else return { cur: cur + 1, a, b }
    }
    case 'jump-if-even': {
      if (state[instr.register] % 2 === 0) return { cur: cur + instr.num, a, b }
      else return { cur: cur + 1, a, b }
    }
  }
}

function parse(instr) {
  if (instr.startsWith('inc ')) return { type: 'increment', register: instr.replace('inc ', '') }
  if (instr.startsWith('tpl ')) return { type: 'triple', register: instr.replace('tpl ', '') }
  if (instr.startsWith('hlf ')) return { type: 'half', register: instr.replace('hlf ', '') }
  if (instr.startsWith('jmp ')) return { type: 'jump', num: +instr.replace('jmp ', '') }
  if (instr.startsWith('jio ')) {
    const [register, num] = instr.replace('jio ', '').split(', ')
    return { type: 'jump-if-one', register, num: +num }
  }
  if (instr.startsWith('jie ')) {
    const [register, num] = instr.replace('jie ', '').split(', ')
    return { type: 'jump-if-even', register, num: +num }
  }
}

assert.equal(run(testInput, 'a'), 2)
const ans = run(input, 'b')
console.log(`run: ${ans}`)
assert.equal(ans, 184)

const ans2 = run(input, 'b', 1)
console.log(`run: ${ans2}`)
assert.equal(ans, 231)
