import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "totalSum" ]
  
  connect() {
    // console.log(parseInt($("#total_price")[0].textContent) + parseInt($("#delivery_cost")[0].textContent))
    // this.totalSumTarget.textContent = parseInt($("#total_price")[0].textContent) + parseInt($("#delivery_cost")[0].textContent)
  }
}