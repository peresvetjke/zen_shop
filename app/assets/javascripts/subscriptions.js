function ready() {
  var subscriptionLink = $(".subscription a")

  if (subscriptionLink) {
    subscriptionLink.on('ajax:success', function(e) {
      var response = e.originalEvent.detail[0].message
      if (subscriptionLink[0].text == "Subscribe") {
        subscriptionLink[0].text = "Unsubscribe"
      } else {
        subscriptionLink[0].text = "Subscribe"
      }
      alert(response)
    })
  }
}

document.addEventListener('turbolinks:load', ready)