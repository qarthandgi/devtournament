<template lang="pug">
  .sci
    .sci__option
      span.sci__option__message
        span(v-if="true") Show
        span(v-else) Showing
        span &nbsp;Original Query
    .sci__option
      span.sci__option__message
        span(v-if="true") Show
        span(v-else) Showing
        span &nbsp;Original Query
    .sci__option
      span.sci__option__message
        span(v-if="true") Show
        span(v-else) Showing
        span &nbsp;Work-In-Progress
    // nothing
</template>

<script>
  export default {
    data () {
      return {
      }
    }
  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'

  .sci
    position: absolute
    top: -24px
    left: 0
    right: 0
    height: 18px
    display: grid
    grid-template-columns: 33.3% 33.3% 33.3%
    &__option
      text-align: center
      &__message
        padding: 1px 6px
        background-color: transparent
        border: 2px $dev-blue solid
        border-radius: 3px
        +averia-font()
        font-size: 14px
</style>
