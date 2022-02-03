<template>
  <div id="categories-list">
    <p class="title">All categories</p>

    <message v-for="message in messages" :message="message">{{ message }}</message>

    <category v-for="category in categories" :key="category.id" :category="category" v-on:messageAdded="addMessage($event)"></category>
    <br>

    <p class="title is-4">New category</p>      

    <div id="new_category">
    
      <form @submit.prevent="createCategory">
        <input type="hidden" name="authenticity_token" :value="csrfToken">
        
        <label class="label" for="new_category_title">Title</label>

        <div class="field is-grouped">      
          <input class="input control is-expanded" type="text" name="category[title]" id="new_category_title" v-model="new_category_title" @keydown="errors.clear()">
        
          <input type="text" style="display:none;">
          <input type="hidden">

          <input class="button is-rounded is-primary" type="submit" name="commit" value="Add">
        </div>
      </form>

    </div>
    
    <errors :errors=errors.errors v-show="errors.any()"></errors>

  </div>
</template>

<script>
class Errors {
  constructor() {
    this.errors = {};
  }

  record(errors) {
    this.errors = errors;
  }

  clear() {
    this.errors = [];
  }

  any() {
    return this.errors.length > 0;
  }
}

export default {
  data: function () {
    return {
      messages: [],
      new_category_title: '',
      errors: new Errors,
      categoriesHref: "/admin/categories/"
    }
  },
  props: ['categories'],
  computed: {
    csrfToken()     { return $('meta[name="csrf-token"]')[0].content }
  },
  methods: {
    addMessage(message) {
      this.messages.push(message)
    },
    createCategory()  {
      var self = this;
      const axios = require('axios');

      let postData = {
        category: { 
          title: self.new_category_title 
        }
      };

      let axiosConfig = {
        headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'Accept': 'application/json',
            "Access-Control-Allow-Origin": "*",
            'X-CSRF-Token': this.csrfToken,
        }
      };

      axios.post(this.categoriesHref, postData, axiosConfig)
      .then(function (response) {
        self.categories.push(JSON.parse(response.data.category))
        self.addMessage(response.data.message)
        self.new_category_title = ''
      })
      .catch(function (error) {
        self.errors.record(error.response.data.errors)
      });
    },
  }
}
</script>

<style scoped>

</style>