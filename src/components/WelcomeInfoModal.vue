<template lang="pug">
  modal-window(v-if="showWelcome")
    welcome-info
    .wim
      .wim__got-it
        .wim__got-it__button(@click="closeWelcome")
          span Got It&nbsp;
          span.check
            i.far.fa-check
</template>

<script>
  import ModalWindow from '@/blocks/ModalWindow'
  import WelcomeInfo from '@/components/WelcomeInfo'

  import {mapState, mapMutations} from 'vuex'

  export default {
    components: {
      ModalWindow,
      WelcomeInfo
    },
    data () {
      return {
        modalVisibility: true
      }
    },
    computed: {
      ...mapState({
        showWelcome: state => state.pg.showWelcome
      })
    },
    methods: {
      ...mapMutations({
        'setShowWelcome': 'pg/setShowWelcome'
      }),
      closeWelcome () {
        this.modalVisibility = false
        this.setShowWelcome({state: false})
      }
    }
  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'
  .wim
    +averia-font()
    &__got-it
      &__button
        width: 140px
        height: 25px
        border: 1px $captive-gold solid
        margin: 0px auto
        color: $captive-gold
        font-size: 17px
        text-align: center
        padding-top: 4px
        &:hover
          border: 1px $dev-blue solid
          color: $dev-blue
          cursor: pointer
</style>
