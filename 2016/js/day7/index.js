const assert = require('assert')
const fs = require('fs')

const testInput = fs.readFileSync(`${__dirname}/test-input.txt`, 'utf8')
const testInput2 = fs.readFileSync(`${__dirname}/test-input2.txt`, 'utf8')
const input = fs.readFileSync(`${__dirname}/input.txt`, 'utf8')
require('../mini-lodash')

const hypernetRegex = /\[.*?\]/g

function part1(inp) {
  const ips = inp.trim().split('\n')
  return ips.map(parse).filter(supportsTls).length
}

function part2(inp) {
  const ips = inp.trim().split('\n')
  return ips.map(parse).filter(supportsSsl).length
}

function parse(ip) {
  const hypernets = ip.match(hypernetRegex)
  const supernets = hypernets.reduce((memo, chunk) => memo.replace(chunk, ' '), ip).split(' ')
  return { hypernets, supernets }
}

function supportsTls({ hypernets, supernets }) {
  return !hypernets.filter(isAbba).length && supernets.filter(isAbba).length
}

function isAbba(str) {
  for (let i = 0; i < str.length - 3; ++i) {
    const [a, b, b2, a2] = str.slice(i, i + 4)
    if (a === a2 && b === b2 && a !== b) return true
  }
  return false
}

function supportsSsl({ hypernets, supernets }) {
  const abas = hypernets.map(findAbas).flatten().uniq()
  const babs = abas.map(generateBab)
  return supernets.any(sn => containsBabs(sn, babs))
}

function findAbas(str) {
  const abas = []
  for (let i = 0; i < str.length - 2; ++i) {
    const [a, b, a2] = str.slice(i, i + 3)
    if (a === a2 && a !== b) {
      abas.push([a, b, a2].join(''))
    }
  }
  return abas.uniq()
}

function generateBab(aba) {
  const [a, b] = aba
  return [b, a, b].join('')
}

function containsBabs(sn, babs) {
  return babs.any(bab => sn.includes(bab))
}

assert.equal(part1(testInput), 2)
console.log(`part1: ${part1(input)}`)
assert.equal(part1(input), 105)

assert.equal(part2(testInput2), 3)
console.log(`part2: ${part2(input)}`)
assert.equal(part2(input), 258)
