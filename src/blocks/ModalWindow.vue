<template lang="pug">
  .modal
    .top-panel(:class="{success: successPanels}")
    .bottom-panel(:class="{success: successPanels}")
    slot
</template>

<script>
  export default {
    props: {
      successPanels: {required: false, default: false}
    }
  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'

  .modal
    position: fixed
    height: 400px
    width: 600px
    left: 50%
    top: 50%
    padding: 35px
    background-color: rgba(38,38,38,0.98)
    transform: translateX(-50%) translateY(-50%)
    border-radius: $border-panel-radius
    z-index: 10
</style>
