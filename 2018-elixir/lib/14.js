function part1(inp) {
  let i = 2
  const current = [3, 7]
  let a = 0
  let b = 1
  while (i < inp + 10) {
    const next = current[a] + current[b]
    const digits = ('' + next).split('').map(a => +a)
    current.push(...digits)
    i += digits.length
    a = (a + current[a] + 1) % current.length
    b = (b + current[b] + 1) % current.length
  }
  const nums = current.slice(current.length + inp - i)
  nums.length = 10
  return nums.join('')
}

// console.log(part1(9))
// console.log(part1(5))
// console.log(part1(18))
// console.log(part1(2018))

// console.log(part1(793061)) // 4138145721

function part2(inp) {
  let cursor = 0
  const current = [3, 7]
  let a = 0
  let b = 1
  while (true) {
    const next = current[a] + current[b]
    const digits = ('' + next).split('').map(a => +a)
    current.push(...digits)
    a = (a + current[a] + 1) % current.length
    b = (b + current[b] + 1) % current.length
    while (cursor + inp.length < current.length) {
      const str = current.slice(cursor, cursor + inp.length).join('')
      if (str === inp) return cursor
      cursor++
    }
  }
}

console.log(part2('51589')) // 9
console.log(part2('01245')) // 5
console.log(part2('92510')) // 18
console.log(part2('59414')) // 2018
console.log(part2('793061')) // ?
