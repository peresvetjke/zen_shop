import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { minPrice: Number, maxPrice: Number, 
                    priceFrom: Number, priceTo: Number,
                    filterIsExpanded: { type: Boolean, default: true },
                  }
  
  static targets = ["priceFrom", "priceTo", "item"]

  connect() {
    this.priceFromTarget.placeholder = this.minPriceValue / 100
    this.priceToTarget.placeholder = this.maxPriceValue / 100

    this.updateIcons()
    this.sleep(200).then(() => {
      this.filterSearchResults()
    })
  }
  
  // on collapseFilter click
  collapseFilter() {
    if (this.filterIsExpandedValue) {
      $("#filter").slideUp('slow')
    } else {
      $("#filter").slideDown('slow')
    }

    this.filterIsExpandedValue = !this.filterIsExpandedValue
    this.updateIcons()
  }

  // during collapseFilter click
  updateIcons() {
    if (this.filterIsExpandedValue) {
      $("#arrow_down").addClass('hide')
      $("#arrow_up").removeClass('hide')
      $("#collapse_filter #text")[0].textContent = "Hide"
    } else {
      $("#arrow_down").removeClass('hide')
      $("#arrow_up").addClass('hide')
      $("#collapse_filter #text")[0].textContent = "Show"
    }
  }

  // on reset button
  resetFilter() {
    $(".search_filter .category input").each(function() { this.checked = false })
    $(".search_filter .stock input")[0].checked = true
    this.priceFromTarget.value = ''
    this.priceToTarget.value = ''

    this.filterSearchResults()
  }

  // on any change of filter targets
  filterSearchResults() {
    this.updatePriceFilter()
    
    var availableCheckboxIsChecked = $(".search_filter .stock input")[0].checked
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
        var price = parseFloat( $(item).find(".price")[0].textContent ) * 100
        var isAvailable = $(item).find(".available_amount")[0].textContent > 0

        if ( price >= this.priceFromValue && 
             price <= this.priceToValue &&
             isAvailable == availableCheckboxIsChecked ) 
        { $(item).show() }
      }
    }

    this.updateResetButton()
  }

  filterIsBlank() {
    var availableCheckboxIsChecked = $(".search_filter .stock input")[0].checked
    var categoryCheckboxes = $(".search_filter .category input")
    
    return (
      categoryCheckboxes.toArray().every(el => el.checked == false) &&
      availableCheckboxIsChecked == true &&
      this.priceFromTarget.value == '' && this.priceToTarget.value == ''
    )
  }

  // on updateResetButton click ; on filterSearchResults()
  updateResetButton() {
    if (this.filterIsBlank()) {
      $("#reset_filter").addClass('hide')
    } else {
      $("#reset_filter").removeClass('hide')  
    }
  }

  // on filterSearchResults
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
  
  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
