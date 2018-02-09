<template lang="pug">
  .input
    .top-panel.darker
    .bottom-panel.darker
    .input__editor
      editor(
        :content="l_sql",
        :sync="custom || company",
        :width="'100%'",
        :height="'100%'",
        :lang="'sql'",
        @editor-update="update($event)",
        @selection-update="$emit('selection-update', $event)"
      )
    .input__overlay(v-if="overlayVisibility && custom")
      .input__overlay__headline You are viewing a custom exercise that you created
      button.input__overlay__option(@click="selectOption(true)") Show Original Query
      span &nbsp;&nbsp;&nbsp;&nbsp;
      button.input__overlay__option(@click="selectOption(false)") Do Not Show Original Query
      .input__overlay__footer (You Can Change This Later at the Top Right of this Panel)
    .input__switch(v-if="custom && switcherReady")
      .input__switch__option.invitation(v-if="showingInvitationQuery")
        span Showing {{ invitationType }} query from {{ invitationEmail }}
        span
      .input__switch__option(v-else-if="!originalQueryVisibility", @click="selectOption(true)") Show Original Query
      .input__switch__option(v-else, @click="selectOption(false)") Show Blank Query
</template>

<script>
  import editor from '@/plugins/ace'
  import 'brace/mode/sql'
  import 'brace/theme/chrome'
  import {bus} from '@/utils/bus'

  export default {
    components: {
      editor
    },
    props: {
      custom: {required: false, default: false},
      company: {required: false, default: false},
      sql: {required: false, default: ''}
    },
    data () {
      return {
        overlayVisibility: false,
        l_sql: '',
        originalQueryVisibility: false,
        switcherReady: false,
        showingInvitationQuery: false,
        invitationType: '',
        invitationEmail: ''
      }
    },
    methods: {
      update (event) {
        this.l_sql = event
        this.$emit('update', event)
      },
      selectOption (show) {
        this.l_sql = show ? this.sql : ''
        this.originalQueryVisibility = show
        this.overlayVisibility = false
        this.switcherReady = true
      }
    },
    invitationQuery (query) {
      console.log(query)
    },
    mounted () {
      console.log('MOUNTED')
      if (this.custom) {
        this.overlayVisibility = true
      }
      bus.$on('pg/completed/exercise', () => {
        this.$set(this, 'l_sql', '')
      })
      bus.$on('pg/showInvitationQuery', (obj) => {
        this.l_sql = obj.query
        this.showingInvitationQuery = true
        this.invitationType = obj.type
        this.invitationEmail = obj.email
        this.overlayVisibility = false
        this.switcherReady = true
      })
      bus.$on('pg/closed/InvitationInfo', () => {
        this.showingInvitationQuery = false
        this.selectOption(false)
      })
    }
  }
</script>

<style lang="sass">
  @import '../assets/sass/vars'

  .input
    height: 100%
    position: relative
    &__editor
      padding: $border-panel-height 0
      width: 100%
      height: 100%
      box-sizing: border-box
    &__overlay
      position: absolute
      top: $border-panel-height
      left: 0
      right: 0
      bottom: $border-panel-height
      background-color: transparentize($dark-border, 0.1)
      z-index: 5
      color: $dev-blue
      font-size: 18px
      padding: 20px
      text-align: center
      +averia-font()
      &__headline
        margin-bottom: 25px
      button
        font-size: 13px
        display: inline-block
        border: 1px $dev-blue solid
        border-radius: 4px
        background-color: rgba(180,180,180,0.1)
        margin-bottom: 20px
        color: $dev-blue
        cursor: pointer
        +averia-font()
        transition: all 60ms linear
        outline: none
        &:hover
          background-color: $dev-blue
          color: white
          transition: all 60ms linear
        &:active
          background-color: darken($dev-blue, 10%)
      &__footer
        margin-top: 40px
        font-size: 12px
    &__switch
      top: -20px
      right: 0
      width: auto
      +averia-font()
      font-size: 13px
      color: $dev-blue
      text-align: right
      position: absolute
      cursor: pointer
      &:hover
        color: darken($dev-blue, 10%)
      &__option
        padding: 1px 7px
        border-radius: 2px
      &__option.invitation
        cursor: default
        background-color: $dev-blue
        color: white

</style>
