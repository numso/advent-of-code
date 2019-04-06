// let answer = 0
let cache = {}

let f = 0
while (true) {
  let e = f | 65536
  f = 15466939
  while (true) {
    f += e & 255
    f = f & 16777215
    f *= 65899
    f = f & 16777215
    if (e < 256) break
    e = Math.floor(e / 256)
  }
  if (cache[f]) {
    process.exit()
    // 12963935
    console.log('DUPE')
  } else {
    console.log(f)
    cache[f] = true
  }
  // if (f === answer) process.exit(1)
}

// OLD /////////////////////////////////////
// OLD /////////////////////////////////////
// OLD /////////////////////////////////////

// let answer = 0

// let f = 123
// do {
//   f = f & 456
// } while (f !== 72)
// f = 0
// while (true) {
//   let e = f | 65536
//   f = 15466939
//   f += e & 255 // LABEL 8
//   f = f & 16777215
//   f *= 65899
//   f = f & 16777215

//   if (e >= 256) {
//     let d = 0
//     while (true) {
//       let b = (d + 1) * 256
//       if (b > e) {
//         e = d
//         break
//       }
//       d++
//     }
//     JUMP(8)
//   }
//   if (f === answer) process.exit(1)
// }
