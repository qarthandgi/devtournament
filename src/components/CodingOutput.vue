<template lang="pug">
  .output
    .top-panel(:class="[error ? 'danger' : 'darker']")
    .bottom-panel(:class="[error ? 'danger' : 'darker']")
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
      .output__body__message(v-else-if="error", :class="['error']", v-html="errorMessage")
      .output__body__message(v-else) Create a query, and press Cmd + Enter to execute
</template>

<script>
  export default {
    props: {
      headers: {required: true, default: () => { return [] }},
      rows: {required: true, default: () => { return [] }},
      error: {required: true, default: false},
      errorMessage: {required: true, default: ''}
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
    height: 100%
    overflow: scroll
    &__body
      margin: 3px 0px
      position: relative
      /*border: 1px red solid*/
      &__error
        position: absolute
        left: 0
        top: 0
        width: 100%
        height: 100%
        border: 1px red solid
      &__message
        text-align: center
        position: relative
        margin-top: 25px
        transform: translateY(-50%)
        +averia-font()
        font-size: 14px
        color: rgba(90,90,90,1)
        &.error
          color: $danger-red
          text-align: left
          line-height: 20px
          position: relative
          margin-top: 60px
          white-space: pre
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
              background-color: #c9c9cb
              position: sticky
              top: 3px
              &:after
                content: ''
                position: absolute
                left: 0
                bottom: 0
                width: 100%
                border-bottom: 1px rgba(30,30,30,0.9) solid
        tbody
          tr
            &:nth-child(even)
              background-color: #d2d2d5
</style>
