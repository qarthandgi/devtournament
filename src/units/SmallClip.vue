<template lang="pug">
  .clip(
    @click="itemClicked(item, $event)",
    :class="{'locked': item.access !== 'granted'}"
  )
    .clip__left-panel(:class="{'locked': item.access !== 'granted'}")
    template(v-if="item.access == 'granted'")
      .clip__title {{item.full_name}}
      .clip__sub-title {{subTitle}}
      .clip__icon
        img(:src="item.icon_link")
    template(v-else)
      .clip__lock-title
        .fas.fa-lock-alt
      .clip__lock-message
        span(v-if="item.access === 'needs basic'") Must Have&nbsp;
          span.needed-blue Account
        span(v-else-if="item.access === 'needs premium'") Must Have&nbsp;
          span.needed-gold Premium
</template>

<script>
  export default {
    props: {
      item: {required: true, default: []},
      subTitle: {required: false, default: ''}
    },
    methods: {
      itemClicked (item, evt) {
        this.$emit('select', item)
      }
    }
  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'

  .clip
    position: relative
    width: 154px
    height: 46px
    border: 1px #878787 solid
    background-color: #dedede
    border-radius: 3px
    margin-bottom: 15px
    overflow: hidden
    cursor: pointer
    &:hover
      background-color: rgba(83, 110, 123, 0.2)
    &.locked
      border: 1px transparentize(#878787, 0.6) solid
    &__left-panel
      width: 4px
      height: 100%
      position: absolute
      left: 0
      top: 0
      background-color: #536e7b
      &.locked
        background-color: transparentize(#536e7b, 0.6)
    &__title
      position: absolute
      top: 5px
      left: 9px
      +averia-font()
      font-size: 15px
      color: #3f3f3f
    &__lock-title
      text-align: center
      color: #3f3f3f
      font-size: 24px
      opacity: 0.5
      transform: scale(.88, 1)
      position: relative
      top: 3px
    &__lock-message
      margin-top: 3px
      text-align: center
      font-size: 11px
      +averia-font()
      .needed-blue
        color: #536e7b
      .needed-gold
        color: #c79c2d
    &__sub-title
      position: absolute
      top: 24px
      left: 9px
      +averia-font()
      font-size: 14px
      color: rgba(63, 63, 63, 0.7)
    &__icon
      position: absolute
      width: 21px
      bottom: 2px
      right: 3px
      img
        width: 100%
        position: absolute
        bottom: 0
</style>
