<template lang="pug">
  .home
    .home__options-container
      .home__options-container__option(@click="$router.push({name: `postgres-home`})")
        img(src="../assets/img/HomePage/postgres_group_compressed.png")
      .home__options-container__option
        img(src="../assets/img/HomePage/mysql_group_compressed.png")
      .home__options-container__option
        img(src="../assets/img/HomePage/python_group_compressed.png")
    button(@click="fetch") get data
</template>

<script>
  import {mapMutations} from 'vuex'
  import Register from '@/components/Register'

  export default {
    components: {
      Register
    },
    data () {
      return {
        msg: 'Hello'
      }
    },
    methods: {
      ...mapMutations({
        setLayoutState: 'app/setLayoutState'
      }),
      async fetch () {
        const response = await this.$axios.get('profile-data/')
        console.log('response from load data')
        console.log(response)
      }
    }
  }
</script>

<style lang="sass">
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
        &:hover
          opacity: 1.0
          transition: opacity 180ms linear
          cursor: pointer
        img
          width: 100%
  .home-test
    width: 200px
    height: 100px
    background-color: white
    margin: 0px auto
    position: relative
</style>
