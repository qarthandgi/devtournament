<template lang="pug">
  .clip(:class="{create, 'no-pointer': noPointer, success: successStatus}", @click="selectClip")
    .clip__locked(@click="activateAuthWindow", v-if="locked")
      .clip__locked__icon
        span.fas.fa-lock-alt
      .clip__locked__message(v-if="loggedIn")
        span Upgrade to&nbsp;
        span(style="color: #c1981c") Premium
      .clip__locked__message(v-else)
        span Login or Register
    .clip__invite(v-if="invite && item.status === 'pending'")
      .clip__invite__text(style="margin-top:8px;") {{this.item.exercise.name}}
      .clip__invite__text
        span You've been invited by&nbsp;
        span.highlight {{this.item.inviter.email}}&nbsp;
        span to participate in a custom exercise they created for you.
      .clip__invite__buttons
        .clip__invite__buttons__option.decline(@click="rsvpInvitation(false)") Decline
        .clip__invite__buttons__option.accept(@click="rsvpInvitation(true)") Accept
    .clip__number-bg(v-if="!create", :class="{success: successStatus}")
    .clip__number(v-if="!create") {{ seq }}
    .clip__body
      .clip__body__title(:class="{create}")
        span.clip__body__title__text {{ nameText }}
      .clip__body__sub-title
        span.clip__body__sub-title__text {{ subTitleText }}
    .clip__footer(:class="[footerClass]") {{ footerText }}
</template>

