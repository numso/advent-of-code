const assert = require('assert')
const fs = require('fs')

const testInput = fs.readFileSync(`${__dirname}/test-input.txt`, 'utf8')
const input = fs.readFileSync(`${__dirname}/input.txt`, 'utf8')

function run(inp, overrides = {}) {
  const instructions = inp.trim().split('\n').map(parse)
  let state = Object.assign({ cur: 0, a: 0, b: 0, c: 0, d: 0 }, overrides)
  while (state.cur >= 0 && state.cur < instructions.length) {
    state = tick(instructions, state)
  }
  return state.a
}

function tick(instructions, state) {
  const { type, register, num, from, to } = instructions[state.cur]
  switch (type) {
    case 'increment': {
      return Object.assign(state, { cur: state.cur + 1, [register]: state[register] + 1 })
    }
    case 'decrement': {
      return Object.assign(state, { cur: state.cur + 1, [register]: state[register] - 1 })
    }
    case 'copy': {
      const val = (isNaN(+from)) ? state[from] : +from
      return Object.assign(state, { cur: state.cur + 1, [to]: val })
    }
    case 'jump': {
      const cur = (state[register] === 0) ? state.cur + 1 : state.cur + num
      return Object.assign(state, { cur })
    }
  }
}

function parse(instr) {
  if (instr.startsWith('inc ')) return { type: 'increment', register: instr.replace('inc ', '') }
  if (instr.startsWith('dec ')) return { type: 'decrement', register: instr.replace('dec ', '') }
  if (instr.startsWith('cpy ')) {
    const [from, to] = instr.replace('cpy ', '').split(' ')
    return { type: 'copy', from, to }
  }
  if (instr.startsWith('jnz ')) {
    const [register, num] = instr.replace('jnz ', '').split(' ')
    return { type: 'jump', register, num: +num }
  }
}

assert.equal(run(testInput), 42)
const ans = run(input)
console.log(`part1: ${ans}`)
assert.equal(ans, 318020)

const ans2 = run(input, { c: 1 })
console.log(`part2: ${ans2}`)
assert.equal(ans2, 9227674)
