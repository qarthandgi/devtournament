<template lang="pug">
  .input-c
    input(
      :id="id",
      :type="password ? 'password' : 'text'",
      spellcheck="false",
      @keyup.enter.prevent="enterPressed",
      :key="reuseKey",
      :placeholder="placeholder",
      :style="{'font-size': fontSize}",
      @blur="keyPressed"
    )
    label(:for="id", v-if="!hideLabel") {{name}}
    .input-c__error
      span {{error[0]}}
</template>

<script>
  export default {
    props: {
      id: {required: true},
      name: {required: true},
      password: {required: false, default: false},
      reuseKey: {required: false, default: null},
      hideLabel: {required: false, default: false},
      placeholder: {required: false, default: ''},
      fontSize: {required: false},
      error: {required: false, default: ''}
    },
    data () {
      return {
      }
    },
    methods: {
      enterPressed (e) {
        console.log(e.target.value)
        this.$emit('enter', e.target.value)
      },
      keyPressed (e) {
        console.log('ok', e.target.value)
        this.$emit('update', e.target.value)
      }
    }
  }
</script>

<style lang="sass">
  @import '../assets/sass/vars'

  .input-c
    position: relative
    /*margin-top: 25px*/
    margin-bottom: 25px
    +averia-font()
    +text-normal-white(1.0)
    input
      width: 100%
      height: 22px
      border: none
      border-bottom: 1px $normal-white solid
      background-color: transparent
      outline: none
      +text-normal-white(1.0)
      font-size: 18px
      +averia-font()
      opacity: 0.85
      transition: opacity 150ms linear
      &:hover, &:focus, &:active
        opacity: 1.0
        transition: opacity 150ms linear
      &:focus
        border-bottom: 1px #6f9fae solid
    label
      position: absolute
      left: 0
      bottom: -18px
      +text-normal-white(0.75)
      font-size: 13px
    &__error
      position: absolute
      left: 70px
      right: -150px
      bottom: -18px
      font-size: 13px
      color: $danger-red
      text-align: left
</style>
