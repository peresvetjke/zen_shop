<template>
  <div id="category" class="category" v-show="isDeleted == false">
    
    <div v-show="isEditable == false">
      <div class="columns">
        <div class="column">
          <a :href="categoryHref" v-text="category.title"></a>
        </div>

        <div class="column">
          <a class="button is-small is-rounded" @click="toggleEdit">Edit</a>
          <a class="button is-small is-rounded is-danger" @click="deleteCategory(category)">Delete</a>
        </div>
      </div>
    </div>

    <div v-show="isEditable">
      <form :action="categoryHref" accept-charset="UTF-8" method="post" data-remote="true" data-type="json">
        <input type="hidden" name="_method" value="patch">
        <input type="hidden" name="authenticity_token" :value="csrfToken">

        <div class="field is-grouped">
          <input class="input control is-expanded" type="text" v-model="title" name="category[title]" id="category_title" @keydown="errors.clear()">
          
          <input v-show="false" class="button is-rounded is-small control" type="submit" name="commit" value="Save" data-disable-with="Update Category">

          <a class="button is-small is-rounded control is-primary" @click="updateCategory(category)" :disabled="errors.any()">Save</a>
          <a class="button is-small is-rounded control" @click="toggleEdit">Cancel</a>
          <a class="button is-small is-rounded control is-danger" @click="deleteCategory(category)">Delete</a>
        </div>

      </form>

      <errors :errors=errors.errors v-show="errors.any()"></errors>

    </div>

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
      isEditable: false,
      isDeleted: false,
      title: this.category.title,
      errors: new Errors
    }
  },
  props: [ 'category' ],
  computed: {
    categoryHref()    { return `/admin/categories/` + this.category.id },
    csrfToken()       { return $('meta[name="csrf-token"]')[0].content }
  },
  methods: {
    toggleEdit()      { this.isEditable = this.isEditable ? false : true },
    deleteCategory(category)  {
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

        axios.delete(this.categoryHref, axiosConfig)
        .then(function (response) {
          self.messageAdded(response.data.message)
          self.isDeleted = true
        })
        .catch(function (error) {
          console.log(error.response)
        });
      }
    },
    updateCategory(category)  {
      var self = this;
      const axios = require('axios');

      let patchData = {
        category: { 
          title: `${this.title}` 
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

      axios.patch(this.categoryHref, patchData, axiosConfig)
      .then(function (response) {
        category.title = JSON.parse(response.data.category).title
        self.messageAdded(response.data.message)
        self.toggleEdit()
      })
      .catch(function (error) {
        self.errors.record(error.response.data.errors)
      });
        
        
    },
    messageAdded(message) {
      this.$emit("messageAdded", message)
    },
  }
}
</script>

<style scoped>
  .category { margin-bottom: 20px; }
</style>