<template lang="pug">
  .info(:class="{'to-bottom': toBottomClass}")
    .info__check(v-if="checkVisibility", :class="{success: successStatus}")
      span.fas.fa-check-circle
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
      .info__details__item.idi-public(v-if="sessionType === 'sandbox'")
        .info__details__item__label PUBLIC LINK
        .info__details__item__content
          .info__details__item__content__public-button(v-if="publicButtonVisibility", @click="createPublic")
            span.unhovered Create Public Link
            span.hovered
              template(v-if="loggedIn && isPremium")
                span Create Public Link
              template(v-else-if="loggedIn && !isPremium")
                span(style="color: #c1981c;")
                  i.fas.fa-lock-alt
                span &nbsp; Upgrade to Premium
              template(v-else)
                span(style="color: #c1981c;")
                  i.fas.fa-lock-alt
                span &nbsp; Login or Register
          input.info__details__item__content__public-link(v-else, :value="publicUrl")
      .info__details__item.idi-requirements(v-if="mode === 'edit' || custom || invitation || sessionType === 'company'")
        .info__details__item__label OUTPUT REQUIREMENTS
        .info__details__item__content
          .info__details__item__content__toggle(v-if="custom", @click="outputColumnsVisibility = !outputColumnsVisibility") Toggle Output Requirements
          output-columns(
            v-show="outputColumnsVisibility || mode === 'edit'",
            @defined-headers="definedHeaders = arguments[0]",
            @columns="definedColumns = arguments[0]",
            :json-columns="sessionInfo.column_descriptions || ''",
            :custom-view="mode === 'view' && (custom || invitation || sessionType === 'company')"
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
    .info__validation-message
      .info__validation-message__content(v-if="invalidCreation") {{ invalidMessage }}
    .info__shift(v-if="true")
      .info__shift__content(v-if="false") {{ doubleShiftMessage }}
      .info__shift__content(v-if="mode === 'edit'", @click="createExercise", :class="{invalid: invalidCreation}") Create Exercise
</template>

<script>
  import InputField from '@/blocks/InputField'
  import OutputColumns from '@/blocks/OutputColumns'
  import InviteClip from '@/units/InviteClip'

  import {mapState} from 'vuex'
  import {bus} from '@/utils/bus'

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
      custom: {required: false, default: false},
      invitation: {required: false, default: false},
      successStatus: {required: false, default: false},
      sessionType: {required: false, default: null},
      sql: {required: false, default: ''},
      invalidCreation: {required: false, default: false},
      invalidMessage: {required: false, default: ''}
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
        outputColumnsVisibility: false,
        publicUrl: '',
        publicButtonVisibility: true
      }
    },
    computed: {
      ...mapState({
        databases: state => state.pg.databases,
        loggedIn: state => state.user.loggedIn,
        isPremium: state => state.user.user.subscription === 'premium'
      }),
      toBottomClass () {
        return this.sessionType === 'custom-create'
      },
      checkVisibility () {
        return this.sessionType !== 'sandbox' && this.sessionType !== 'custom-create'
      },
      invitations () {
        return this.sessionInfo.invitation_set
      },
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
      // TODO: really best implementation here?
      invitation: {
        handler (val) {
          this.outputColumnsVisibility = true
        },
        immediate: true
      },
      sessionType: {
        handler (val) {
          if (val === 'company') {
            this.outputColumnsVisibility = true
          }
        },
        immediate: true
      },
      'newExercise.database': {
        handler (val) {
          this.$emit('db-change', val)
        }
      },
      newExercise: {
        handler (val) {
          this.$emit('new-exercise-data', val)
        },
        immediate: true,
        deep: true
      },
      headers (val) {
        this.checkHeaders()
      },
      definedHeaders (val) {
        this.checkHeaders()
      }
    },
    methods: {
      async createPublic () {
        if (this.loggedIn && this.isPremium) {
          const {data} = await this.$axios.post('create-public/', {
            sql: this.sql
          })
          const sharedId = data.id
          const url = 'https://devtournament.com/postgresql/sandbox/' + this.$route.params.id.toString() + '/public/' + sharedId.toString()
          this.publicUrl = url
          this.publicButtonVisibility = false
        } else if (this.loggedIn && !this.isPremium) {
          bus.$emit('activate-auth-window')
        } else {
          bus.$emit('activate-auth-window')
        }
      },
      createExercise () {
        if (this.invalidCreation) {
          return false
        } else {
          this.$emit('create', {...this.newExercise, columnDescriptions: JSON.stringify(this.definedColumns)})
        }
      },
      selectDb (db) {
        this.$set(this.newExercise, 'database', db.id)
      },
      checkHeaders () {
        if (this.headers.length === 0 && this.definedHeaders.length === 0) {
          this.$emit('headers-match', false)
        } else {
          const match = this._.isEqual(this.headers, this.definedHeaders)
          this.$emit('headers-match', match)
        }
      }
    },
    mounted () {
      this.selectDb(this.databases[0])
      bus.$on('pg/received/publicSandbox', (obj) => {
        this.authorForPublic = true
      })
      bus.$on('pg/updated/CodingInput', () => {
        this.publicButtonVisibility = true
      })
    }
  }
</script>


<style lang="sass" scoped>
  @import '../assets/sass/vars'
  $double-tap-height: 20px

  .info
    position: absolute
    top: 0
    bottom: 40px
    left: 0
    right: 0
    padding: 20px
    box-sizing: border-box
    overflow: scroll
    &.to-bottom
      bottom: 0px
    &__check
      position: absolute
      top: 12px
      right: 12px
      color: rgba(220,220,220,0.45)
      font-size: 38px
      &.success
        color: $success-green
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
          &__public-button
            width: 155px
            border-radius: 5px
            padding: 7px
            height: 17px
            border: 1px $dev-blue solid
            color: $dev-blue
            font-size: 14px
            text-align: center
            transition: all 140ms linear
            cursor: pointer
            position: relative
            overflow: hidden
            &:hover
              color: white
              border: 1px white solid
              transition: all 140ms linear
            .hovered
              display: none
            &:hover .unhovered
              display: none
            &:hover .hovered
              display: block
          &__public-link
            width: 90%
            height: 25px
            background-color: transparent
            outline: none
            border: 1px $dev-blue solid
            color: $dev-blue
            +averia-font()
            font-size: 14px
            padding-left: 3px
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
      /*position: absolute*/
      /*bottom: 0*/
      /*left: 0*/
      /*right: 0*/
      height: $double-tap-height
      /*border: 1px red solid*/
      &__content
        width: 150px
        position: absolute
        left: 0
        right: 0
        margin: 0px auto
        border: 1px #c1981c solid
        border-radius: 5px
        +averia-font()
        color: #c1981c
        text-align: center
        /*border: 1px transparentize(#c1981c, 0.3) solid*/
        padding: 4px
        font-size: 15px
        &.invalid
          color: gray
          border: 1px gray solid
          cursor: not-allowed
        &:hover:not(.invalid)
          cursor: pointer
          color: lighten(#c1981c, 9%)
          background-color: rgba(255,255,255,0.05)
        &:active:not(.invalid)
          color: lighten(#c1981c, 20%)
    &__validation-message
      color: rgba(220,80,80,0.8)
      text-align: center
      +averia-font()
      margin: 10px auto 15px
      font-size: 13px
      position: relative
      height: 20px
      /*border: 1px red solid*/
      &__content
        position: absolute
        text-align: center
        top: 0
        left: 0
        right: 0


</style>
