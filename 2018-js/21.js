const assert = require('assert')
const fs = require('fs')
const _ = require('lodash')

const input = fs.readFileSync(`${__dirname}/21.in`, 'utf8')

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
  eqrr: (a, b, c, mem) => {
    const val = mem[a]
    if (!cache[val]) {
      cache[val] = true
      console.log(val)
    } else {
      console.log('DUPE')
    }
    mem[c] = 0
  }
}

const cache = {}

function part1 (inp) {
  const mem = [0, 0, 0, 0, 0, 0]
  const [ip, instructions] = parse(inp)
  while (true) {
    if (mem[ip] >= instructions.length) break
    const [key, ...args] = instructions[mem[ip]]
    operations[key](...args, mem)
    mem[ip]++
  }
  return mem[0]
}

function parse (inp) {
  let lines = inp.trim().split('\n')
  const ip = +lines.shift().replace('#ip ', '')
  lines = lines.map(line => {
    const [a, b, c, d] = line.split(' ')
    return [a, +b, +c, +d]
  })
  return [ip, lines]
}

console.log(part1(input))
