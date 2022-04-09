import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'subscribeButton' ]
  
  static values = { itemId: Number, isOutOfStock: Boolean, 
                    isSubscribed: Boolean, 
                  }

  connect() {
    if (this.isOutOfStockValue) { $(this.subscribeButtonTarget).removeClass('hide') }
  }

  subscribe() {
    let self = this

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
        console.log(data)
        this.isSubscribedValue = !this.isSubscribedValue
        this.updateButton()
      },
      error: function(error) {
        alert(error.message)
      }
    })
  }

  updateButton() {
    if (this.isSubscribedValue) {
      this.subscribeButtonTarget.textContent = "Subscribe"
    } else {
      this.subscribeButtonTarget.textContent = "Unsubscribe"
    }
  }

  url() {
    return `/items/${this.itemIdValue}/subscribe`
  }
}
