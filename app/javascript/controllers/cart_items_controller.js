import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ "amountSelect", "itemSum", 
                     "changeAmountButtons", "buyButton",
                     "availableAmount" ]
  static values = { url: String, itemId: Number, 
                    amount: Number, available: Number, 
                    id: { type: Number, default: 0 },
                  }

  connect() {
    this.updateButtons()
  }

  updateButtons() {
    if (this.idValue == 0) {
      $(this.changeAmountButtonsTarget).addClass('hide')
      $(this.buyButtonTarget).removeClass('hide')
    } else {
      $(this.changeAmountButtonsTarget).removeClass('hide')
      $(this.buyButtonTarget).addClass('hide')
    }
  }

  updateAvailableAmount() {
    this.availableAmountTarget.textContent = this.availableValue
  }

  updateAmountValue() {
    this.amountSelectTarget.value = this.amountValue
  }

  updateCartItemValues(cartItem) {
    this.idValue = cartItem.id
    this.amountValue = cartItem.amount
    this.availableValue = cartItem.available
  }

  url() {
    if (this.idValue == 0) {
      return "/cart_items"
    } else {
      return `/cart_items/${this.idValue}`
    }
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

  create() {
    let self = this
    let params = {
      cart_item: { 
        item_id: this.itemIdValue
      }
    }

    Rails.ajax({
      url: this.url(),
      type: 'post',
      dataType: 'json',
      beforeSend(xhr, options) {
        xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
        options.data = JSON.stringify(params)
        return true
      },
      success(data) {
        self.updateCartItemValues(data.cart_item)
        self.updateAmountValue()
        self.updateAvailableAmount()
        self.updateButtons()
      },
      error: function(error) {
        alert(error.message)
      }
    })
  }

  update(amount) {
    let self = this
    let params = {
      cart_item: { 
        amount: amount
      }
    }

    Rails.ajax({
      url: this.url(),
      type: 'patch',
      dataType: 'json',
      beforeSend(xhr, options) {
        xhr.setRequestHeader('Content-Type', 'application/json; charset=UTF-8')
        options.data = JSON.stringify(params)
        return true
      },
      success(data) {
        self.updateCartItemValues(data.cart_item)
        self.updateAvailableAmount()
        self.updateAmountValue()
        self.updateButtons()
      },
      error: function(error) {
        alert(error.message)
      }
    })

    window.dispatchEvent(new CustomEvent("cartItemsChanged"));
  }

  delete() {
    let self = this

    Rails.ajax({
      url: this.url(),
      type: 'delete',
      dataType: 'json',
      success(data) {
        self.idValue = 0
        self.amountValue = 0
        self.availableValue = data.cart_item.available
        self.updateAvailableAmount()
        self.updateAmountValue()
        self.updateButtons()
      },
      error: function(error) {
        alert(error.message)
      }
    })

    window.dispatchEvent(new CustomEvent("cartItemsChanged"));
    window.dispatchEvent(new CustomEvent("cartItemDeleted"));
  }
}
