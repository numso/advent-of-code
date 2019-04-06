const assert = require('assert')
const _ = require('lodash')

const input = `
################################
#####G.####...........##########
######G#.##.#.G......###########
######...##G#.........###...####
########.##...G.......###...####
########..##.....G....#.#......#
######...G##G..................#
#######..#########G............#
#######...#########..G.........#
#######..G.#######..........####
######......G..###..EE......####
######..#.G............E#...####
#######.#.....#####........#####
#######G.....#######...#########
#######.....#########.##########
#######.....#########.##########
#######G....#########.##########
######...EG.#########.##########
######..G...#########.##########
#######......#######..##########
########.E....#####...##########
#...###...G.........E.##########
#....#......G....#..############
#.........G...#......###########
#...#.........#......###########
##.......#######.....###########
#.......########......##########
##...E.E########...E...#########
#####....###########.E.#########
######..#############..#########
#######...######################
################################
`

const sample1 = `
#######       #######   
#.G...#       #G....#   G(200)
#...EG#       #.G...#   G(131)
#.#.#G#  -->  #.#.#G#   G(59)
#..G#E#       #...#.#   
#.....#       #....G#   G(200)
#######       #######   
`
const answer1 = 27730

const sample2 = `
#######       #######
#G..#E#       #...#E#   E(200)
#E#E.E#       #E#...#   E(197)
#G.##.#  -->  #.E##.#   E(185)
#...#E#       #E..#E#   E(200), E(200)
#...E.#       #.....#
#######       #######
`
const answer2 = 36334

const sample3 = `
#######       #######   
#E..EG#       #.E.E.#   E(164), E(197)
#.#G.E#       #.#E..#   E(200)
#E.##E#  -->  #E.##.#   E(98)
#G..#.#       #.E.#.#   E(200)
#..E#.#       #...#.#   
#######       #######   
`
const answer3 = 39514

const sample4 = `
#######       #######   
#E.G#.#       #G.G#.#   G(200), G(98)
#.#G..#       #.#G..#   G(200)
#G.#.G#  -->  #..#..#   
#G..#.#       #...#G#   G(95)
#...E.#       #...G.#   G(200)
#######       #######   
`
const answer4 = 27755

const sample5 = `
#######       #######   
#.E...#       #.....#   
#.#..G#       #.#G..#   G(200)
#.###.#  -->  #.###.#   
#E#G#G#       #.#.#.#   
#...#G#       #G.G#G#   G(98), G(38), G(200)
#######       #######   
`
const answer5 = 28944

const sample6 = `
#########       #########   
#G......#       #.G.....#   G(137)
#.E.#...#       #G.G#...#   G(200), G(200)
#..##..G#       #.G##...#   G(200)
#...##..#  -->  #...##..#   
#...#...#       #.G.#...#   G(200)
#.G...G.#       #.......#   
#.....G.#       #.......#   
#########       #########   
`
const answer6 = 18740

function part1 (inp) {
  const [turn, players] = runBattle(inp, 3)
  return turn * _.sumBy(players, 'hp')
}

function runBattle (inp, elfPower) {
  let [players, board] = parse(inp, elfPower)
  let turn = 0
  let gameIsOver = false
  while (true) {
    players.sort((a, b) => (a.y !== b.y ? a.y - b.y : a.x - b.x))
    // console.clear()
    // console.log(turn)
    // print(board, players)
    // let z = 0
    // while (z < 100000000) z++
    _.forEach(players, player => {
      if (player.dead) return
      if (gameOver(players)) {
        gameIsOver = true
        return false
      }
      move(player, players, board)
      attack(player, players)
    })
    players = _.filter(players, { dead: false })
    if (gameIsOver) break
    turn++
  }
  players.sort((a, b) => (a.y !== b.y ? a.y - b.y : a.x - b.x))
  // print(board, players)
  return [turn, players]
}

function gameOver (players) {
  const living = _.filter(players, { dead: false })
  return _.uniqBy(living, 'type').length === 1
}

function move (player, players, board) {
  const living = _.filter(players, { dead: false })
  const enemies = _.reject(living, { type: player.type })
  if (getAdjacent(enemies, player).length) return
  const coords = _.flatMap(enemies, getAdjacentCoords)
  const nearest = getNearest(player, coords, board, living)
  nearest.sort((a, b) => {
    if (a.endY !== b.endY) return a.endY - b.endY
    if (a.endX !== b.endX) return a.endX - b.endX
    if (a.nextY !== b.nextY) return a.nextY - b.nextY
    return a.nextX - b.nextX
  })
  if (!nearest[0]) return
  player.x = nearest[0].nextX
  player.y = nearest[0].nextY
}

