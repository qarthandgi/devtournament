<template lang="pug">
  .status
    .status__option(:class="{executing: executeAll}")
      .status__option__indicator(:class="{executing: executeAll}")
      .status__option__text
        span Execute All (Cmd + Enter
        span(style="font-style:italic;") &nbsp;or&nbsp;
        span Ctrl + Enter)
    .status__option(:class="{executing: executeSelection}")
      .status__option__indicator(:class="{executing: executeSelection}")
      .status__option__text
        span Execute Selection (Option + Enter)
</template>

<script>
  import {bus} from '@/utils/bus'
  export default {
    data () {
      return {
        executeAll: false,
        executeSelection: false
      }
    },
    methods: {
      resetExecuteStatuses () {
        setTimeout(() => {
          this.executeAll = false
          this.executeSelection = false
        }, 191)
      },
      setExecuteStatus (obj) {
        if (obj.type === 'all') {
          this.executeAll = true
        } else if (obj.type === 'selection') {
          this.executeSelection = true
        }
        this.resetExecuteStatuses()
      }
    },
    mounted () {
      bus.$on('execute-sql', this.setExecuteStatus)
    }
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
      &.executing
        color: $dev-blue
      &__indicator
        background-color: #585858
        width: 8px
        height: 8px
        margin-right: 4px
        &.executing
          background-color: $dev-blue

</style>
