<template lang="pug">
  .inv-info
    .inv-info__body(style="color:white;")
      .inv-info__body__content.l1(style="margin-bottom: 20px;") Invitation Details for&nbsp;
        span.highlight {{invitation.invitee_s}}
      .inv-info__body__content.l2 Invitation Currently&nbsp;
        span.highlight {{invitation.enabled ? 'Enabled' : 'Disabled'}}
      button.inv-info__body__content__option.gray(@click="disableInvitation", v-if="invitation.enabled") {{ enableStatus }}
      button.inv-info__body__content__option.gray(@click="enableInvitation", v-else) {{ enableStatus }}
      .inv-info__body__content.l2(style="margin-top:10px;") Delete this invitation and all submitted query attempts?
      button.invite__content__option__button.danger(@click="deleteInvitation") Delete Invitation
      .inv-info__body__content.l2(style="margin-top: 35px;") View Last Query Submitted
      button.inv-info__body__content__option.dev(@click="showQuery('last')") Last Query
      .inv-info__body__content.l2(style="margin-top: 8px;") View Last Successfully Submitted Query
      button.inv-info__body__content__option.dev(@click="showQuery('successful')") Last Successful Query
    .inv-info__close(@click="closeInvitation")
      .inv-info__close__content
        span.fas.fa-angle-double-up
        span.inv-info__close__content__text Close
        span.fas.fa-angle-double-up
</template>

<script>
  import {mapGetters, mapMutations} from 'vuex'
  import {bus} from '@/utils/bus'

  export default {
    data () {
      return {
        customExerciseId: -1,
        invitationId: -1
      }
    },
    computed: {
      ...mapGetters({
        'getInvitation': 'pg/getInvitationById'
      }),
      invitation () {
        return this.getInvitation(this.customExerciseId, this.invitationId)
      },
      enableStatus () {
        if (this.invitation.enabled) {
          return 'Disable Invitation'
        } else if (!this.invitation.enabled) {
          return 'Enable Invitation'
        }
      }
    },
    watch: {
      '$route': {
        handler (val) {
          this.invitationId = parseInt(val.params.inviteId)
          this.customExerciseId = parseInt(val.params.id)
        },
        immediate: true,
        deep: true
      }
    },
    methods: {
      ...mapMutations({
        replaceInvitation: 'pg/replaceInvitation',
        removeInvitation: 'pg/removeInvitation'
      }),
      showQuery (type) {
        if (type === 'last') {
          bus.$emit('pg/showInvitationQuery', {type: 'last', email: this.invitation.invitee_s})
          bus.$emit('set-editor-content', this.invitation.last_query)
        } else if (type === 'successful') {
          bus.$emit('pg/showInvitationQuery', {type: 'successful', email: this.invitation.invitee_s})
          bus.$emit('set-editor-content', this.invitation.successful_query)
        }
      },
      async deleteInvitation () {
        // todo: give notice of deletion
        await this.$axios.post('delete-invitation', {
          invitationId: this.invitation.id
        })
        this.removeInvitation({invitationId: this.invitationId, customExerciseId: this.customExerciseId})
        this.closeInvitation()
      },
      closeInvitation () {
        this.$router.push({
          name: 'postgres-custom',
          params: {
            id: this.$route.params.id
          }
        })
        bus.$emit('pg/closed/InvitationInfo')
      },
      async disableInvitation () {
        const response = await this.$axios.post('disable-invitation/', {
          invitationId: this.invitation.id,
          customExerciseId: this.customExerciseId
        })
        console.log(response)
        this.replaceInvitation({invitation: response.data, customExerciseId: this.customExerciseId})
      },
      async enableInvitation () {
        const response = await this.$axios.post('enable-invitation/', {
          invitationId: this.invitation.id,
          customExerciseId: this.customExerciseId
        })
        this.replaceInvitation({invitation: response.data, customExerciseId: this.customExerciseId})
      }
    }
  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'

  .highlight
    color: $dev-blue

  .inv-info
    position: absolute
    width: 100%
    top: 0
    height: 100%
    box-sizing: border-box
    background-color: rgba(0,0,0,0.9)
    border-bottom: 4px $dev-blue solid
    display: flex
    flex-flow: column nowrap
    div
      /*border: 1px red solid*/
    &__body
      flex-grow: 1
      padding: 10px
      color: rgba(220,220,220,0.8)
      +averia-font()
      font-size: 16px
      &__content
        &.l2
          font-size: 13px
          margin-bottom: 4px
      button
        margin: 3px auto
        background-color: rgba(255,255,255,0.05)
        +averia-font()
        font-size: 10px
        width: 97px
        height: 24px
        position: relative
        top: -3px
        outline: none
        opacity: 0.75
        &:hover
          background-color: rgba(70,70,70,0.10)
          cursor: pointer
          opacity: 0.95
        &:active
          background-color: rgba(200,200,200,0.10)
        &.gray
          border: 1px gray solid
          color: gray
          &:hover
            color: lighten(gray, 25%)
        &.danger
          border: 1px rgba(220,80,80,0.9) solid
          color: rgba(220,80,80,0.9)
          &:hover
            color: lighten(rgba(230,70,70,0.9), 10%)
        &.dev
          border: 1px $dev-blue solid
          color: $dev-blue
          width: 145px
          font-size: 12px
    &__close
      flex-basis: 25px
      cursor: pointer
      &__content
        position: relative
        top: 0
        color: $dev-blue
        text-align: center
        +averia-font()
        font-size: 13px
        transition: top 75ms linear
        &__text
          margin: 0px 12px
          display: inline-block
      &:hover &__content
        top: 4px
        transition: top 75ms linear
</style>
