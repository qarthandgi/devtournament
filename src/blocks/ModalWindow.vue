<template lang="pug">
  transition(name="garage")
    .modal(:style="{width}")
      .top-panel(:class="{success: successPanels}")
      .bottom-panel(:class="{success: successPanels}")
      slot
      .disabled(v-if="loadingOverlay")
        .disabled__text
          span Processing...
          .disabled__text__small (please do not reload the page)
</template>

<script>
  import {mapState} from 'vuex'

  export default {
    props: {
      successPanels: {required: false, default: false},
      width: {required: false, default: null}
    },
    computed: {
      ...mapState({
        loadingOverlay: state => state.app.loadingOverlay
      })
    }
  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'

  .modal
    position: fixed
    height: auto
    width: 600px
    left: 50%
    top: 50%
    padding: 34px
    background-color: rgba(38,38,38,0.98)
    transform: translateX(-50%) translateY(-50%)
    border-radius: $border-panel-radius
    z-index: 20
    max-height: 2000px
    overflow: hidden
    .disabled
      position: absolute
      top: 0
      left: 0
      width: 100%
      height: 100%
      background-color: rgba(90,90,90,0.7)
      cursor: progress
      text-align: center
      color: rgba(220,220,220,0.9)
      +averia-font()
      &__text
        position: relative
        top: 43%
        font-size: 20px
        &__small
          font-size: 16px
</style>
