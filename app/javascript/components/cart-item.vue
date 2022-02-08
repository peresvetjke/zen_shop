<template>
  <tr class="cart-item" v-show="isDeleted == false">

    
    <td v-text="cartItem.title"></td>
    <td class="has-text-centered">
      <div class="field is-grouped amount-group">
        <a class="button control is-danger" @click="changeUnitAmountBy(-1)">-</a>
        <input class="input control" type="text" v-model="this.cartItem.amount" disabled="true">  
        <a class="button control is-primary" @click="changeUnitAmountBy(1)">+</a>
        
      </div>
    </td>
    <td class="has-text-centered">{{ subTotal }} RUB</td>
    <td class="has-text-centered">
      <a class="button is-rounded delete-cart-item is-danger" @click="deleteCartItem">Delete</a>
    </td>

  </tr>
  
</template>

<script>
  export default {
    data: function () {
      return {
        // itemAmount: this.cartItem.amount,
        isDeleted: false,
      }
    },
    props: ['cartItem'],
    computed: {
      cartItemHref()    { return `/cart_items/` + this.cartItem.id },
      csrfToken()       { return $('meta[name="csrf-token"]')[0].content },
      subTotal()        { return this.cartItem.item.price_cents / 100 * this.cartItem.amount }
    },
    methods: {
      messageAdded(message) {
        this.$emit("messageAdded", message)
      },
      // increaseUnitAmount() {
      //   console.log("increaseUnitAmount")
      // },
      changeUnitAmountBy(delta) {
        var self = this;
        const axios = require('axios');

        let patchData = {
          cart_item: { 
            amount: delta 
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

        axios.patch(this.cartItemHref, patchData, axiosConfig)
        .then(function (response) {
          self.cartItem.amount = response.data.cart_item.amount
        })
        .catch(function (error) {
          self.messageAdded(error.response.data.message)
        });
      },
      deleteCartItem(cartItem) {
        if (confirm('Are you sure?')) {
          var self = this;
          const axios = require('axios');

          let axiosConfig = {
            headers: {
                'Content-Type': 'application/json;charset=UTF-8',
                'Accept': 'application/json',
                "Access-Control-Allow-Origin": "*",
                'X-CSRF-Token': this.csrfToken,
            },
            data: {},
          };

          axios.delete(this.cartItemHref, axiosConfig)
          .then(function (response) {
            self.messageAdded(response.data.meta.message)
            self.isDeleted = true
            self.$emit("cartItemDeleted", self.cartItem)
          })
          .catch(function (error) {
            console.log(error)
          });
        }
      }
    }
  }
</script>

<style>

</style>