<template lang="pug">
  .pg
    .pg__row
      .pg__row__section
        .top-panel.darker
        .pg__row__section__title Sandbox
        .pg__row__section__description
          span Use the sandbox to hone your skills in PostgreSQL. This is a non-destructive sandbox, experiment as much as you want, however you want. Practice your queries to prepare for the sessions or try your hand at a tournament.
        .pg__row__section__body
          small-clip(
            v-for="db in databases",
            :key="db.id",
            :item="db",
            :sub-title="`${db.num_tables} Tables`",
            @select="selectDb"
          )
      .pg__row__section
        .top-panel.darker
        .pg__row__section__title Tournament
        .pg__row__section__description
          span The tournament is your place to prove your skills and make real money. Hone your skills in the Sandbox and Sessions to prepare for the timed Tournament. You’ll have access to a UML diagram shortly beforehand to study. Be ready.
        .pg__row__section__tournament(style="font-size:16px;") Next Tournament
          br
          span(style="font-size:18px;") TBD
    .pg__row
      .pg__row__section.full
        .top-panel.darker
        .pg__row__section__title Exercises
        .pg__row__section__description
          span Exercises are provided for you to incrementally increase and perfect your skills. Exercises grow in complexity as you go through them, boosting your programming speed and knowledge quickly. Go through these to build your confidence for the Tournaments to prove your worth.
        .pg__row__section__category Custom
        .pg__row__section__content
          large-clip(
            v-for="item in customExercises",
            :key="item.id",
            :item="item",
            :custom="true",
            @select="selectExercise(arguments[0], 'custom')"
          )
          large-clip(
            :create="true",
            @select="selectExercise"
          )
        .pg__row__section__category Novice
        .pg__row__section__content
        .pg__row__section__category Intermediate
        .pg__row__section__content
          span hey
        .pg__row__section__category Advanced
        .pg__row__section__content
          span hey
</template>

<script>
  import {mapState} from 'vuex'
  import SmallClip from '@/units/SmallClip'
  import LargeClip from '@/units/LargeClip'

  export default {
    components: {
      SmallClip,
      LargeClip
    },
    data () {
      return {
      }
    },
    computed: {
      ...mapState({
        'databases': state => state.pg.databases,
        'customExercises': state => state.pg.customExercises
      })
    },
    methods: {
      selectDb (item) {
        this.$router.push({name: 'postgres-sandbox', params: {id: item.id}})
      },
      selectExercise (item, custom = false) {
        if (item === 'create') {
          this.$router.push({name: 'postgres-exercise', params: {id: 'new'}})
        } else if (custom) {
          this.$router.push({name: 'postgres-custom', params: {id: item.id}})
        }
      }
    }
  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'
  .pg__row
    width: 100%
    height: auto
    display: flex
    justify-content: space-between
    margin-bottom: 60px
    &__section
      /*border: 1px red solid*/
      width: 495px
      /*height: 300px*/
      position: relative
      &.full
        width: 100%
      &__title
        +special-elite-font()
        font-size: 28px
        color: #303030
        padding-top: 13px
      &__description
        +averia-font()
        color: #3f3f3f
        font-size: 13px
        margin-bottom: 20px
      &__category
        +averia-font()
        font-size: 17px
        color: #3f3f3f
        margin-bottom: 8px
      &__content
        margin-bottom: 20px
        display: grid
        grid-template-columns: 1fr 1fr 1fr
        &__exercise
          width: 315px
          height: 132px
          border: 1px #666767 solid
          background-color: #e8e8e8
          border-radius: 3px
          overflow: hidden
          position: relative
          .number-bg
            width: 100px
            height: 100px
            background-color: #646464
            position: absolute
            top: -64px
            left: -64px
            transform: rotateZ(45deg)
          .number
            position: absolute
            top: 3px
            left: 8px
            color: #e8e8e8
            +averia-font()
            font-size: 15px
      &__body
        margin-top: 36px
        /*height: 100px*/
        /*border: 1px blue solid*/
        display: flex
        flex-flow: row wrap
        justify-content: space-between
      &__tournament
        width: 300px
        height: 65px
        position: relative
        margin: 55px auto 0
        border: 2px #7f6932 solid
        border-radius: 4px
        background-color: rgba(127, 105, 50, 0.14)
        +averia-font()
        color: #292929
        text-align: center
        padding-top: 12px
        box-sizing: border-box
        cursor: pointer
        &:hover
          background-color: rgba(127, 105, 50, 0.20)

</style>
