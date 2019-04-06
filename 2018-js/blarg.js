const PART2 = false
let points = 0
let a = 1
let total = 876
if (PART2) total = 10551276
while (true) {
  let b = 1
  while (true) {
    let c = a * b
    if (c === total) points += a
    b++
    if (b > total) break
  }
  a++
  if (a > total) break
}
console.log(points) // 2072

let sum = 0
for (let i = 1; i <= 10551276; ++i) {
  if (10551276 % i === 0) sum += i
}
console.log(sum)
