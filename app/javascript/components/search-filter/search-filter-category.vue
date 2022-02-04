<template>
  <div class="search-filter-category">
    <input class="form-check-input" type="checkbox" value="" :id="id" :data-category-id="id">

    <label class="form-check-label" :for="categoryId">
      {{ this.title }} - {{ this.results_count }}
    </label>
  </div>
</template>

<script>
  export default {
    props: [ 'category' ],
    computed: {
      categoryId() { return `category_${this.id}` }
    }  
  }
</script>

<style>
  
</style>