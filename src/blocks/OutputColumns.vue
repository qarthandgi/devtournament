<template lang="pug">
  .od
    .od__row
      .od__row__item.header COLUMN
      .od__row__item.header DESCRIPTION
    draggable(v-model="columns", :options="{handle: '.od__row__handle'}", @update="updateList")
      .od__row(v-for="(col, $index) in columns")
        .od__row__item
          input(placeholder="", v-model="col.column")
        .od__row__item
          input(placeholder="", v-model="col.description")
        .od__row__handle
          span.fas.fa-th-large
        .od__row__remove(@click="removeRow($index)")
          span.fal.fa-times
    .od__add(@click="addRow")
      span.fa-style
        span.far.fa-plus
      span &nbsp;&nbsp;add row


</template>

<script>
  import draggable from 'vuedraggable'

  import {blankOutputRequirement} from '@/utils/objects'
  import InputField from '@/blocks/InputField'

  export default {
    components: {
      draggable,
      InputField
    },
    data () {
      return {
        columns: []
      }
    },
    watch: {
      columns: {
        handler (val) {
          this.$emit('defined-headers', this.columns.map(x => x.column))
          this.$emit('columns', [...this.columns])
        },
        deep: true,
        immediate: true
      }
    },
    methods: {
      addRow () {
        this.columns.push(blankOutputRequirement())
      },
      removeRow (idx) {
        this.columns.splice(idx, 1)
      },
      updateList (...args) {
        console.log(args)
      }
    }
  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'

  $border-extension: 10px

  .od
    /*border: 1px red solid*/
    position: relative
    margin-top: 15px
    &__add
      margin-top: 9px
      text-align: center
      font-size: 13px
      color: $dev-blue
      cursor: pointer
      z-index: 5
      .fa-style
        font-size: 11px
      &:hover
        color: lighten($dev-blue, 14%)
    &__row
      display: flex
      justify-content: space-between
      min-height: 26px
      width: 100%
      margin: 0px auto
      position: relative
      &__handle
        position: absolute
        top: 7px
        left: -11px
        color: $dev-blue
        cursor: grab
        font-size: 11px
        &:enabled, &:active
          cursor: grabbing
      &__remove
        position: absolute
        top: 6px
        right: -10px
        font-size: 14px
        color: rgba(230,230,230,0.5)
        &:hover
          color: rgba(220,80,70,0.9)
          cursor: pointer
      &__item
        width: 33.33%
        text-align: center
        +averia-font()
        font-size: 12px
        border-bottom: 1px rgba(90,90,90,0.7) solid
        display: flex
        justify-content: center
        align-items: center
        position: relative
        &:nth-child(2)
          input
            width: 93%
            text-align: left
        input
          width: 80%
          margin: 0px auto
          border: none
          background-color: transparent
          color: $normal-white
          text-align: center
          border-bottom: 1px transparentize($normal-white, 0.7) dashed
          outline: none
          &:focus
            border-bottom: 1px $dev-blue solid
        &:nth-child(1)
          width: 25%
        &:nth-child(2)
          width: 75%
        &.header
          color: rgba(180,180,180,0.75)
        &:nth-child(1)
          border-right: 1px rgba(90,90,90,0.8) solid
      &:last-child [class$='item']:nth-child(2)::after
        content: ''
        position: absolute
        bottom: -$border-extension
        left: -1px
        right: -1px
        height: $border-extension
        border-left: 1px rgba(90,90,90,0.7) solid
        box-sizing: border-box
        z-index: 0
</style>
