<template>
  <div id="category">
    
    <div v-show="isEditable == false">
      <tr>
        <td>
          <a :href="categoryHref" v-text="category.title"></a>
        </td>
        <td>
          <button @click="toggleEdit">Edit</button>
          <button>Delete</button>
        </td>
      </tr>
    </div>

    <div v-show="isEditable">
      <form :action="categoryHref" accept-charset="UTF-8" method="post">
        <input type="hidden" name="_method" value="patch">
        <input type="hidden" name="authenticity_token" :value="csrfToken">

        <tr>
          <td>
            <input type="text" :value="category.title" name="category[title]" id="category_title">
          </td>
          <td>
            <a @click="toggleEdit">Cancel</a>
            <a>Delete</a>
          </td>
        </tr>

        <input type="submit" name="commit" value="Update Category" data-disable-with="Update Category">

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
    categoryHref()  { return `/admin/categories/` + this.category.id },
    csrfToken()     { return $('meta[name="csrf-token"]')[0].content }
  },
  methods: {
    toggleEdit() { this.isEditable = this.isEditable ? false : true }
  }
}
</script>

<style scoped>

</style>