function ready() {
  var deliveryType = $("#order_delivery_attributes_delivery_type")

  if (deliveryType) {
    const addressFields = ["country", "postal_code", "region_with_type", "city_with_type", "street_with_type", "house", "flat"]
    var deliveryInfo = $(".delivery_info")
    deliveryInfo.hide()
    var dadataInput = $("#address")
    var deliveryAddress = $("#delivery_address")

    $(deliveryType).on('change', function() {
      // switch (deliveryType[0].value) {
      //   case "Self-pickup":
      //     deliveryInfo.hide()
      //     break;
      //   case "Russian Post":
      //     deliveryInfo.show()
      //     break;
      // }
    })

    dadataInput.suggestions({
      token: "8eef865634dc4c1d346ba618ae7fca0e2cc1e837",
      type: "ADDRESS",
      /* Вызывается, когда пользователь выбирает одну из подсказок */
      onSelect: function(suggestion) {
        if (typeof(suggestion.data['postal_code']) != "undefined") {
          fillAddress(suggestion, addressFields, deliveryAddress)
          retrieveDeliveryInfo()
        }
      }
    });
  }
}

function fillAddress(suggestion, addressFields, deliveryAddress) {
  for (var i = 0; i < addressFields.length; i++) {
    var suggestionValue = suggestion.data[addressFields[i]]
    if (typeof(suggestionValue) == "undefined") { suggestionValue = "" }
    addHiddenField(deliveryAddress, addressFields[i], suggestionValue)
  }
}

// https://tariff.pochta.ru/post-calculator-api.pdf
function retrieveDeliveryInfo() {
  const OBJECT = 27020 // Посылка (частное лицо или предприятие) -- Посылка стандарт с объявленной ценностью 
  const PACK = 20      // коробка M
  const FROM = 141206  // postal code of our plant
  const tariffEndPoint = "https://tariff.pochta.ru/v1/calculate/tariff?json&"
  const plannedDateEndPoint = "https://tariff.pochta.ru/v1/calculate/delivery?json&"
  var to     = $("input[name='order[address_attributes][postal_code]']")[0].value
  var sum    = $("#total_sum")[0].textContent
  var sumoc  = parseInt(sum) * 100
  var weight = $("#total_weight")[0].textContent

  var query = $.param({ from: FROM, to: to, weight: weight, sumoc: sumoc, object: OBJECT, pack: PACK })
  var url = tariffEndPoint + query
  console.log(url)

  // retrieve cost
  $.ajax({
    url: tariffEndPoint + query
  }).done(function(data) {
    var costRub = data.paynds / 100
    displayDeliveryCost(costRub)
  });

  // retrieve planned date
  $.ajax({
    url: plannedDateEndPoint + query
  }).done(function(data) {
    console.log(data)
    var plannedDate = parseDate(data.delivery.deadline)
    displayDeliveryPlannedDate(plannedDate)
  });
}

function displayDeliveryPlannedDate(date) {
  var plannedDate = $("#delivery_planned_date")
  var content = `<p><strong>Deadline:</strong> ${date}</p>`

  plannedDate.empty()
  $(plannedDate).append(content)
}

function displayDeliveryCost(costRub) {
  var deliveryCost = $("#delivery_cost")
  var content = `<p><strong>Delivery cost:</strong> ${costRub} RUB</p>`

  deliveryCost.empty()
  $(deliveryCost).append(content)
}

function parseDate(date) {
  var year = date.substring(0,4)
  var month = date.substring(4,6)
  var day = date.substring(6,8)

  return `${day}-${month}-${year}`
}

function addHiddenField(deliveryAddress, fieldName, fieldValue) {
  const hiddenField = document.createElement('input')
  hiddenField.setAttribute("type", "hidden");
  hiddenField.setAttribute("value", fieldValue);
  hiddenField.name = `order[address_attributes][${fieldName}]`
  deliveryAddress[0].appendChild(hiddenField)
}

document.addEventListener('turbolinks:load', ready)