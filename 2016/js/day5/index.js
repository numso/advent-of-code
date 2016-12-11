const assert = require('assert')
const md5 = require('md5')

const input = 'reyedfim'

function part1(inp) {
  let ans = ''
  updateDisplaySimple(ans)
  for (let i = 0; ans.length < 8; ++i) {
    const toHash = `${inp}${i}`
    const hashed = md5(toHash)
    if (hashed.startsWith('00000')) {
      ans += hashed[5]
      updateDisplaySimple(ans)
    }
  }
  process.stdout.clearLine()
  process.stdout.cursorTo(0)
  return ans
}

function updateDisplaySimple(ans) {
  const newStr = ans + [...Array(8 - ans.length)].map(() => '_').join('')
  process.stdout.clearLine()
  process.stdout.cursorTo(0)
  process.stdout.write(newStr)
}


function part2(inp) {
  let ans = []
  for (let i = 0; ans.join('').length < 8; ++i) {
    const toHash = `${inp}${i}`
    const hashed = md5(toHash)
    if (hashed.startsWith('00000')) {
      const pos = +hashed[5]
      if (pos >= 0 && pos <= 7 && ans[pos] === undefined) {
        ans[pos] = hashed[6]
      }
    }
    if (i % 10000 === 0) updateDisplay(ans)
  }
  process.stdout.clearLine()
  process.stdout.cursorTo(0)
  return ans.join('')
}

function updateDisplay(ans) {
  let newStr = ''
  for (let i = 0; i < 8; ++i) {
    newStr += ans[i] === undefined ? randomChar() : ans[i]
  }
  process.stdout.clearLine()
  process.stdout.cursorTo(0)
  process.stdout.write(newStr)
}

function randomChar() {
  return String.fromCharCode(65 + Math.floor(Math.random() * 57))
}

assert.equal(part1('abc'), '18f47a30')
const ans = part1(input)
console.log(`part1: ${ans}`)
assert.equal(ans, 'f97c354d')

assert.equal(part2('abc'), '05ace8e3')
const ans2 = part2(input)
console.log(`part2: ${ans2}`)
assert.equal(ans2, '863dde27')
