import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
                    "addressInput", "previousAddress", "previousAddressText", "defaultAddress", "defaultAddressText", 
                    "displayAddressInputButton",
                    "deliveryTypeSelect", "deliveryInfo", "deliveryCostInfo", 
                    "deliveryPlannedDateInfo", "deliveryCost", "deliveryPlannedDate",
                    "addressFields", "cartItem",
                    "totalWeight", "totalPrice", "total"
                   ]

  static values = { previousCountry: String, previousPostal: String, previousRegion: String, previousCity: String, previousStreet: String, previousHouse: String, previousFlat: String,
                    defaultCountry: String, defaultPostal: String, defaultRegion: String, defaultCity: String, defaultStreet: String, defaultHouse: String, defaultFlat: String,
                    previousAddressIsPresent: Boolean, defaultAddressIsPresent: Boolean,
                    totalWeight: Number, totalPrice: Number, deliveryCost: Number, total: Number }

  connect() {
    if (this.previousAddressIsPresentValue) { this.presentPreviousAddress() }
    if (this.defaultAddressIsPresentValue)  { this.presentDefaultAddress() }

    this.hideAllDeliveryInfo()
    this.updateTotals()

    let self = this

    $("#address").suggestions({
      token: "8eef865634dc4c1d346ba618ae7fca0e2cc1e837",
      type: "ADDRESS",
      /* Вызывается, когда пользователь выбирает одну из подсказок */
      onSelect: function(suggestion) {
        if (typeof(suggestion.data['postal_code']) != "undefined") {
          self.fillAddress(suggestion)
          self.retrieveDeliveryInfo()
          self.showAddressSearch(false)
          self.showDeliveryCostInfo(true) 
        }
      }
    });
  }

  cartItemChanged() {
    this.updateTotals()
  }

  cartItemDeleted() {
    this.updateTotals()
  }

  updateTotals() {
    $("#total_loading").removeClass("hide")
    $("#total_sum").addClass("hide")
    this.sleep(500).then(() => {
      this.updateTotalPrice()
      this.updateTotalWeight()
      this.updateTotal()

      $("#total_loading").addClass("hide")
      $("#total_sum").removeClass("hide")
    })
  }

  updateDeliveryCost() {
    console.log('updateDeliveryCost')
    console.log('(this.deliveryCostValue / 100).toFixed(2) = ' + (this.deliveryCostValue / 100).toFixed(2))
    this.deliveryCostTarget.textContent = (this.deliveryCostValue / 100).toFixed(2)
  }

  updateTotalPrice() {
    this.totalPriceTarget.textContent = (this.totalPrice() / 100).toFixed(2)
  }

  totalPrice() {
    this.totalPriceValue = 100 * this.cartItemTargets
      .map(el => {
        let price = el.dataset.cartitemsPriceValue
        let amount = el.dataset.cartitemsAmountValue
        return parseInt(price * amount)
      })
      .reduce((sum, x) => sum + x)

    return this.totalPriceValue
  }

  updateTotalWeight() {
    this.totalWeightTarget.textContent = this.totalWeight()
  }

  updateTotal() {
    this.totalTarget.textContent = (this.total()).toFixed(2)
  }

  total() {
    return this.deliveryCostValue / 100 + this.totalPriceValue / 100
  }

  totalWeight() {
    this.totalWeightValue = this.cartItemTargets
      .map(el => {
            let weight = el.dataset.cartitemsWeightValue
            let amount = el.dataset.cartitemsAmountValue
            return parseInt(weight * amount)
          })
      .reduce((sum, x) => sum + x)

    return this.totalWeightValue
  }

  updateCart() {
    // console.log(this.itemSumTargets.length)
    this.sleep(500).then(() => {
      if (this.itemSumTargets.length == 0) { Turbo.visit('/cart') }
    })
  }

  fillAddress(suggestion) {
    const addressFields = ["country", "postal_code", "region_with_type", "city_with_type", "street_with_type", "house", "flat"]

    for (var i = 0; i < addressFields.length; i++) {
      var suggestionValue = suggestion.data[addressFields[i]]
      if (typeof(suggestionValue) == "undefined") { suggestionValue = "" }
      $(`input[name='order[address_attributes][${addressFields[i]}]']`)[0].value = suggestionValue
    }
  }

  // on "Choose previous" click ;
  copyPreviousAddress() {
    $(`input[name='order[address_attributes][country]']`)[0].value = this.previousCountryValue
    $(`input[name='order[address_attributes][postal_code]']`)[0].value = this.previousPostalValue
    $(`input[name='order[address_attributes][region_with_type]']`)[0].value = this.previousRegionValue
    $(`input[name='order[address_attributes][city_with_type]']`)[0].value = this.previousCityValue
    $(`input[name='order[address_attributes][street_with_type]']`)[0].value = this.previousStreetValue
    $(`input[name='order[address_attributes][house]']`)[0].value = this.previousHouseValue
    $(`input[name='order[address_attributes][flat]']`)[0].value = this.previousFlatValue

    this.retrieveDeliveryInfo()
    this.showDeliveryCostInfo(true)
  }

  // on "Choose default" click ;
  copyDefaultAddress() {
    $(`input[name='order[address_attributes][country]']`)[0].value = this.defaultCountryValue
    $(`input[name='order[address_attributes][postal_code]']`)[0].value = this.defaultPostalValue
    $(`input[name='order[address_attributes][region_with_type]']`)[0].value = this.defaultRegionValue
    $(`input[name='order[address_attributes][city_with_type]']`)[0].value = this.defaultCityValue
    $(`input[name='order[address_attributes][street_with_type]']`)[0].value = this.defaultStreetValue
    $(`input[name='order[address_attributes][house]']`)[0].value = this.defaultHouseValue
    $(`input[name='order[address_attributes][flat]']`)[0].value = this.defaultFlatValue

    this.retrieveDeliveryInfo()
    this.showDeliveryCostInfo(true)
  }

  // on 'Update address' click ;
  displayAddressInput() {
    this.clearAddressInput()
    this.showAddressSearch(true)
  }

  // on connect ; 
  // on updateDeliveryType change to 'RussianPost' ;
  hideAllDeliveryInfo() {
    let targets = [ this.defaultAddressTarget, this.previousAddressTarget, this.addressInputTarget, this.deliveryCostInfoTarget, this.deliveryPlannedDateInfoTarget, this.addressFieldsTarget, this.displayAddressInputButtonTarget, this.addressFieldsTarget, this.displayAddressInputButtonTarget ]
    targets.forEach(el => { $(el).addClass("hide") })    
  }

  // on updateDeliveryType change from !'RussianPost' ; 
  // on 'Update address' click ;
  // after retrieving delivery info
  showAddressSearch(displayBoolean) {
    let targets = [ this.addressInputTarget ]
    let targetsAfterChoice = [ this.displayAddressInputButtonTarget, this.addressFieldsTarget ] 

    if (displayBoolean) {
      targets.forEach(el => { $(el).removeClass("hide") } )
      if (this.previousAddressIsPresentValue) { $(this.previousAddressTarget).removeClass("hide") }
      if (this.defaultAddressIsPresentValue) { $(this.defaultAddressTarget).removeClass("hide") }
      targetsAfterChoice.forEach(el => { $(el).addClass("hide") } )
    } else {
      targets.forEach(el => { $(el).addClass("hide") } )
      targetsAfterChoice.forEach(el => { $(el).removeClass("hide") } )
      $(this.previousAddressTarget).addClass("hide")
      $(this.defaultAddressTarget).addClass("hide")
    }
  }

  showDeliveryCostInfo(displayBoolean) {
    let targets = [ this.deliveryCostInfoTarget, this.deliveryPlannedDateInfoTarget ]

    if (displayBoolean) {
      targets.forEach(el => { $(el).removeClass("hide") } )
    } else {
      targets.forEach(el => { $(el).addClass("hide") } )
    }
  }

  clearAddressInput() {
    var fields = ['country', 'postal_code', 'region_with_type', 'city_with_type', 'street_with_type', 'house', 'flat']
    fields.forEach(el => {
      $(`input[name='order[address_attributes][${el}]']`)[0].value = ''
    })
  }

  presentPreviousAddress(event) {
    var full_address = [this.countryValue, this.postalValue, this.regionValue, this.cityValue, this.streetValue, this.houseValue, this.flatValue]
    this.previousAddressTextTarget.textContent = full_address.filter(n => n).join(', ')
  }

  presentDefaultAddress(event) {
    var full_address = [this.countryValue, this.postalValue, this.regionValue, this.cityValue, this.streetValue, this.houseValue, this.flatValue]
    this.previousAddressTextTarget.textContent = full_address.filter(n => n).join(', ')
  }

  // on suggestion select ;
  retrieveDeliveryInfo() {
    let self = this

    const OBJECT = 27020 // Посылка (частное лицо или предприятие) -- Посылка стандарт с объявленной ценностью 
    const PACK = 20      // коробка M
    const FROM = 141206  // postal code of our plant
    const tariffEndPoint = "https://tariff.pochta.ru/v1/calculate/tariff?json&"
    const plannedDateEndPoint = "https://tariff.pochta.ru/v1/calculate/delivery?json&"
    var to     = $("input[name='order[address_attributes][postal_code]']")[0].value
    var sumoc = this.totalPriceValue
    var weight = $("#total_weight")[0].textContent

    var query = $.param({ from: FROM, to: to, weight: weight, sumoc: sumoc, object: OBJECT, pack: PACK })
    var url = tariffEndPoint + query

    // retrieve cost
    $.ajax({
      url: tariffEndPoint + query
    }).done(function(data) {
      self.deliveryCostValue = data.paynds
      console.log(self.deliveryCostValue)
      self.updateDeliveryCost()
      // console.log(typeof(data.paynds) == 'number')
      // console.log(data.paynds)
      self.updateTotal()
    });

    // retrieve planned date
    $.ajax({
      url: plannedDateEndPoint + query
    }).done(function(data) {
      var plannedDate = self.parseDate(data.delivery.deadline)
      self.deliveryPlannedDateTarget.textContent = plannedDate
    });

    this.showAddressSearch(false)
  }

  updateDeliveryType() {
    if (this.deliveryTypeSelectTarget.value != "Russian Post") {
      this.hideAllDeliveryInfo()
    } else {
      this.showAddressSearch(true)
    }
  }

  parseDate(date) {
    var year = date.substring(0,4)
    var month = date.substring(4,6)
    var day = date.substring(6,8)

    return `${day}-${month}-${year}`
  }

  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  toS(kop) {
    if (typeof(kop) == 'number') {
      return (kop / 100).toString(10) + '.00'
    }
  }
}
