import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ["amountSelect", "amountDelete", "itemSum"]
  static values = {url: String}

  update() {
    let params = {
      cart_item: { 
        amount: this.amountSelectTarget.value
      }
    }

    Rails.ajax({
      url: this.urlValue,
      type: 'patch',
      dataType: 'json',
      beforeSend(xhr, options) {
        xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
        options.data = JSON.stringify(params)
        return true
      },
      // success: function() {
      //   window.dispatchEvent(new CustomEvent("cartItemChanged"));
      // },
      error: function(error) {
        alert(error.message)
      }
    })
  }

  delete() {
    window.dispatchEvent(new CustomEvent("cartItemChanged"));
  }
}
