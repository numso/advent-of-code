const assert = require('assert')
const fs = require('fs')
const _ = require('lodash')

const input = fs.readFileSync(`${__dirname}/24.in`, 'utf8')
const sample = fs.readFileSync(`${__dirname}/24-sample.in`, 'utf8')

function part1 (inp) {
  let teams = parse(inp)
  teams = makeEmFight(teams)
  return _.sumBy(teams, 'units')
}

function makeEmFight (teams) {
  while (true) {
    const oldTeams = _.cloneDeep(teams)
    teams.sort((a, b) => {
      const effectiveA = a.units * a.ap
      const effectiveB = b.units * b.ap
      if (effectiveA !== effectiveB) return effectiveB - effectiveA
      return b.initiative - a.initiative
    })
    teams.forEach(team => {
      team.targeting = null
      team.isTargeted = false
    })
    teams.forEach(team => {
      const choices = _.reject(teams, t => t.isTargeted || t.team === team.team)
      target(team, choices)
    })
    teams.sort((a, b) => b.initiative - a.initiative)
    teams.forEach(fight)
    teams = _.filter(teams, team => team.units > 0)
    if (_.uniqBy(teams, 'team').length === 1) break
    if (_.isEqual(oldTeams, teams)) {
      teams = []
      break
    }
  }
  return teams
}

function target (attacker, defenders) {
  defenders = _.reject(defenders, defender =>
    _.includes(defender.immune, attacker.type)
  )
  defenders.sort((a, b) => {
    let doubleA = _.includes(a.weak, attacker.type) ? 1 : 0
    let doubleB = _.includes(b.weak, attacker.type) ? 1 : 0
    if (doubleA !== doubleB) return doubleB - doubleA
    const effectiveA = a.units * a.ap
    const effectiveB = b.units * b.ap
    if (effectiveA !== effectiveB) return effectiveB - effectiveA
    return b.initiative - a.initiative
  })
  const defender = defenders[0]
  if (!defender) return
  attacker.targeting = defender
  defender.isTargeted = true
}

function fight (attacker) {
  const defender = attacker.targeting
  if (!defender || attacker.units <= 0) return
  let damage = attacker.units * attacker.ap
  if (_.includes(defender.weak, attacker.type)) damage *= 2
  if (_.includes(defender.immune, attacker.type)) damage = 0
  defender.units -= Math.floor(damage / defender.hp)
}

function parse (inp) {
  inp = inp.replace('Immune System:', '')
  const [immune, infection] = inp.split('Infection:')
  return [...parseTeam(immune, 'immune'), ...parseTeam(infection, 'infection')]
}

function parseTeam (inp, team) {
  const groups = inp.trim().split('\n')
  const re = /(\d+) units each with (\d+) hit points \((.*)\) with an attack that does (\d+) (.*) damage at initiative (\d+)/
  return groups.map((group, i) => {
    const [, units, hp, rest, ap, type, initiative] = re.exec(group)
    const parsed = {
      id: i + 1,
      team,
      units: +units,
      hp: +hp,
      ap: +ap,
      type,
      initiative: +initiative
    }
    rest.split('; ').map(str => {
      if (!str) return
      const [, type, types] = /(.*) to (.*)/.exec(str)
      parsed[type] = types.split(', ')
    })
    return parsed
  })
}

function part2 (inp) {
  let templateTeams = parse(inp)
  let answer = -1
  let increase = 24
  while (answer === -1) {
    console.log(increase)
    let teams = _.cloneDeep(templateTeams)
    increase += 1
    _.forEach(teams, team => {
      if (team.team === 'immune') team.ap += increase
    })
    teams = makeEmFight(teams)
    if (teams[0] && teams[0].team === 'immune') {
      answer = _.sumBy(teams, 'units')
    }
  }
  console.log('got one', increase)
  return answer
}

// assert.strictEqual(part1(sample), 5216)
// console.log(part1(input)) // 17738
// assert.strictEqual(part2(sample), 51)
console.log(part2(input)) // ?
