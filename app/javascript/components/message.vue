<template>
  <div class="message is-success" v-show="isVisible">
    <div class="message-body">
      <slot></slot>
      <button class="delete" aria-label="delete" @click="closeMessage"></button>
    </div>
  </div>
</template>

<script>
  export default {
    data: function () {
      return {
        isVisible: true,
      }
    },
    props: [ 'message' ],
    methods: {
      closeMessage() {
        this.isVisible = false
      }
    }
  }
</script>

<style>
  
</style>