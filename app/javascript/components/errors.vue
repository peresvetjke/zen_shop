<template>
  <div class="errors">
    <ol>
      <li v-for="error in errors">{{ error }}</li>
    </ol>
  </div>
</template>

<script>
  export default {
    props: ['errors'],
  }
</script>

<style>
  .errors {
    margin-left: 20px;
    color: red; 
  }
</style>