<template>
  <div id="items-list">

    <div class="items_search box">
  
      <form @submit.prevent="onSubmit">
        <div class="field is-grouped">
          <input class="input control is-expanded" type="text" v-model="searchTitle">
          
          <input class="button is-rounded is-primary" type="submit" name="commit" value="Search">
        </div>

      </form>

      <div class="search_filter">
      
        <search-filter-categories :categories="filteredCategories"></search-filter-categories>
        <search-filter-price></search-filter-price>

      </div>
    </div>

    <item v-show="searchResults.length > 0" v-for="item in searchResults" :item="item" :key="item.id"></item>
    <div v-show="searchResults.length == 0">
      <p>No items yet.</p>
    </div>
  </div>
</template>

<script>
export default {
  props: ['items'],
  data: function () {
    return {
      searchResults: this.items,
      filteredCategories: [],
      filteredPriceFrom: '',
      filteredPriceTo: '',
      searchItemsPath: '/items/search',
      searchTitle: ''
    }
  },
  computed: {
    csrfToken()     { return $('meta[name="csrf-token"]')[0].content }
  },
  methods: {
    onSubmit()      {
      alert("submitted!")
    },
    searchItems()   {
      alert("searching!")
    }
  },
}
</script>

<style>
  
</style>