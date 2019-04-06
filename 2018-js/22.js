const assert = require('assert')
const _ = require('lodash')

function part1 (x, y, depth) {
  const map = {}
  let sum = 0
  for (let i = 0; i <= x; ++i) {
    for (let j = 0; j <= y; ++j) {
      sum += getErosionLevel(i, j, x, y, depth, map) % 3
    }
  }
  return sum
}

function generateBaseline (x2, y2, depth, map, cache) {
  let baselineMins = 0
  let type = 'torch'
  for (let j = 0; j <= y2; ++j) {
    baselineMins++
    const cellType = getErosionLevel(0, j, x2, y2, depth, map) % 3
    if (!isCompatible(cellType, type)) {
      baselineMins += 7
      type = isCompatible(cellType, 'torch')
        ? 'torch'
        : isCompatible(cellType, 'gear')
          ? 'gear'
          : 'none'
    }
  }
  for (let i = 0; i <= x2; ++i) {
    baselineMins++
    const cellType = getErosionLevel(i, y2, x2, y2, depth, map) % 3
    if (!isCompatible(cellType, type)) {
      baselineMins += 7
      type = isCompatible(cellType, 'torch')
        ? 'torch'
        : isCompatible(cellType, 'gear')
          ? 'gear'
          : 'none'
    }
  }
  return type === 'torch' ? baselineMins : baselineMins + 7
}

function part2 (x2, y2, depth) {
  const map = {}
  let cache = {}
  let fastest = generateBaseline(x2, y2, depth, map, cache)
  // console.log(fastest)
  let pathways = [[0, 0, 'torch', 0]]
  let zzz = 0
  while (pathways.length) {
    if (++zzz % 100000 === 0) console.log({ length: pathways.length })
    const [x, y, type, time] = pathways.shift()
    // console.log(x, y, type, time)
    if (x === x2 && y === y2) {
      const total = time + (type === 'torch' ? 0 : 7)
      if (total < fastest) {
        fastest = total
        console.log('NEXT ', fastest)
      }
      continue
    }
    if (x > 30) continue
    const distance = x2 - x + y2 - y
    if (time + 1 + distance >= fastest) continue
    const allDirections = [
      [x, y + 1, 'torch'],
      [x, y + 1, 'gear'],
      [x, y + 1, 'none'],
      [x + 1, y, 'torch'],
      [x + 1, y, 'gear'],
      [x + 1, y, 'none'],
      [x - 1, y, 'torch'],
      [x - 1, y, 'gear'],
      [x - 1, y, 'none'],
      [x, y - 1, 'torch'],
      [x, y - 1, 'gear'],
      [x, y - 1, 'none']
    ]
    const valid = _.filter(allDirections, ([x, y, type]) => {
      if (x < 0 || y < 0) return false
      const cellType = getErosionLevel(x, y, x2, y2, depth, map) % 3
      if (!isCompatible(cellType, type)) return
      return true
    })

    _.forEach(valid, ([x0, y0, type0]) => {
      let numMinutes = time + 1 + (type0 === type ? 0 : 7)
      if (numMinutes >= fastest) return
      const cellType = getErosionLevel(x0, y0, x2, y2, depth, map) % 3
      if (!isCompatible(cellType, type0)) return
      const cacheKey = `${x0}-${y0}-${type0}`
      if (cacheKey in cache && numMinutes >= cache[cacheKey]) return
      cache[cacheKey] = numMinutes
      pathways.push([x0, y0, type0, numMinutes])
    })
  }
  return fastest
}

function isCompatible (cellType, type) {
  if (cellType === 0) return type === 'gear' || type === 'torch'
  if (cellType === 1) return type === 'gear' || type === 'none'
  return type === 'torch' || type === 'none'
}

// start with torch, end with torch
// 0 rocky - climbing gear | torch
// 1 wet - climbing gear | none
// 2 narrow - torch | none
// 1 min travel time + 7 min switch time

function getErosionLevel (x, y, x2, y2, depth, map) {
  const key = `${x}-${y}`
  if (!(key in map)) {
    const geoIndex = getGeologicalIndex(x, y, x2, y2, depth, map)
    map[`${x}-${y}`] = (geoIndex + depth) % 20183
  }
  return map[key]
}

function getGeologicalIndex (x, y, x2, y2, depth, map) {
  const key = `${x}-${y}`
  if (!(key in map)) {
    map[key] = getGeoIndexInner(x, y, x2, y2, depth, map)
  }
  return map[key]
}

function getGeoIndexInner (x, y, x2, y2, depth, map) {
  if (x === 0 && y === 0) return 0
  if (x === x2 && y === y2) return 0
  if (y === 0) return x * 16807
  if (x === 0) return y * 48271
  return (
    getErosionLevel(x - 1, y, x2, y2, depth, map) *
    getErosionLevel(x, y - 1, x2, y2, depth, map)
  )
}

console.log(part1(10, 10, 510)) // 114
console.log(part1(6, 797, 11991)) // 5622

console.log(part2(10, 10, 510)) // 45
console.log(part2(6, 797, 11991)) // ?
