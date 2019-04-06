const assert = require('assert')
const fs = require('fs')
const _ = require('lodash')

const input = fs.readFileSync(`${__dirname}/23.in`, 'utf8')
const sample = `
pos=<0,0,0>, r=4
pos=<1,0,0>, r=1
pos=<4,0,0>, r=3
pos=<0,2,0>, r=1
pos=<0,5,0>, r=3
pos=<0,0,3>, r=1
pos=<1,1,1>, r=1
pos=<1,1,2>, r=1
pos=<1,3,1>, r=1
`
const sample2 = `
pos=<10,12,12>, r=2
pos=<12,14,12>, r=2
pos=<16,12,12>, r=4
pos=<14,14,14>, r=6
pos=<50,50,50>, r=200
pos=<10,10,10>, r=5
`

function part1 (inp) {
  const nanobots = parse(inp)
  nanobots.sort((a, b) => b.r - a.r)
  const biggest = nanobots[0]
  return _.sumBy(nanobots, bot => (withinRange(biggest, bot) ? 1 : 0))
}

function withinRange (target, bot) {
  const x = Math.abs(bot.x - target.x)
  const y = Math.abs(bot.y - target.y)
  const z = Math.abs(bot.z - target.z)
  return x + y + z <= target.r
}

function parse (str) {
  const bots = str.trim().split('\n')
  const re = /pos=<(.*),(.*),(.*)>, r=(.*)/
  return bots.map(bot => {
    const [, x, y, z, r] = re.exec(bot)
    return { x: +x, y: +y, z: +z, r: +r }
  })
}

function part2 (inp) {
  const nanobots = parse(inp)

  const [trialX, trialY, trialZ] = [56997758, 46459806, 57980072]

  const NN = 10000000
  const minX = trialX - NN
  const maxX = trialX + NN
  const minY = trialY - NN
  const maxY = trialY + NN
  const minZ = trialZ - NN
  const maxZ = trialZ + NN
  // const minX = Math.min(...xs)
  // const maxX = Math.max(...xs)
  // const minY = Math.min(...ys)
  // const maxY = Math.max(...ys)
  // const minZ = Math.min(...zs)
  // const maxZ = Math.max(...zs)
  let most = 910
  let smallest = Number.MAX_SAFE_INTEGER
  let smallestDetails = null
  const GRANULARITY = 100000
  for (let x = minX; x <= maxX; x += GRANULARITY) {
    for (let y = minY; y <= maxY; y += GRANULARITY) {
      for (let z = minZ; z <= maxZ; z += GRANULARITY) {
        const num = _.sumBy(nanobots, bot =>
          withinRange(bot, { x, y, z }) ? 1 : 0
        )
        if (num >= 911) {
          const next = x + y + z
          if (next < smallest) {
            smallest = next
            smallestDetails = [x, y, z]
          }
          console.log(`${x},${y},${z} = ${x + y + z}`)
        }
        if (num > most) {
          most = num
          console.log(`MOST --> ${most}`)
        }
      }
    }
  }
  console.log(most)
  console.log(smallest)
  console.log(smallestDetails)
  // iterate by 10000
  // find largest
  // find coords which are in range of most nanobots
  return 36
}

// function part2(inp) {
//   const nanobots = parse(inp)
//   const touching = []

//   _.forEach(nanobots, (bot1, i) => {
//     let count = 0
//     _.forEach(nanobots, (bot2, j) => {
//       if (i === j) return
//       if (isTouching(bot1, bot2)) count++
//     })
//     touching.push(count)
//   })
//   touching.sort((a, b) => b - a)
//   console.log(touching)
//   return 36
// }

// function part2 (inp) {
//   const nanobots = parse(inp)
//   let most = 0
//   for (let i = 0; i < nanobots.length; ++i) {
//     const bot = nanobots[i]
//     let [minX, maxX] = [bot.x - bot.r, bot.x + bot.r]
//     let [minY, maxY] = [bot.y - bot.r, bot.y + bot.r]
//     let [minZ, maxZ] = [bot.z - bot.r, bot.z + bot.r]
//     for (let x = minX; x <= maxX; x += 10000000) {
//       for (let y = minY; y <= maxY; y += 10000000) {
//         for (let z = minZ; z <= maxZ; z += 10000000) {
//           if (!withinRange(bot, { x, y, z })) continue
//           const num = _.sumBy(nanobots, bot =>
//             withinRange(bot, { x, y, z }) ? 1 : 0
//           )
//           if (num === 907) {
//             console.log(`${x},${y},${z} = ${x + y + z}`)
//           }
//           if (num > most) {
//             most = num
//             // console.log(most)
//           }
//         }
//       }
//     }
//   }
//   console.log(most)
// }

function isTouching (bot1, bot2) {
  const x = Math.abs(bot1.x - bot2.x)
  const y = Math.abs(bot1.y - bot2.y)
  const z = Math.abs(bot1.z - bot2.z)
  return x + y + z < bot1.r + bot2.r
}

// assert.strictEqual(part1(sample), 7)
// console.log(part1(input)) // 652
// assert.strictEqual(part2(sample), 36)
console.log(part2(input)) // 158534486 is too low
// 162437636 is too low (910)
// 990 is the most touching circle
