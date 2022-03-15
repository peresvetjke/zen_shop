import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
                    "itemSum", "totalSum", "deliveryTypeSelect", 
                    "deliveryInfo", "deliveryCostInfo", "deliveryPlannedDateInfo",
                    "deliveryCost", "deliveryPlannedDate",
                   ]

  connect() {
    let self = this

    $("#address").suggestions({
      token: "8eef865634dc4c1d346ba618ae7fca0e2cc1e837",
      type: "ADDRESS",
      /* Вызывается, когда пользователь выбирает одну из подсказок */
      onSelect: function(suggestion) {
        console.log('selected!')
        if (typeof(suggestion.data['postal_code']) != "undefined") {
          self.fillAddress(suggestion)
          self.retrieveDeliveryInfo()
        }
      }
    });  
  }

  fillAddress(suggestion) {
    const addressFields = ["country", "postal_code", "region_with_type", "city_with_type", "street_with_type", "house", "flat"]

    for (var i = 0; i < addressFields.length; i++) {
      var suggestionValue = suggestion.data[addressFields[i]]
      if (typeof(suggestionValue) == "undefined") { suggestionValue = "" }
      $(`input[name='order[address_attributes][${addressFields[i]}]']`)[0].value = suggestionValue
    }
  }

  retrieveDeliveryInfo() {
    let self = this

    const OBJECT = 27020 // Посылка (частное лицо или предприятие) -- Посылка стандарт с объявленной ценностью 
    const PACK = 20      // коробка M
    const FROM = 141206  // postal code of our plant
    const tariffEndPoint = "https://tariff.pochta.ru/v1/calculate/tariff?json&"
    const plannedDateEndPoint = "https://tariff.pochta.ru/v1/calculate/delivery?json&"
    var to     = $("input[name='order[address_attributes][postal_code]']")[0].value
    // var sum    = this.totalSumTarget.textContent
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
      self.deliveryCostTarget.textContent = costRub
    });

    // retrieve planned date
    $.ajax({
      url: plannedDateEndPoint + query
    }).done(function(data) {
      var plannedDate = self.parseDate(data.delivery.deadline)
      self.deliveryPlannedDateTarget.textContent = plannedDate
    });
  }


  updateDeliveryType() {
    if (this.deliveryTypeSelectTarget.value != "Russian Post") {
      $(this.deliveryInfoTarget).hide()
    } else {
      $(this.deliveryInfoTarget).show()
    }
  }

  updateTotalSum() {this.sleep(1000).then(() => {
      if (this.itemSumTargets.length == 0) { Turbo.visit('/cart') }
    })
  }

  parseDate(date) {
    var year = date.substring(0,4)
    var month = date.substring(4,6)
    var day = date.substring(6,8)

    return `${day}-${month}-${year}`
  }

  // calculateTotalSum() {
  //   return this.itemSumTargets.reduce((n, {textContent}) => n + parseInt(textContent), 0)
  // }

  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
