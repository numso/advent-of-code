const assert = require('assert')

const input = [
  { positions: 17, start: 15 },
  { positions: 3, start: 2 },
  { positions: 19, start: 4 },
  { positions: 13, start: 2 },
  { positions: 7, start: 2 },
  { positions: 5, start: 0 },
]

function run(inp) {
  for (let i = 0;; ++i) {
    let willWork = true
    for (let j = 0; j < inp.length; ++j) {
      const cur = inp[j]
      const position = (cur.start + i + j + 1) % cur.positions
      if (position) {
        willWork = false
        break
      }
    }
    if (willWork) return i
  }
}

assert.equal(run([{ positions: 5, start: 4 }, { positions: 2, start: 1 }]), 5)
const ans = run(input)
console.log(`part1: ${ans}`)
assert.equal(ans, 400589)

const ans2 = run([...input, { positions: 11, start: 0 }])
console.log(`part2: ${ans2}`)
assert.equal(ans2, 3045959)
