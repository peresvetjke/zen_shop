<template>
  <div class="box">
    <p><strong>Title: </strong>{{ item.title }}</p>
    <p><strong>Price: </strong>{{ item.price_cents }}</p>
    
    <div class="field is-grouped amount-group">
      <a class="button control is-primary">+</a>
      <input class="input control" type="text" v-model="itemAmount">  
      <a class="button control is-danger">-</a>
    </div>

    <a class="button is-rounded add-to-cart" @click="addToCart">Add to cart</a>
  </div>
</template>

<script>
  export default {
    data: function () {
      return {
        itemAmount: 1,
        cartItemsHref: "/cart_items"
      }
    },
    props: ['item'],
    computed: {
      csrfToken()     { return $('meta[name="csrf-token"]')[0].content }
    },
    methods: {
      addToCart() {
        var self = this;
        const axios = require('axios');

        let postData = {
          cart_item: {
            item_id: self.item.id,
            amount: self.itemAmount
          }
        };

        let axiosConfig = {
          headers: {
              // 'Content-Type': 'application/html;charset=UTF-8',
              // 'Accept': 'application/html',
              "Access-Control-Allow-Origin": "*",
              'X-CSRF-Token': this.csrfToken,
          }
        };

        axios.post(this.cartItemsHref, postData, axiosConfig)
        // .then(function (response) {
          // console.log(response)
        // })
        .catch(function (error) {
          alert(error)
        });
      }
    }
  }
</script>

<style>
  .amount-group {
    width: 75px;
  }
  .add-to-cart {
   width: 175px; 
  }
</style>