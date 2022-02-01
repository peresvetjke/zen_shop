<template>
  <div id="categories-list">
    <h2>All categories</h2>

    <table>
      <thead>
        <tr>
          <td>Title</td>
          <td></td>
        </tr>
      </thead>
      
      <tbody>
        <category v-for="category in categories" :key="category.id" :category="category"></category>
      </tbody>

    </table>
  </div>
</template>

<script>
export default {
  props: ['categories'],
}
</script>

<style scoped>

</style>