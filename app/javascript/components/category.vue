<template>
  <div id="category" class="category">
    
    <div v-show="isEditable == false">
      <div class="columns">
        <div class="column">
          <a :href="categoryHref" v-text="category.title"></a>
        </div>

        <div class="column">
          <a class="button is-small is-rounded" @click="toggleEdit">Edit</a>
          <a class="button is-small is-rounded" :href="categoryHref" data-confirm="Are you sure?" data-method="delete">Delete</a>
        </div>
      </div>
    </div>

    <div v-show="isEditable">
      <form :action="categoryHref" accept-charset="UTF-8" method="post" data-remote="true" data-type="json">
        <input type="hidden" name="_method" value="patch">
        <input type="hidden" name="authenticity_token" :value="csrfToken">

        <div class="field is-grouped">
          <input class="input control is-expanded" type="text" v-model="category.title" name="category[title]" id="category_title">
          
          <input v-show="false" class="button is-rounded is-small control" type="submit" name="commit" value="Save" data-disable-with="Update Category">

          <a class="button is-small is-rounded control" @click="updateCategory(category)">Save</a>
          <a class="button is-small is-rounded control" @click="toggleEdit">Cancel</a>
          <a class="button is-small is-rounded control" :href="categoryHref" data-confirm="Are you sure?" data-method="delete">Delete</a>
        </div>

      </form>
    </div>

  </div>
</template>

<script>
export default {
  data: function () {
    return {
      isEditable: false
    }
  },
  props: ['category'],
  computed: {
    categoryHref()    { return `/admin/categories/` + this.category.id },
    csrfToken()       { return $('meta[name="csrf-token"]')[0].content }
  },
  methods: {
    toggleEdit()      { this.isEditable = this.isEditable ? false : true },
    updateCategory(category)  {
      console.log("im alive here!")
      console.log(`category.title IS ${category.title}`)
      $.ajax({
        method: "PATCH",
        url: this.categoryHref,
        data: { category: { title: `${category.title}22222` } },
        ajaxComplete: function(data) {
          console.log('AJAX done!')
          console.log( "Data Saved: " + msg );
        }
      })
        
        
    }
  }
}
</script>

<style scoped>
  .category { margin-bottom: 20px; }
</style>