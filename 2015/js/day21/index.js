const assert = require('assert')

const weapons = [
  { cost: 8, damage: 4, armor: 0 },
  { cost: 10, damage: 5, armor: 0 },
  { cost: 25, damage: 6, armor: 0 },
  { cost: 40, damage: 7, armor: 0 },
  { cost: 74, damage: 8, armor: 0 },
]

const armors = [
  { cost: 13, damage: 0, armor: 1 },
  { cost: 31, damage: 0, armor: 2 },
  { cost: 53, damage: 0, armor: 3 },
  { cost: 75, damage: 0, armor: 4 },
  { cost: 102, damage: 0, armor: 5 },
]

const rings = [
  { cost: 25, damage: 1, armor: 0 },
  { cost: 50, damage: 2, armor: 0 },
  { cost: 100, damage: 3, armor: 0 },
  { cost: 20, damage: 0, armor: 1 },
  { cost: 40, damage: 0, armor: 2 },
  { cost: 80, damage: 0, armor: 3 },
]

function run(inp, shouldWin = true, sortModifier = 1) {
  const choices = generateChoices()
  choices.sort((a, b) => sortModifier * (a.cost - b.cost))
  for (let i = 0; i < choices.length; ++i) {
    const { damage, armor, cost } = choices[i]
    const playerWins = fight({ hp: 100, dmg: damage, def: armor }, { hp: 100, dmg: 8, def: 2 })
    if (playerWins === shouldWin) return cost
  }
}

const part1 = run

const part2 = (inp) => run(inp, false, -1)

function generateChoices() {
  const choices = []
  weapons.forEach(weapon => {
    for (let i = 0; i <= armors.length; ++i) {
      const armor = armors[i] || {}
      for (let j = 0; j <= rings.length; ++j) {
        const ring1 = rings[j] || {}
        for (let k = j + 1; k <= rings.length; ++k) {
          const ring2 = rings[k] || {}
          choices.push({
            cost: weapon.cost + (armor.cost || 0) + (ring1.cost || 0) + (ring2.cost || 0),
            damage: weapon.damage + (armor.damage || 0) + (ring1.damage || 0) + (ring2.damage || 0),
            armor: weapon.armor + (armor.armor || 0) + (ring1.armor || 0) + (ring2.armor || 0),
          })
        }
      }
    }
  })
  return choices
}

function fight(player, boss) {
  while (true) {
    boss.hp -= Math.max(player.dmg - boss.def, 1)
    player.hp -= Math.max(boss.dmg - player.def, 1)
    if (boss.hp <= 0) return true
    if (player.hp <= 0) return false
  }
}

assert.equal(fight({ hp: 8, dmg: 5, def: 5 }, { hp: 12, dmg: 7, def: 2 }), true)
const ans = part1()
console.log(`part1: ${ans}`)
assert.equal(ans, 91)

const ans2 = part2()
console.log(`part2: ${ans2}`)
assert.equal(ans2, 158)
