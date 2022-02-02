<template>
  <div id="categories-list">
    <p class="title">All categories</p>

    <category v-for="category in categories" :key="category.id" :category="category"></category>
    <br>

    <p class="title is-4">New category</p>      

    <form action="/admin/categories" accept-charset="UTF-8" method="post">
      <input type="hidden" name="authenticity_token" :value="csrfToken">
  
      <label class="label" for="new_category_title">Title</label>

      <div class="field is-grouped">      
        <input class="input control is-expanded" type="text" name="category[title]" id="new_category_title">
      
        <input class="button is-rounded" type="submit" name="commit" value="Add" data-disable-with="Create Category">
      </div>
    </form>

  </div>
</template>

<script>
export default {
  props: ['categories'],
  computed: {
    csrfToken()     { return $('meta[name="csrf-token"]')[0].content }
  },
}
</script>

<style scoped>

</style>