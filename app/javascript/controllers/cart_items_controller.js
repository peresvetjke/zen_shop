import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ["amountSelect", "itemSum"] // "amountDelete", 
  static values = {url: String, itemid: Number} //, amount: Number

  create() {
    let params = {
      cart_item: { 
        item_id: this.itemidValue
      }
    }

    Rails.ajax({
      url: 'cart_items',
      type: 'post',
      dataType: 'json',
      beforeSend(xhr, options) {
        xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
        options.data = JSON.stringify(params)
        return true
      },
      error: function(error) {
        alert(error.message)
      }
    })
  }
  
  selectAmount() {
    let amount = parseInt(this.amountSelectTarget.value)

    this.update(amount)
  }

  increaseAmount() { 
    this.update(parseInt(this.amountSelectTarget.value) + 1) 
  }

  decreaseAmount() {
    let amount = parseInt(this.amountSelectTarget.value)

    if (amount == 1) {
      this.delete()
    } else {
      this.update(amount - 1)
    }
  }

  update(amount) {
    let params = {
      cart_item: { 
        amount: amount
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
      error: function(error) {
        alert(error.message)
      }
    })
  }

  delete() {
    Rails.ajax({
      url: this.urlValue,
      type: 'delete',
      dataType: 'json',
      error: function(error) {
        alert(error.message)
      }
    })

    window.dispatchEvent(new CustomEvent("cartItemDeleted"));
  }
}
