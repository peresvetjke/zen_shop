<template>
  <div id="cart">

    <p class="title">Checkout</p>

    <message v-for="message in messages" :message="message">{{ message }}</message>

    <div v-show="this.cartItems.length > 0">
      <table class="table">
        <thead>
          <tr>
            <th>Item</th>
            <th class="has-text-centered">Amount</th>
            <th class="has-text-centered">Subtotal</th>
            <th class="has-text-centered"></th>
          </tr>
        </thead>
        
        <tbody id="cart-form" v-show="this.cartItems.length > 0">
          <cart-item v-for="cartItem in cartItems" :key="cartItem.id" :cartItem="cartItem" v-on:messageAdded="addMessage($event)" v-on:cartItemDeleted="deleteCartItem($event)"></cart-item>
        </tbody>

        <tfoot>
          <td></td>
          <td class="has-text-right"><strong>TOTAL:</strong></td>
          <td class="has-text-centered">{{ this.total }} RUB</td>
          <td></td>
        </tfoot>
        
      </table>

      <p class="title is-5">Delivery info</p>
      <label class="label" for="delivery-type-id">Delivery type:</label>
      <select class="select" v-model="selectedDeliveryType" name="delivery-type-name" id="delivery-type-id">
        <option disabled value="">Please select one</option>
        <option v-for="deliveryType in delivery_types">{{ deliveryType[0] }}</option>
      </select>

      <div v-show="selectedDeliveryType == this.russianPost">
        <label class="label">Address:</label>
        <input id="address" name="address" type="text" @keydown="dadaSuggestions">

        <div v-show="addressIsMaintained" id="address-info">
          
          <div class="field is-grouped">
            <label class="label" for="country">Country:</label>
            <p>{{ country }}</p>
          </div>

          <div class="field is-grouped">
            <label class="label" for="country">Postal code:</label>
            <p>{{ postal_code }}</p>
          </div>

          <div class="field is-grouped">
            <label class="label" for="country">Region:</label>
            <p>{{ region_with_type }}</p>
          </div>

          <div class="field is-grouped">
            <label class="label" for="country">City:</label>
            <p>{{ city_with_type }}</p>
          </div>

          <div class="field is-grouped">
            <label class="label" for="country">Street:</label>
            <p>{{ street_with_type }}</p>
          </div>

          <div class="field is-grouped">
            <label class="label" for="country">House:</label>
            <p>{{ house }}</p>
          </div>

          <div class="field is-grouped">
            <label class="label" for="country">Flat:</label>
            <p>{{ flat }}</p>
          </div>

        </div>
      </div>

      <br>
      <a class="button is-primary" id="create-order" @click="createOrder">Create order</a>
    </div>

    <p v-show="this.cartItems.length == 0">No items in cart yet.</p>

  </div>
</template>

<script>
  export default {
    data: function () {
      return {
        messages: [],
        cartItemsHref: "/cart_items",
        ordersHref: "/orders",
        cartItems: this.cart_items.cart_items,
        selectedDeliveryType: '',
        russianPost: 'Russian Post',
        addressInput: 'address',
        addressIsMaintained: false,

        country: '-', 
        postal_code: '-', 
        region_with_type: '-', 
        city_with_type: '-', 
        street_with_type: '-', 
        house: '-', 
        flat: '-'
      }
    },
    props: ['delivery_types', 'cart_items'],
    computed: {
      total()           {
        var total = 0
        this.cartItems.forEach(cartItem => {
          total += cartItem.amount * cartItem.item.price_cents / 100
        })
        return total
      },
      csrfToken()       { return $('meta[name="csrf-token"]')[0].content }
    },
    methods: { 
      createOrder()            {
        var self = this;

        const axios = require('axios');

        let orderItemsAttributes = this.cartItems.map(cartItem => {
          return {
            item_id: cartItem.item.id,
            unit_price: cartItem.item.price_cents / 100,
            quantity: cartItem.amount
          }
        })
        let deliveryAttributes = { delivery_type: this.selectedDeliveryType }
        let addressAttributes = {  
          country: this.country,
          postal_code: this.postal_code,
          region_with_type: this.region_with_type,
          city_with_type: this.city_with_type, 
          street_with_type: this.street_with_type, 
          house: this.house, 
          flat: this.flat
        }

        let postData = { order: 
          { order_items_attributes: orderItemsAttributes,
            delivery_attributes: deliveryAttributes,
            address_attributes: addressAttributes
          } 
        };

        let axiosConfig = {
          headers: {
              'Content-Type': 'application/json;charset=UTF-8',
              'Accept': 'application/json',
              "Access-Control-Allow-Origin": "*",
              'X-CSRF-Token': this.csrfToken,
          },
          data: {},
        };

        axios.post(this.ordersHref, postData, axiosConfig)
        .then(function (response) {
          self.addMessage(response.data.message)
          self.cartItems = []
        })
        .catch(function (error) {
          console.log(error)
          // self.messageAdded(error.response.data.message)
        });
      },
      addMessage(message)      { this.messages.push(message) },
      deleteCartItem(deleted)  { this.cartItems = this.cartItems.filter(cartItem => cartItem !== deleted) },
      dadaSuggestions()        {
        var self = this

        $(`#${this.addressInput}`).suggestions({
          token: "8eef865634dc4c1d346ba618ae7fca0e2cc1e837",
          type: "ADDRESS",
          /* Вызывается, когда пользователь выбирает одну из подсказок */
          onSelect: function(suggestion) {
            self.country = suggestion.data.country || '-'
            self.postal_code = suggestion.data.postal_code || '-'
            self.region_with_type = suggestion.data.region_with_type || '-'
            self.city_with_type = suggestion.data.city_with_type || '-'
            self.street_with_type = suggestion.data.street_with_type || '-'
            self.house = suggestion.data.house || '-'
            self.flat = suggestion.data.flat || '-'

            self.addressIsMaintained = true
          }
        });
      }
    },
    // beforeMount() {
    //     var self = this;
    //     const axios = require('axios');

    //     let axiosConfig = {
    //       headers: {
    //           'Content-Type': 'application/json;charset=UTF-8',
    //           'Accept': 'application/json',
    //           "Access-Control-Allow-Origin": "*",
    //           'X-CSRF-Token': this.csrfToken,
    //       },
    //       data: {},
    //     };

    //     axios.get(this.cartItemsHref, axiosConfig)
    //     .then(function (response) {
    //       self.cartItems = response.data.cart_items
    //     })
    //     .catch(function (error) {
    //       console.log(error)
    //     });
    //   },
  }
</script>

<style>


</style>