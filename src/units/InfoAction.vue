<template lang="pug">
  .info-action
    .info-action__content
      span Double Tap <pre>SHIFT</pre> to View&nbsp;
        span.type Expected Results
</template>

<script>
  export default {

  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'

  .info-action
    border-top: 3px $dev-blue solid
    background-color: rgba(255,255,255,0.18)
    text-align: center
    line-height: 35px
    +averia-font()
    color: rgba(220,220,220,0.8)
    font-size: 13px
    position: absolute
    bottom: 0
    height: 40px
    left: 0
    right: 0
    pre
      display: inline
      color: rgba(220,80,80,0.8)
      font-size: 14px
    .type
      color: #c1981c
</style>
