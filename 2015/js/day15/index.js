const assert = require('assert')
const fs = require('fs')

const testInput = fs.readFileSync(`${__dirname}/test-input.txt`, 'utf8')
const input = fs.readFileSync(`${__dirname}/input.txt`, 'utf8')

function part1(inp, totalCalories) {
  const ingredients = parse(inp)
  const totals = { capacity: 0, durability: 0, flavor: 0, texture: 0, calories: 0 }
  return calc(ingredients, totals, 100, totalCalories)
}

const part2 = (inp) => part1(inp, 500)

function calc(ingredients, totals, tspsLeft, totalCalories) {
  const [cur, ...rest] = ingredients
  if (ingredients.length === 1) return getValue(cur, totals, tspsLeft, totalCalories)
  let curMax = 0
  for (let i = 0; i <= tspsLeft; ++i) {
    const newTotals = Object.assign({}, totals)
    for (const key in cur.attrs) {
      newTotals[key] += cur.attrs[key] * i
    }
    const num = calc(rest, newTotals, tspsLeft - i, totalCalories)
    curMax = Math.max(curMax, num)
  }
  return curMax
}

function getValue(ingredient, totals, count, totalCalories) {
  const cals = totals.calories + ingredient.attrs.calories * count
  if (totalCalories && cals > totalCalories) return 0
  let total = 1
  for (const key in ingredient.attrs) {
    if (key === 'calories') continue
    const val = Math.max(0, totals[key] + ingredient.attrs[key] * count)
    total *= val
  }
  return total
}

function parse(inp) {
  return inp.trim().split('\n')
    .map(line => {
      const [name, rest] = line.split(': ')
      const attrs = rest.split(', ')
        .reduce((memo, attr) => {
          const [name, num] = attr.split(' ')
          memo[name] = +num
          return memo
        }, {})
      return { name, attrs }
    })
}

assert.equal(part1(testInput), 62842880)
const ans = part1(input)
console.log(`part1: ${ans}`)
assert.equal(ans, 18965440)

assert.equal(part2(testInput), 57600000)
const ans2 = part2(input)
console.log(`part2: ${ans2}`)
assert.equal(ans2, 15862900)
