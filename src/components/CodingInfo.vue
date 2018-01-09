<template lang="pug">
  .info
    .info__details
      .info__details__item.idi-session
        .info__details__item__label EXERCISE
        .info__details__item__content
          span(v-if="mode === 'view'") {{ sessionInfo.name }}
          span(v-else)
            input-field(
              :id="'session-create'",
              name="exercise",
              :hide-label="true",
              placeholder="Exercise Name",
              @update="newExercise.name = arguments[0]"
            )
      .info__details__item.idi-db
        .info__details__item__label DATABASE
        .info__details__item__content(:class="{edit: mode === 'edit'}", style="overflow: hidden")
          span(v-if="mode === 'view' && sessionInfo.hasOwnProperty('database')") {{ sessionInfo.database }}
          span(v-else-if="mode === 'view' && sessionInfo.hasOwnProperty('db')") {{ databases.find(x => x.id === sessionInfo.db)['full_name'] }}
          template(v-else)
            .info__details__item__content__db(
              v-for="db in databases",
              @click='selectDb(db)',
              :class="{selected: db.id === newExercise.database}"
            )
              span {{ db.full_name }}
      .info__details__item.idi-objective
        .info__details__item__label OBJECTIVE
        .info__details__item__content
          span(v-if="mode === 'view'") {{ sessionInfo.objective }}
          textarea(v-else, v-model="newExercise.objective")
      .info__details__item.idi-requirements(v-if="mode === 'edit' || custom")
        .info__details__item__label OUTPUT REQUIREMENTS
        .info__details__item__content
          .info__details__item__content__toggle(v-if="custom", @click="outputColumnsVisibility = !outputColumnsVisibility") Toggle Output Requirements
          output-columns(
            v-if="outputColumnsVisibility || mode === 'edit'",
            @defined-headers="definedHeaders = arguments[0]",
            @columns="definedColumns = arguments[0]",
            :json-columns="sessionInfo.column_descriptions || ''",
            :custom-view="mode === 'view' && custom"
          )
      .info__details__item.idi-invites(v-if="custom && mode === 'view'")
        .info__details__item__label INVITATIONS
        .info__details__item__content
          invite-clip(
            v-for="item in invitations",
            :item="item",
            :key="item.id"
          )
          invite-clip(:create="true")
    .info__shift
      .info__shift__content(v-if="mode === 'view'") {{ doubleShiftMessage }}
      .info__shift__content(v-else, @click="createExercise") Create Exercise
</template>

<script>
  import InputField from '@/blocks/InputField'
  import OutputColumns from '@/blocks/OutputColumns'
  import InviteClip from '@/units/InviteClip'

  import {mapState} from 'vuex'

  export default {
    components: {
      InputField,
      OutputColumns,
      InviteClip
    },
    props: {
      sessionInfo: {required: true, default: () => { return {} }},
      mode: {required: false, default: 'view'},
      headers: {required: false, default: []},
      custom: {required: false, default: false}
    },
    data () {
      return {
        shiftMessage: false,
        showingUserTable: true,
        value: '',
        newExercise: {
          name: '',
          database: -1,
          objective: ''
        },
        definedHeaders: [],
        definedColumns: [],
        outputColumnsVisibility: false
      }
    },
    computed: {
      invitations () {
        return this.sessionInfo.invitation_set
      },
      ...mapState({
        databases: state => state.pg.databases
      }),
      doubleShiftMessage () {
        let message = ''
        if (this.showingUserTable) {
          message = 'Double Tap Shift to Show EXPECTED Output'
        } else {
          message = 'Double Tap Shift to Show YOUR Output'
        }
        return message
      }
    },
    watch: {
      'newExercise.database': {
        handler (val) {
          this.$emit('db-change', val)
        }
      },
      headers (val) { this.checkHeaders() },
      definedHeaders (val) { this.checkHeaders() }
    },
    methods: {
      createExercise () {
        this.$emit('create', {...this.newExercise, columnDescriptions: JSON.stringify(this.definedColumns)})
      },
      selectDb (db) {
        this.$set(this.newExercise, 'database', db.id)
      },
      checkHeaders () {
        const match = this._.isEqual(this.headers, this.definedHeaders)
        this.$emit('headers-match', match)
      }
    }
  }
</script>


<style lang="sass" scoped>
  @import '../assets/sass/vars'
  $double-tap-height: 45px

  .info
    position: relative
    height: 100%
    padding: 20px
    box-sizing: border-box
    overflow: scroll
    &__details
      position: relative
      top: 0
      bottom: $double-tap-height
      &__item
        margin-bottom: 45px
        &__label
          +special-elite-font()
          font-size: 13px
          color: #e8e8e8
          opacity: 0.8
          margin-bottom: 7px
        &__content
          +averia-font()
          color: #e8e8e8
          border-radius: 5px
          /*overflow: hidden*/
          /*border: 1px red solid*/
          &__toggle
            color: $dev-blue
            font-size: 12px
            cursor: pointer
            position: relative
            top: -3px
            &:hover
              color: darken($dev-blue, 9%)
            &:active
              color: darken($dev-blue, 14%)
          &.edit
            display: grid
            grid-template-columns: 1fr 1fr 1fr
            border: 1px rgba(190,190,190,0.3) solid
          &__db
            font-size: 13px
            padding: 5px
            color: rgba(215,215,215,1)
            /*border: 1px green solid*/
            display: flex
            text-align: center
            align-items: center
            justify-content: center
            &:hover
              background-color: transparentize(#6f9fae, 0.7)
              cursor: pointer
            &.selected
              background-color: transparentize(#6f9fae, 0.18)
          textarea
            /*margin: 5px*/
            width: 100%
            height: 60px
            background-color: rgba(230,230,230,0.05)
            outline: none
            border: 1px rgba(255,255,255,0.7) solid
            resize: none
            +averia-font()
            font-size: 14px
            color: rgba(255,255,255,0.65)
            &:focus, &:active
              border: 1px #6f9fae solid
        &.idi-session div[class$='content']
          font-size: 25px
        &.idi-db div[class$='content']
          font-size: 17px
        &.idi-objective div[class$='content']
          font-size: 14px
    &__shift
      display: flex
      flex-flow: column nowrap
      justify-content: center
      align-items: center
      position: absolute
      bottom: 0
      left: 0
      right: 0
      height: $double-tap-height
      &__content
        width: 150px
        position: absolute
        left: 0
        right: 0
        margin: 0px auto
        +averia-font()
        color: #c1981c
        text-align: center
        /*border: 1px transparentize(#c1981c, 0.3) solid*/
        padding: 3px
        font-size: 14px
        &:hover
          cursor: pointer
          color: lighten(#c1981c, 7%)
        &:active
          color: lighten(#c1981c, 20%)


</style>