function getNearest (player, targets, board, players) {
  const targetsMap = {}
  _.forEach(targets, ([x, y]) => {
    targetsMap[`${x}-${y}`] = true
  })
  const searched = {}
  let nextUp = [{ x: player.x, y: player.y, initial: true }]
  const found = []
  let exhausted = false
  while (!found.length && !exhausted) {
    exhausted = true
    const newNextUp = []
    _.forEach(nextUp, node => {
      const toTravel = getAdjacentCoords(node)
      _.forEach(toTravel, ([x, y]) => {
        const key = `${x}-${y}`
        if (searched[key]) return
        if (board[key] === '#') return
        if (_.find(players, { x, y })) return
        searched[key] = true
        exhausted = false
        const newNode = { x, y, prev: node.initial ? null : node }
        newNextUp.push(newNode)
        if (targetsMap[key]) found.push(newNode)
      })
    })
    nextUp = newNextUp
  }
  return _.map(found, item => {
    let first = item
    while (first.prev) first = first.prev
    return { endX: item.x, endY: item.y, nextX: first.x, nextY: first.y }
  })
}

const getAdjacentCoords = t => [
  [t.x, t.y - 1],
  [t.x - 1, t.y],
  [t.x + 1, t.y],
  [t.x, t.y + 1]
]

const getAdjacent = (enemies, p) => {
  const adjacents = getAdjacentCoords(p)
  return _.filter(
    enemies,
    e => !e.dead && _.find(adjacents, ([x, y]) => x === e.x && y === e.y)
  )
}

function attack (player, players) {
  const enemies = _.reject(players, { type: player.type })
  const adjacentEnemies = getAdjacent(enemies, player)
  adjacentEnemies.sort((a, b) => {
    if (a.hp !== b.hp) return a.hp - b.hp
    if (a.y !== b.y) return a.y - b.y
    return a.x - b.x
  })
  const enemy = adjacentEnemies[0]
  if (!enemy) return
  enemy.hp -= player.ap
  if (enemy.hp <= 0) enemy.dead = true
}

function parse (inp, elfPower) {
  const players = []
  const board = {}
  const lines = inp.trim().split('\n')
  _.forEach(lines, (line, y) => {
    _.forEach(line, (type, x) => {
      if (type === ' ') return false
      board[`${x}-${y}`] = type === '#' ? '#' : '.'
      if (type === 'E' || type === 'G') {
        players.push({
          type,
          ap: type === 'E' ? elfPower : 3,
          hp: 200,
          x,
          y,
          dead: false
        })
      }
    })
  })
  return [players, board]
}

function print (board, players) {
  const newBoard = _.cloneDeep(board)
  _.forEach(players, p => {
    newBoard[`${p.x}-${p.y}`] = p.type
  })
  const coords = Object.keys(newBoard).map(key => {
    const [x, y] = key.split('-')
    return [+x, +y]
  })
  const xs = _.map(coords, a => a[0])
  const ys = _.map(coords, a => a[1])
  const width = Math.max(...xs) + 1
  const height = Math.max(...ys) + 1
  for (let i = 0; i < height; ++i) {
    let line = ''
    for (let j = 0; j < width; ++j) {
      line += newBoard[`${j}-${i}`]
    }
    _.forEach(players, p => {
      if (p.y !== i) return
      line += `  ${p.hp}`
    })
    console.log(line)
  }
  console.log()
}

function part2 (inp) {
  let [players] = parse(inp, 3)
  const numElves = _.filter(players, { type: 'E' }).length
  let power = 3
  let [turn, players2] = runBattle(inp, power)
  let numElves2 = _.filter(players2, { type: 'E' }).length
  while (numElves !== numElves2) {
    power++
    ;[turn, players2] = runBattle(inp, power)
    numElves2 = _.filter(players2, { type: 'E' }).length
  }
  return turn * _.sumBy(players2, 'hp')
}

assert.strictEqual(part1(sample1), answer1, 'sample1')
assert.strictEqual(part1(sample2), answer2, 'sample2')
assert.strictEqual(part1(sample3), answer3, 'sample3')
assert.strictEqual(part1(sample4), answer4, 'sample4')
assert.strictEqual(part1(sample5), answer5, 'sample5')
assert.strictEqual(part1(sample6), answer6, 'sample6')
console.log(part1(input)) // 217890
console.log(part2(input)) // 43645
