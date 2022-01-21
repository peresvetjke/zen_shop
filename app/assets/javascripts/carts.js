function ready() {
  var linksNumberAjax  = $('a.btn-number-ajax')
  var linksRemoveItems = $('a.remove_item')

  if (linksRemoveItems) {
    for (var i = 0; i < linksRemoveItems.length; i++) {
      $(linksRemoveItems[i]).parent().on('ajax:success', function(e) {
        var itemId   = e.originalEvent.detail[0].cart_item.id
        var totalSum = moneyString(e.originalEvent.detail[0].cart_item.cart.total_sum)
        var row      = $(`tr[data-item-id=${itemId}]`)

        var totalSumField = $("#total_sum")[0]

        row.remove()
        totalSumField.textContent = totalSum

      }) .on('ajax:error', function(e) {
        var message = e.originalEvent.detail[0]
        alert(message)
      })
    }
  }

  if (linksNumberAjax) {
    for (var i = 0; i < linksNumberAjax.length; i++) {
      $(linksNumberAjax[i]).parent().on('ajax:success', function(e) {
        console.log(e.originalEvent.detail[0])
        var itemId      = e.originalEvent.detail[0].cart_item.id
        var amount      = e.originalEvent.detail[0].cart_item.amount
        var price       = e.originalEvent.detail[0].cart_item.price.cents
        var totalSum    = moneyString(e.originalEvent.detail[0].cart_item.cart.total_sum)
        var totalWeight = e.originalEvent.detail[0].cart_item.cart.total_weight

        var amountField      = $(`input[data-item-id='${itemId}']`)[0]
        var sumField         = $(`tr[data-item-id='${itemId}'] td.sum`)[0]
        var totalSumField    = $("#total_sum")[0]
        var totalWeightField = $("#total_weight")[0]

        amountField.value            = amount
        sumField.textContent         = moneyString(amount * price)
        totalSumField.textContent    = totalSum
        totalWeightField.textContent = totalWeight

      }) .on('ajax:error', function(e) {
        var message = e.originalEvent.detail[0].message
        alert(message)
      })
    }
  }
}

function moneyString(money) {
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
}

document.addEventListener('turbolinks:load', ready)