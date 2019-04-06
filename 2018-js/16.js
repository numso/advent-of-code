const assert = require('assert')
const fs = require('fs')
const _ = require('lodash')

const input = fs.readFileSync(`${__dirname}/16.in`, 'utf8')
const input2 = fs.readFileSync(`${__dirname}/16b.in`, 'utf8')

const operations = {
  addr: (a, b, c, mem) => (mem[c] = mem[a] + mem[b]),
  addi: (a, b, c, mem) => (mem[c] = mem[a] + b),

  mulr: (a, b, c, mem) => (mem[c] = mem[a] * mem[b]),
  muli: (a, b, c, mem) => (mem[c] = mem[a] * b),

  banr: (a, b, c, mem) => (mem[c] = mem[a] & mem[b]),
  bani: (a, b, c, mem) => (mem[c] = mem[a] & b),

  borr: (a, b, c, mem) => (mem[c] = mem[a] | mem[b]),
  bori: (a, b, c, mem) => (mem[c] = mem[a] | b),

  setr: (a, _, c, mem) => (mem[c] = mem[a]),
  seti: (a, _, c, mem) => (mem[c] = a),

  gtir: (a, b, c, mem) => (mem[c] = a > mem[b] ? 1 : 0),
  gtri: (a, b, c, mem) => (mem[c] = mem[a] > b ? 1 : 0),
  gtrr: (a, b, c, mem) => (mem[c] = mem[a] > mem[b] ? 1 : 0),

  eqir: (a, b, c, mem) => (mem[c] = a === mem[b] ? 1 : 0),
  eqri: (a, b, c, mem) => (mem[c] = mem[a] === b ? 1 : 0),
  eqrr: (a, b, c, mem) => (mem[c] = mem[a] === mem[b] ? 1 : 0)
}

function part1 (inp) {
  const cases = inp
    .trim()
    .split('\n\n')
    .map(parse)
  return _.countBy(cases, args => check(...args).length >= 3).true
}

function parse (str) {
  let [before, ops, after] = str.split('\n')
  before = JSON.parse(before.replace('Before: ', ''))
  after = JSON.parse(after.replace('After:  ', ''))
  ops = ops.split(' ').map(a => +a)
  return [before, after, ops]
}

const check = (before, after, [, ...opcodes]) => {
  const result = _.pickBy(operations, (fn, key) => {
    const mem = [...before]
    fn(...opcodes, mem)
    return _.isEqual(mem, after)
  })
  return Object.keys(result)
}

function part2 (examples, inp) {
  const opMap = calibrate(examples)
  let instructions = inp
    .trim()
    .split('\n')
    .map(line => line.split(' ').map(a => +a))
  const mem = [0, 0, 0, 0]
  _.forEach(instructions, ([code, ...args]) => {
    operations[opMap[code]](...args, mem)
  })
  return mem[0]
}

function calibrate (inp) {
  let cases = inp
    .trim()
    .split('\n\n')
    .map(parse)
  const keys = Object.keys(operations)
  const usedKeys = []
  const opMap = {}
  while (keys.length) {
    _.forEach(cases, args => {
      let result = check(...args)
      result = _.reject(result, a => _.includes(usedKeys, a))
      if (result.length === 1) {
        const opCode = args[2][0]
        const key = result[0]
        opMap[opCode] = key
        _.remove(keys, a => a === key)
        usedKeys.push(key)
        cases = _.reject(cases, a => a[0] === opCode)
        return false
      }
    })
  }
  return opMap
}

assert.strictEqual(check([3, 2, 1, 1], [3, 2, 2, 1], [9, 2, 1, 2]).length, 3)

console.log(part1(input)) // 580
console.log(part2(input, input2)) // ?
