var items_template = require("../../assets/handlebars/partials/items.hbs")
var search_filter_template = require("../../assets/handlebars/partials/search_filter/search_filter.hbs")
var categories_template = require("../../assets/handlebars/partials/search_filter/categories.hbs")

function ready() {
  var search_form = $(".items_search form")[0]

  if (search_form) {
    $(search_form).on('ajax:before', function(e) {
      clearResults()
      clearSearchFilter()
    }) .on('ajax:success', function(e) {
      var response = e.originalEvent.detail[0]
      updateSearchResults(response)
    })
  }
}

function updateSearchResults(response) {
  appendSearchFilter(response.meta);
  appendResults(response.results);
  appendSlider(moneyString(response.meta.prices.min), moneyString(response.meta.prices.max));
}

function appendResults(results) {
  $(".items").append(items_template({items: results}))
}

function appendSearchFilter(meta) {
  $(".search_filter").append(search_filter_template({meta: meta}))

  var categoryCheckboxes = $(".search_filter .category input")

  for (var i = 0; i < categoryCheckboxes.length; i++) {
    categoryCheckboxes[i].addEventListener('change', function(e) {
      filterSearchResults();
    })    
  }
}

function clearResults() {
  $(".items").empty()
}

function clearSearchFilter() {
  $(".search_filter").empty()
}

// https://refreshless.com/nouislider/
function appendSlider(min, max) {
  var slider = document.getElementById('slider');

  noUiSlider.create(slider, {
      start: [min, max],
      connect: true,
      range: {
          'min': min,
          'max': max
      }
  });

  var inputFormatFrom = document.getElementById('input-format-from');
  var inputFormatTo   = document.getElementById('input-format-to');

  slider.noUiSlider.on('update', function (values, handle) {
    switch (handle) {
      case 0:
        inputFormatFrom.value = values[handle];
        break;
      case 1:
        inputFormatTo.value = values[handle];
        break;
    }

    filterSearchResults();
  });

  inputFormatFrom.addEventListener('change', function () {
    slider.noUiSlider.set([this.value, null]);
  });

  inputFormatTo.addEventListener('change', function () {
    slider.noUiSlider.set([null, this.value]);
  });

}

function filterSearchResults() {
  var inputFormatFrom = document.getElementById('input-format-from');
  var inputFormatTo   = document.getElementById('input-format-to');
  var priceFrom = inputFormatFrom.value
  var priceTo = inputFormatTo.value

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
    // console.log(categoryItems)
    for (var j = 0; j < categoryItems.length; j++) {
      var item = categoryItems[j]
      var price = $(item).find("td.price")[0].textContent

      if ( price >= priceFrom && price <= priceTo ) { $(item).show() }
    }
  }
}

function moneyString(money) {
  return money / 100;
}

document.addEventListener('turbolinks:load', ready)