import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'changeAddressButton', 'saveAddressButton', 'addressInput', 'addressFields' ]
  static values = { country: String, postal: String, region: String, city: String, street: String, house: String, flat: String, addressIsPresent: Boolean }

  connect() {
    if (this.addressIsPresentValue) { 
      this.presentDefaultAddress()
      this.showAddressInput(false)
      this.showAddressFields(true)
    } else {
      this.showAddressInput(true)
      this.showAddressFields(false)
    }

    let self = this

    $("#address").suggestions({
      token: "8eef865634dc4c1d346ba618ae7fca0e2cc1e837",
      type: "ADDRESS",
      /* Вызывается, когда пользователь выбирает одну из подсказок */
      onSelect: function(suggestion) {
        if (typeof(suggestion.data['postal_code']) != "undefined") {
          self.fillAddress(suggestion)
          self.showAddressFields(true)
        }
      }
    });
  }

  fillAddress(suggestion) {
    const addressFields = ["country", "postal_code", "region_with_type", "city_with_type", "street_with_type", "house", "flat"]

    for (var i = 0; i < addressFields.length; i++) {
      var suggestionValue = suggestion.data[addressFields[i]]
      if (typeof(suggestionValue) == "undefined") { suggestionValue = "" }
      $(`input[name='default_address[${addressFields[i]}]']`)[0].value = suggestionValue
    }
  }

  presentDefaultAddress() {
    $(`input[name='default_address[country]']`)[0].value = this.countryValue
    $(`input[name='default_address[postal_code]']`)[0].value = this.postalValue
    $(`input[name='default_address[region_with_type]']`)[0].value = this.regionValue
    $(`input[name='default_address[city_with_type]']`)[0].value = this.cityValue
    $(`input[name='default_address[street_with_type]']`)[0].value = this.streetValue
    $(`input[name='default_address[house]']`)[0].value = this.houseValue
    $(`input[name='default_address[flat]']`)[0].value = this.flatValue

    this.showAddressFields(true)
    this.showAddressInput(false)
  }

  showAddressFields(displayBoolean) {
    if (displayBoolean) {
      $(this.addressFieldsTarget).removeClass("hide")
    } else {
      $(this.addressFieldsTarget).addClass("hide")
    }
  }

  showAddressInput(displayBoolean) {
    if (displayBoolean) {
      $(this.addressInputTarget).removeClass("hide")
      $(this.saveAddressButtonTarget).removeClass("hide")
      $(this.changeAddressButtonTarget).addClass("hide")
    } else {
      $(this.addressInputTarget).addClass("hide")
      $(this.saveAddressButtonTarget).addClass("hide")
      $(this.changeAddressButtonTarget).removeClass("hide")
    }
  }

  changeDefaultAddress() {
    this.showAddressFields(false)
    this.showAddressInput(true)
  }
}