const assert = require('assert')
const fs = require('fs')

const testInput = fs.readFileSync(`${__dirname}/test-input.txt`, 'utf8')
const input = fs.readFileSync(`${__dirname}/input.txt`, 'utf8')

function part1(inp, target) {
  const input = inp.trim().split('\n')
  const [bots, instructions] = input.reduce(parse, [[], []])
  let foundIt = undefined
  let i = 0
  const outputs = []
  while (foundIt === undefined && i < 10000) {
    i++
    foundIt = tick(bots, outputs, instructions, target)
  }
  console.log(outputs)
  return foundIt
}

function tick(bots, outputs, instructions, target) {
  for (let i = 0; i < bots.length; ++i) {
    const val = bots[i] || []
    if (val.length === 2) {
      const [low, high] = val.sort((a, b) => a - b)
      if ('low' in instructions[i]) {
        bots[instructions[i].low] = bots[instructions[i].low] || []
        bots[instructions[i].low].push(low)
      } else {
        outputs[instructions[i].lowOut] = outputs[instructions[i].lowOut] || []
        outputs[instructions[i].lowOut].push(low)
      }
      if ('high' in instructions[i]) {
        bots[instructions[i].high] = bots[instructions[i].high] || []
        bots[instructions[i].high].push(high)
      } else {
        outputs[instructions[i].highOut] = outputs[instructions[i].highOut] || []
        outputs[instructions[i].highOut].push(high)
      }
      // if (low === target[0] && high === target[1]) return i
      bots[i].length = 0
    }
  }
}

function parse(memo, instr) {
  const [bots, instructions] = memo
  if (instr.startsWith('value ')) {
    const newInstr = instr.replace('value ', '')
    const [val, bot] = newInstr.split(' goes to bot ')
    bots[+bot] = bots[+bot] || []
    bots[+bot].push(+val)
  } else {
    const newInstr = instr.replace('bot ', '')
    const [bot, rest] = newInstr.split(' gives low to ')
    const [low, high] = rest.split(' and high to ')
    instructions[+bot] = instructions[+bot] || {}
    if (low.startsWith('bot ')) {
      instructions[+bot].low = +low.replace('bot ', '')
    } else {
      instructions[+bot].lowOut = +low.replace('output ', '')
    }
    if (high.startsWith('bot ')) {
      instructions[+bot].high = +high.replace('bot ', '')
    } else {
      instructions[+bot].highOut = +high.replace('output ', '')
    }
  }
  return memo
}

assert.equal(part1(testInput, [2, 5]), 2)
assert.equal(part1(testInput, [3, 5]), 0)
assert.equal(part1(testInput, [2, 3]), 1)
console.log(`part1: ${part1(input, [17, 61])}`)
assert.equal(part1(input, [17, 61]), 116)

assert.equal(part2(testInput), 30)
console.log(`part2: ${part2(input)}`)
assert.equal(part2(input), 23903)
