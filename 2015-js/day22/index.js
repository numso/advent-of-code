const assert = require('assert')

const spells = [
  { name: 'Magic Missile', cost: 53, damage: 4 },
  { name: 'Drain', cost: 73, damage: 2, heal: 2 },
  { name: 'Shield', cost: 113, turns: 6, armor: 7 },
  { name: 'Poison', cost: 173, turns: 6, damage: 3 },
  { name: 'Recharge', cost: 229, turns: 5, mana: 101 },
]

function run(hp, mana, hp2, dmg, isPart2) {
  const fight = getFight(hp, mana, hp2, dmg, isPart2)
  for (let i = 1; i < 10; ++i) {
    const choices = getChoices(i)
    const res = choices.map(fight).filter(val => val !== -1)
    if (res.length) {
      res.sort((a, b) => a - b)
      return res[0]
    }
  }
}

const getFight = (hp, mana, hp2, dmg, isPart2) => (choice) => {
  const gameState = { spells: {} }
  const player = { hp, mana, armor: 0 }
  const boss = { hp: hp2, dmg }

  const tickSpells = () => {
    const spellsInProgress = Object.keys(gameState.spells)
    for (let i = 0; i < spellsInProgress.length; ++i) {
      const which = spellsInProgress[i]
      let turnsLeft = gameState.spells[which]
      const spell = spells[which]
      if (spell.damage) boss.hp -= spell.damage
      if (spell.mana) player.mana += spell.mana
      turnsLeft--
      if (turnsLeft === 0) {
        delete gameState.spells[which]
        if (spell.armor) player.armor = 0
      } else gameState.spells[which] = turnsLeft
    }
  }

  let manaSpent = 0
  for (let i = 0; i < choice.length; ++i) {
    if (isPart2) {
      player.hp--
      if (player.hp <= 0) return -1
    }

    tickSpells()

    // player turn
    const which = choice[i]
    const spell = spells[which]
    if (spell.cost > player.mana) return -1
    if (gameState.spells[which]) return -1
    manaSpent += spell.cost
    player.mana -= spell.cost
    if (spell.armor) player.armor = spell.armor
    if (spell.turns) {
      gameState.spells[which] = spell.turns
    } else {
      if (spell.damage) boss.hp -= spell.damage
      if (spell.heal) player.hp += spell.heal
    }

    tickSpells()

    // boss turn
    player.hp -= Math.max(boss.dmg - player.armor, 1)

    // victory/defeat conditions
    if (boss.hp <= 0) return manaSpent
    if (player.hp <= 0) return -1
  }
  return -1
}

function getChoices(num) {
  let choices = [[0], [1], [2], [3], [4]]
  for (let i = 2; i <= num; ++i) {
    const newChoices = []
    for (let j = 0; j < choices.length; ++j) {
      const curChoice = choices[j]
      for (let k = 0; k < spells.length; ++k) {
        newChoices.push([...curChoice, k])
      }
    }
    choices = newChoices
  }
  return choices
}

assert.equal(run(10, 250, 13, 8), 226)
assert.equal(run(10, 250, 14, 8), 641)
const ans = run(50, 500, 58, 9)
console.log(`part1: ${ans}`)
assert.equal(ans, 1269)

const ans2 = run(50, 500, 58, 9, true)
console.log(`part2: ${ans2}`)
// assert.equal(ans2, 1269)
