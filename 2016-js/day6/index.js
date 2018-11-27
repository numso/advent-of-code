const assert = require('assert')
const fs = require('fs')

const testInput = fs.readFileSync(`${__dirname}/test-input.txt`, 'utf8')
const input = fs.readFileSync(`${__dirname}/input.txt`, 'utf8')
require('../mini-lodash')

const part1 = (inp) => runner(inp)
const part2 = (inp) => runner(inp, true)

function runner(inp, reverse) {
  const parsed = inp.trim().split('\n').reduce((memo, word) => (
    word.split('').reduce((memo2, char, i) => {
      if (!memo2[i]) memo2[i] = ''
      memo2[i] += char
      return memo2
    }, memo)
  ), [])
  return parsed.map(str => findMostCommon(str, reverse)).join('')
}

function findMostCommon(str, reverse) {
  const allLetters = str.split('')
  const sorted = allLetters.uniq().sort(frequencySort(allLetters))
  return reverse ? sorted.reverse()[0] : sorted[0]
}

const frequencySort = (allLetters) => (a, b) => {
  const countA = allLetters.count(a)
  const countB = allLetters.count(b)
  if (countA !== countB) return countB - countA
  return a > b ? 1 : -1
}

assert.equal(part1(testInput), 'easter')
console.log(`part1: ${part1(input)}`)
assert.equal(part1(input), 'kjxfwkdh')

assert.equal(part2(testInput), 'advent')
console.log(`part2: ${part2(input)}`)
assert.equal(part2(input), 'xrwcsnps')
