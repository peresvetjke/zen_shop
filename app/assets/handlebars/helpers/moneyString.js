module.exports = (money) => {
  if (money == 0) {
    return "0.00"
  }

  if (typeof(money.cents) == "undefined") {
    var sum = money.toString()
  } else {
    var sum = money.cents.toString()
  }

  var splits = [sum.slice(0,sum.length - 2), sum.slice(sum.length-2)];  
  return `${splits[0]}.${splits[1]}`
};