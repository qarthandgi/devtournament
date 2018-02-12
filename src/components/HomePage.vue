<template lang="pug">
  .home
    .home__options-container
      .home__options-container__option(@click="$router.push({name: `postgres-home`})")
        img(src="../assets/img/HomePage/postgres_group_compressed.png")
        .home__options-container__option__title
          span PostgreSQL
      .home__options-container__option
        img(src="../assets/img/HomePage/mysql_group_compressed.png")
        .home__options-container__option__title
          span MySQL
      .home__options-container__option
        img(src="../assets/img/HomePage/python_group_compressed.png")
        .home__options-container__option__title
          span Python
</template>

<script>
  import {mapMutations} from 'vuex'
  import Register from '@/components/Register'

  export default {
    components: {
      Register
    },
    methods: {
      ...mapMutations({
        setLayoutState: 'app/setLayoutState'
      })
    }
  }
</script>

<style lang="sass">
  @import '../assets/sass/vars'

  .home
    position: absolute
    height: 100%
    width: 100%
    box-sizing: border-box
    &__options-container
      position: relative
      top: 60%
      box-sizing: border-box
      max-width: 600px
      margin: 0px auto
      display: flex
      align-items: center
      &__option
        box-sizing: border-box
        flex: 1 1 auto
        opacity: 0.8
        transition: opacity 350ms linear
        position: relative
        &:hover
          opacity: 1.0
          transition: opacity 180ms linear
          cursor: pointer
        &__title
          position: absolute
          top: 50%
          left: 50%
          transform: translate(-50%, -50%)
          span
            +averia-font()
            position: relative
            top: 55px
            background-color: rgba(80,80,80,0.6)
            padding: 2px 6px
            border-radius: 6px
            font-size: 12px
            color: rgba(255,255,255,0.7)
        img
          width: 100%
  .home-test
    width: 200px
    height: 100px
    background-color: white
    margin: 0px auto
    position: relative
</style>