<script>
  import {mapState, mapMutations} from 'vuex'
  import {bus} from '@/utils/bus'

  export default {
    props: {
      seq: {required: false},
      item: {required: false},
      create: {required: false, default: false},
      custom: {required: false, default: false},
      invite: {required: false, default: false},
      company: {required: false, default: false}
    },
    computed: {
      ...mapState({
        'databases': state => state.pg.databases,
        'loggedIn': state => state.user.loggedIn,
        user: state => state.user.user
      }),
      footerClass () {
        if (this.company) {
          if (this.item.last_successful_completion) {
            return 'success'
          } else {
            return 'danger'
          }
        }
      },
      locked () {
        if (this.company) {
          if (this.item.needed_subscription === null) {
            return false
          } else if (this.item.needed_subscription === 'basic' && this.loggedIn) {
            return false
          } else if (this.item.needed_subscription === 'premium' && this.user.subscription === 'premium') {
            return false
          } else {
            return true
          }
        } else if (this.create) {
          if (this.user.subscription === 'premium') {
            return false
          } else {
            return true
          }
        }
      },
      successStatus () {
        if ((!this.create) && this.item.status && (!this.company)) {
          return this.item.status === 'successfully completed'
        } else if (this.company) {
          return !!this.item.last_successful_completion
        } else {
          return false
        }
      },
      noPointer () {
        return this.invite && this.item.status === 'pending'
      },
      nameText () {
        if (this.create) {
          return 'Create a Custom Exercise'
        } else if (this.custom || this.company) {
          return this.item.name
        } else if (this.invite) {
          return this.item.exercise.name
        } else {
          return 'Exercise'
        }
      },
      subTitleText () {
        if (this.create) {
          return 'Invite Others to Complete'
        } else if (this.custom || this.company) {
          const dbIdx = this.databases.findIndex(x => x.id === this.item.db)
          return this.databases[dbIdx].full_name
        } else if (this.invite) {
          const dbIdx = this.databases.findIndex(x => x.id === this.item.exercise.db)
          return this.databases[dbIdx].full_name
        } else {
          return ''
        }
      },
      footerText () {
        if (this.custom) {
          const num = this.item.invitation_set.length
          return `${num} User${num === 1 ? ' has' : 's Have'} Been Invited`
        } else if (this.invite) {
          const inviter = this.item.inviter.email
          return `Invitation sent by ${inviter}`
        } else if (this.company) {
          if (this.item.last_successful_completion) {
            return 'Successfully Completed'
          } else {
            return ''
          }
        }
      }
    },
    methods: {
      ...mapMutations({
        'replaceInvite': 'pg/replaceInvite',
        'removeInvite': 'pg/removeInvite'
      }),
      activateAuthWindow () {
        console.log('activating')
        bus.$emit('activate-auth-window')
      },
      async rsvpInvitation (accepted) {
        const response = await this.$axios.post('rsvp-invitation', {
          accepted,
          invitationId: this.item.id
        })
        if (accepted) {
          this.replaceInvite({invitation: response.data})
        } else {
          this.removeInvite({invitationId: this.item.id})
        }
      },
      selectClip () {
        this.$emit('select', this.create ? 'create' : this.item)
      }
    }
  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'

  .clip
    width: 315px
    height: 132px
    border: 1px #666767 solid
    background-color: rgba(232, 232, 232, 1)
    border-radius: 3px
    overflow: hidden
    position: relative
    cursor: pointer
    box-sizing: border-box
    margin-bottom: 15px
    &.success
      border: 1px $success-green solid
    &.no-pointer
      cursor: default
    &.create
      border: 1px #666767 dashed
    &:hover
      background-color: rgba(221, 221, 221, 0.6)
    &__locked
      position: absolute
      top: 0
      left: 0
      right: 0
      bottom: 0
      background-color: rgba(228,228,228,0.9)
      border: 2px white solid
      z-index: 8
      text-align: center
      color: gray
      font-size: 19px
      &__icon
        position: relative
        top: 40%
        color: #c1981c
        opacity: 0.65
        transition: opacity 80ms linear
      &:hover .clip__locked__icon
        opacity: 0.99
        transition: opacity 170ms linear
      &__message
        position: relative
        top: 44%
        span
          font-size: 16px
          color: black
          +averia-font()
    &__invite
      position: absolute
      top: 0
      left: 0
      width: 100%
      height: 100%
      background-color: rgba(30, 30, 30, 0.97)
      z-index: 10
      text-align: center
      &__text
        margin: 15px auto 5px
        width: 80%
        +averia-font()
        font-size: 13px
        color: rgba(220,220,220,0.8)
        .highlight
          color: $dev-blue
      &__buttons
        width: 70%
        /*border: 1px red solid*/
        margin: 10px auto
        height: 23px
        display: flex
        justify-content: space-between
        &__option
          width: 85px
          line-height: 22px
          +averia-font()
          font-size: 13px
          color: rgba(220,220,220,0.9)
          /*border: 1px green solid*/
          box-sizing: border-box
          &.decline
            border: 1px rgba(220,80,80,0.8) solid
            color: rgba(220,80,80,0.8)
          &.accept
            border: 1px rgba(80, 220, 80, 0.8) solid
            color: rgba(80, 220, 80, 0.8)
          &:hover
            background-color: rgba(255,255,255,0.05)
            cursor: pointer
          &:active
            background-color: rgba(255,255,255,0.02)
    &__number-bg
      width: 100px
      height: 100px
      background-color: #646464
      position: absolute
      top: -64px
      left: -64px
      transform: rotateZ(45deg)
      &.success
        background-color: $success-green
    &__number
      position: absolute
      top: 3px
      left: 8px
      color: #e8e8e8
      +averia-font()
      font-size: 15px
    &__body
      /*text-align: center*/
      display: flex
      flex-flow: column nowrap
      justify-content: center
      align-items: center
      /*border: 1px green solid*/
      height: 80%
      +averia-font()
      &__title
        /*border: 1px red solid*/
        font-size: 17px
        opacity: 0.9
        &.create
          margin: -10px auto 10px
      &__sub-title
        font-size: 14px
        opacity: 0.65
    &__footer
      /*border: 1px red solid*/
      text-align: center
      +averia-font()
      font-size: 13px
      color: rgba(95,95,95,1)
      &.danger
        color: darken(rgba(220,80,80,0.8), 9%)
      &.success
        color: $success-green

</style>
