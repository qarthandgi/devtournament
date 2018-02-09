<template lang="pug">
  modal-window(v-if="show", :success-panels="true", width="350px")
    .close(@click='closeModal')
      span.fas.fa-times-circle
    div.ne(@click="goToNextExercise")
      .ne__heading
        span Congratulations!
      .ne__message
        span Go To Next Exercise&nbsp;&nbsp;
        span.fas.fa-angle-right

</template>

<script>
  import ModalWindow from '@/blocks/ModalWindow'
  import {mapState} from 'vuex'

  export default {
    components: {
      ModalWindow
    },
    props: {
      show: {required: true, default: false},
      currentSessionId: {requred: false, default: -1}
    },
    computed: {
      ...mapState({
        exercises: state => state.pg.exercises
      })
    },
    methods: {
      goToNextExercise () {
        const idx = this.exercises.findIndex(x => x.id === this.currentSessionId)
        if (idx === this.exercises.length - 1) {
          this.closeModal()
          return
        }
        const newId = this.exercises[idx + 1].id
        this.$router.push({name: 'postgres-exercise', params: {id: newId}})
        this.closeModal()
      },
      closeModal () {
        this.$emit('close-modal')
      }
    }
  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'

  .close
      position: absolute
      top: 15px
      right: 10px
      color: rgba(255,255,255,0.7)
      padding: 5px
      cursor: pointer
      font-size: 18px
      &:hover
        color: $warning-yellow
  .ne
    width: 85%
    border-radius: 5px
    border: 2px $dev-blue solid
    height: 90px
    margin: 0px auto
    text-align: center
    +averia-font()
    background-color: rgba(80,80,80,0.4)
    color: $dev-blue
    padding-top: 15px
    box-sizing: border-box
    cursor: pointer
    &:hover
      background-color: rgba(120,120,120,0.3)
    &__heading
      font-size: 20px
    &__message
      font-size: 17px
      padding-top: 8px
</style>
