Array.prototype.uniq = function () {
  const dict = {}
  return this.filter(letter => {
    if (dict[letter]) return false
    dict[letter] = true
    return true
  })
}

Array.prototype.flatten = function () {
  return this.reduce((memo, arr) => memo.concat(arr), [])
}

Array.prototype.count = function (letter) {
  return this.filter(l => l === letter).length
}

Array.prototype.sum = function (key) {
  return this.reduce((memo, item) => memo + (key ? item[key] : item), 0)
}

Array.prototype.any = function (fn) {
  return this.filter(fn).length > 0
}
