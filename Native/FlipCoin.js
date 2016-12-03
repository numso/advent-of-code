function ElmNativeModule(name, values) {
  Elm.Native[name] = {};
  Elm.Native[name].make = function (elm) {
    elm.Native = elm.Native || {};
    elm.Native[name] = elm.Native[name] || {};
    if (elm.Native[name].values) return elm.Native[name].values;
    return elm.Native[name].values = values;
  };
}

function flipCoin() {
  return Math.random() < 0.5
}

ElmNativeModule('FlipCoin', {flipCoin: flipCoin})
