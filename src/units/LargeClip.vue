<template lang="pug">
  .clip(:class="{create}", @click="selectClip")
    .clip__number-bg(v-if="!create")
    .clip__number(v-if="!create") {{ seq }}
    .clip__body
      .clip__body__title(:class="{create}")
        span.clip__body__title__text(v-if="!create") Main Title
        span.clip__body__title__text(v-else) Create a Custom Exercise
      .clip__body__sub-title
        span.clip__body__sub-title__text Invite Others to Complete It
    .clip__last-completed(v-if="!create") Last Completed
</template>

<script>
  export default {
    props: {
      seq: {required: false},
      item: {required: false},
      create: {required: false, default: false}
    },
    methods: {
      selectClip () {
        console.log('selecting')
        this.$emit('select', this.create ? 'create' : this.item)
      }
    }
  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'

  .clip
    width: 315px
    height: 132px
    border: 1px #666767 solid
    background-color: rgba(232, 232, 232, 1)
    border-radius: 3px
    overflow: hidden
    position: relative
    cursor: pointer
    &.create
      border: 1px #666767 dashed
    &:hover
      background-color: rgba(221, 221, 221, 0.6)
    &__number-bg
      width: 100px
      height: 100px
      background-color: #646464
      position: absolute
      top: -64px
      left: -64px
      transform: rotateZ(45deg)
    &__number
      position: absolute
      top: 3px
      left: 8px
      color: #e8e8e8
      +averia-font()
      font-size: 15px
    &__body
      /*text-align: center*/
      display: flex
      flex-flow: column nowrap
      justify-content: center
      align-items: center
      /*border: 1px green solid*/
      height: 80%
      +averia-font()
      &__title
        /*border: 1px red solid*/
        font-size: 17px
        opacity: 0.9
        &.create
          margin: -10px auto 10px
      &__sub-title
        font-size: 14px
        opacity: 0.65

</style>
