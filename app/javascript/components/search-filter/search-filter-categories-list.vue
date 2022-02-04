<template>
  <div id="search-filter-categories-list">
    <h4>Category</h4>
    <search-filter-category class="category form-check" v-for="category in categories"></search-filter-category>
  </div>
</template>

<script>
  export default {
    props: [ 'categories' ],
  }
</script>

<style>
  
</style>