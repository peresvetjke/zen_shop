import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { minPrice: Number, maxPrice: Number, 
                    priceFrom: Number, priceTo: Number 
                  }
  
  static targets = ["priceFrom", "priceTo", "item"]

  connect() {
    this.priceFromTarget.placeholder = this.minPriceValue / 100
    this.priceToTarget.placeholder = this.maxPriceValue / 100
  }

  filterSearchResults() {
    this.updatePriceFilter()
    
    var categoryCheckboxes = $(".search_filter .category input")
    var allCategories      = []
    var selectedCategories = []

    for (var i = 0; i < categoryCheckboxes.length; i++) {
      var categoryId = categoryCheckboxes[i].dataset.categoryId;
      allCategories.push(categoryId)  
      if ( $(categoryCheckboxes[i]).is(":checked") ) { selectedCategories.push(categoryId) }
    }

    if (selectedCategories.length == 0) { selectedCategories = allCategories }

    $('.item').hide()
    for (var i = 0; i < selectedCategories.length; i++) {
      var categoryItems = $(`.item[data-category-id=${selectedCategories[i]}]`)
      
      for (var j = 0; j < categoryItems.length; j++) {
        var item = categoryItems[j]
        var price = parseInt( $(item).find(".price")[0].textContent ) * 100

        if ( price >= this.priceFromValue && price <= this.priceToValue ) { $(item).show() }
      }
    }
  }

  updatePriceFilter() {
    if (this.priceFromTarget.value == '') {
      this.priceFromValue = this.minPriceValue
    } else {
      this.priceFromValue = this.priceFromTarget.value * 100
    }

    if (this.priceToTarget.value == '') {
      this.priceToValue = this.maxPriceValue
    } else {
      this.priceToValue = this.priceToTarget.value * 100
    }
  }
}
