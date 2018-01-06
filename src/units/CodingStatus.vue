<template lang="pug">
  .status
    .status__option
      .status__option__indicator
      .status__option__text Execute All
    .status__option
      .status__option__indicator
      .status__option__text Execute Selection
</template>

<script>
  export default {
  }
</script>

<style lang="sass">
  @import '../assets/sass/vars'

  .status
    /*border: 2px red solid*/
    height: 100%
    box-sizing: border-box
    display: flex
    justify-content: center
    align-items: center
    +averia-font()
    font-size: 12px
    &__option
      /*border: 1px blue solid*/
      margin: 0px 25px
      display: flex
      align-items: center
      cursor: pointer
      &__indicator
        background-color: #585858
        width: 8px
        height: 8px
        margin-right: 4px

</style>
