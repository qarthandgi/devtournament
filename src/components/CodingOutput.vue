<template lang="pug">
  .output
    .top-panel.darker
    .bottom-panel.darker
    .output__body
      table.output__body__table(v-if="availableData")
        thead
          tr
            template(v-for="header in headers")
              td {{ header }}
        tbody
          template(v-for="row in rows")
            tr
              template(v-for="item in row")
                td {{ item }}
      .output__body__message(v-else) Create a query, and press Cmd + Enter to execute
</template>

<script>
  export default {
    props: {
      headers: {required: true, default: () => { return [] }},
      rows: {required: true, default: () => { return [] }}
    },
    computed: {
      availableData () {
        return this.headers.length > 0 || this.rows.length > 0
      }
    }
  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'

  .output
    &__body
      margin: 3px 0px
      position: relative
      /*border: 1px red solid*/
      &__message
        text-align: center
        position: relative
        margin-top: 25px
        transform: translateY(-50%)
        +averia-font()
        font-size: 14px
        color: rgba(90,90,90,1)
      &__table
        /*border: 1px green solid*/
        width: 100%
        border-collapse: collapse
        font-family: 'Yantramanav', sans-serif
        font-size: 14px
        thead
          tr
            font-weight: bold
            background-color: #c9c9cb
            td
              border-bottom: 1px rgba(30,30,30,0.9) solid
        tbody
          tr
            &:nth-child(even)
              background-color: #d2d2d5
</style>
