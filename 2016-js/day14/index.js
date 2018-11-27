const assert = require('assert')
const md5 = require('md5')

function run(inp, numHashes = 1) {
  let dal = 0
  const dictionary = []
  let maxToFind = Number.POSITIVE_INFINITY
  for (let i = 0; i < maxToFind; ++i) {
    let hash = `${inp}${i}`
    for (let j = 0; j < numHashes; ++j) {
      hash = md5(hash)
    }
    const quintupletChars = getQuintupletChars(hash)
    if (quintupletChars.length) {
      quintupletChars.forEach(char => {
        dictionary.forEach(item => {
          if (item.tripletChar === char && item.i > i - 1000) {
            item.isValid = true
          }
        })
      })
      if (dictionary.filter(item => item.isValid).length >= 64) {
        maxToFind = dictionary.filter(item => item.isValid)[63].i + 1000
      }
    }
    const tripletChar = getTripletChar(hash)
    if (tripletChar !== null) {
      dictionary.push({ i, tripletChar, isValid: false })
    }
  }
  return dictionary.filter(item => item.isValid)[63].i
}

const tripletRegex = /(.)\1\1/
function getTripletChar(str) {
  const matches = str.match(tripletRegex)
  return matches && matches[1]
}

const quintupletRegex = /(.)\1\1\1\1/g
function getQuintupletChars(str) {
  const matches = str.match(quintupletRegex)
  return (matches || []).map(chars => chars[0])
}

assert.equal(run('abc'), 22728)
const ans = run('qzyelonm')
console.log(`part1: ${ans}`)
assert.equal(ans, 15168)

assert.equal(run('abc', 2017), 22551)
const ans2 = run('qzyelonm', 2017)
console.log(`part2: ${ans2}`)
assert.equal(ans2, 20864)
