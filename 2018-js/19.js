const assert = require('assert')
const fs = require('fs')
const _ = require('lodash')

const input = fs.readFileSync(`${__dirname}/19.in`, 'utf8')
const sample = `
#ip 0
seti 5 0 1
seti 6 0 2
addi 0 1 0
addr 1 2 3
setr 1 0 0
seti 8 0 4
seti 9 0 5
`

const operations = {
  addr: (a, b, c, mem) => {
    if (c === 0 && a === 1) console.log(`Adding ${mem[a]}`)
    mem[c] = mem[a] + mem[b]
  },
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
  const mem = [1, 0, 0, 0, 0, 0]
  const [ip, instructions] = parse(inp)
  while (true) {
    console.log(mem)
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

// console.log(part1(sample))
console.log(part1(input))
