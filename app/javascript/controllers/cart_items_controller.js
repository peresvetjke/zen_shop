import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ "amountSelect", "sum", 
                     "changeAmountButtons", "buyButton",
                     "availableAmount", "subscribeButton" ]
  static values = { url: String, itemId: Number, 
                    amount: Number, available: Number, 
                    id: { type: Number, default: 0 },
                    price: Number, weight: Number,
                    isSubscribed: Boolean
                  }

  connect() {
    if (this.changeAmountButtonsTargets.length > 0) { this.updateButtons() }
    this.updateAvailableAmount()
    this.updateAmountValue()
    this.updateSum()

    if (this.availableValue == 0 && this.amountValue == 0) {
      
      $(this.subscribeButtonTarget).removeClass('hide')
      if (this.isSubscribedValue) {
        this.subscribeButtonTarget.textContent = "Unsubscribe"
      } else {
        this.subscribeButtonTarget.textContent = "Subscribe"
      }

    }
  }

  sum() {
    return (this.priceValue * this.amountValue).toFixed(2)
  }

  updateButtons() {
    if (this.idValue == 0) {
      
      $(this.changeAmountButtonsTarget).addClass('hide')
      if (this.availableValue > 0) {
        $(this.buyButtonTarget).removeClass('hide')
      }

      if (this.isSubscribedValue) {
        this.subscribeButtonTarget.textContent = "Unsubscribe"
      } else {
        this.subscribeButtonTarget.textContent = "Subscribe"
      }

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

  updateSum() {
    if (this.hasSumTarget) {
      this.sumTarget.textContent = this.sum()
    }
  }

  updateCartItemValues(cartItem) {
    this.idValue = cartItem.id
    this.amountValue = cartItem.quantity
    this.availableValue = cartItem.available
    this.sumValue = this.priceValue * this.amountValue
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
        if (self.changeAmountButtonsTargets.length > 0) { self.updateButtons() }
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
        quantity: amount
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
        self.updateSum()
        if (self.changeAmountButtonsTargets.length > 0) { self.updateButtons() }
      },
      error: function(error) {
        alert(error.message)
      }
    })

    window.dispatchEvent(new CustomEvent("cartItemChanged"));
  }

  delete() {
    let self = this

    Rails.ajax({
      url: this.url(),
      type: 'delete',
      dataType: 'json',
      success(data) {
        self.removeCartItem(data.cart_item.id)
        self.idValue = 0
        self.amountValue = 0
        self.availableValue = data.cart_item.available
        self.updateAvailableAmount()
        self.updateAmountValue()
        if (self.changeAmountButtonsTargets.length > 0) { self.updateButtons() }
      },
      error: function(error) {
        alert(error.message)
      }
    })

    window.dispatchEvent(new CustomEvent("cartItemChanged"));
    window.dispatchEvent(new CustomEvent("cartItemDeleted"));
  }

  subscribe() {
    let url = `/items/${this.itemIdValue}/subscribe`
    let self = this

    Rails.ajax({
      url: url,
      type: 'post',
      dataType: 'json',
      success(data) {
        self.isSubscribedValue = !self.isSubscribedValue
        self.updateButtons()
        alert(data.message)
      },
      error: function(error) {
        alert(error.message)
      }
    })
  }

  removeCartItem(id) {
    if (!this.hasBuyButtonTarget) {
      $(`[data-cartitems-id-value='${id}']`).remove()
    }
  }
}
