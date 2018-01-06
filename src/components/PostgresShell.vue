<template lang="pug">
  .pg-shell(:class="{expanded: layoutState !== 1}")
    router-view
</template>

<script>
  import {mapState} from 'vuex'
  export default {
    computed: {
      ...mapState({
        layoutState: state => state.app.layoutState
      })
    }
  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'

  .pg-shell
    padding-top: 410px
    margin: 0px auto
    width: 1040px
    &.expanded
      padding-top: 105px
      width: 1200px
</style>
