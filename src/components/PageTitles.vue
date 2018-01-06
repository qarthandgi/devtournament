<template lang="pug">
  .titles
    .titles__con(:class="{[`state-${layoutState}`]: true, coding: layoutState === 2}")
        .titles__con__main-title(:class="{coding: layoutState === 2}") #DevTournament
          template(v-if="layoutState === 2")
            span.coding-icon &nbsp;&nbsp;
              img(src=`../assets/img/PageTitles/postgres_icon_uncompressed.png`)
            span.coding-subject &nbsp;&nbsp;POSTGRESQL
        .titles__con__sub-title(:class="{coding: layoutState === 2}") Competition that matters.
        .titles__con__subject(v-if=`layoutState === 1`)
          .titles__con__subject__pg(v-if=`subject === 'postgres'`)
            span.titles__con__subject__pg__icon
              img(src=`../assets/img/PageTitles/postgres_icon_uncompressed.png`)
            span.titles__con__subject__pg__text &nbsp;POSTGRESQL
</template>

<script>
  import {mapState} from 'vuex'

  export default {
    computed: {
      ...mapState({
        layoutState: state => state.app.layoutState,
        subject: state => state.app.subject
      })
    }
  }
</script>

<style lang="sass">
  @import '../assets/sass/vars'

  .titles
    position: absolute
    top: 0
    width: 100%
    /*border: 1px gold solid*/
    box-sizing: border-box
    /*color: red*/
    &__con
      /*border: 1px blue solid*/
      position: relative
      max-width: 400px
      margin: 0px auto
      text-align: center
      letter-spacing: .05em
      height: 30px
      transition: all 170ms linear
      &__main-title
        +special-elite-font()
        color: #fdfcf9
        font-size: 36px
        /*border: 1px red solid*/
        &.coding
          text-align: center
          /*border: 1px red solid*/
          font-size: 22px
          /*position: absolute*/
          /*margin: 0px auto*/
          width: 100%
      &__sub-title
        margin-top: 14px
        +averia-font()
        font-size: 18px
        color: #e9e9e9
        &.coding
          position: relative
          top: 10px
          margin: 0px auto
          font-size: 11px
      &__subject
        position: relative
        top: 90px
        img
          position: relative
          top: 12px
        +averia-font()
        font-size: 36px
        color: #e9e9e9
      &.state-0
        top: 180px
      &.state-1
        top: 112px
      &.coding
        margin-top: 26px
        max-width: 500px
        .coding-icon img
          width: 34px
          position: relative
          top: 10px
        .coding-subject
          font-size: 23px
          +averia-font()
</style>
