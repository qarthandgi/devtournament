<template lang="pug">
  modal-window(v-if="show", :success-panels="successPanels")
    .close(@click='closeModal', v-if="notLoggedInState !== 3")
      span.fas.fa-times-circle
    .content(v-if="!loggedIn || notLoggedInState === 3 || interim")
      template(v-if="notLoggedInState === 0")
        .headings(v-if="verifiedState")
          .headings__title.success Thank you for verifying your email!
          .headings__sub-title Login to Complete Registration
        .headings
          .headings__title LOGIN
          //.headings__sub-title Enter email to begin.
        .form
          input-field(
            id="login-email-input",
            name="email",
            @update="updateLogin('username', $event)",
            @enter="updateLogin('username', $event, true)",
            :reuse-key="'login-email-input'"
          )
          input-field(
            id="login-password-input",
            name="password",
            :password="true",
            @update="updateLogin('password', $event)",
            @enter="updateLogin('password', $event, true)",
            :reuse-key="'login-password-input'"
          )
          .headings
            .headings__sub-title.select(style="margin-top: 35px;", @click=`sendLogin`) Login
          //img(src="../assets/img/LoginRegister/right-arrow.png", class="login-arrow", @click="sendLogin(user)")
        .headings(style="margin-top: 50px;")
          .headings__title REGISTER
          //.headings__sub-title Click to register a new account.
          .headings__sub-title.select(style="margin-top: 30px;", @click="changeNotLoggedInState(1)") Register for a new account&nbsp;&nbsp;
            span.fas.fa-angle-right
      template(v-else-if="notLoggedInState === 1")
        .headings(style='margin-top:1px;')
          .headings__title REGISTER
        .form
          input-field(
            id="register-email-input",
            name="email",
            @update=`updateRegister('email', $event)`,
            :reuse-key="'register-email-input'",
            @click="sendRegister"
          )
          input-field(
            id="register-username-input",
            name="username",
            @update=`updateRegister('username', $event)`,
            :reuse-key="'register-username-input'",
            @click="sendRegister"
          )
          input-field(
            style="margin-top:46px",
            id="register-password1-input",
            name="password",
            :password="true",
            @update=`updateRegister('password1', $event)`,
            :reuse-key="'register-password1-input'",
            @click="sendRegister"
          )
          input-field(
            id="register-password2-input",
            name="confirm password",
            :password="true",
            @update=`updateRegister('password2', $event)`,
            :reuse-key="'register-password2-input'",
            @click="sendRegister"
          )
          .headings
            .headings__sub-title.select(style="margin-top: 50px;", @click="sendRegister") Register
            .headings__sub-title.footer(@click=`changeNotLoggedInState(0)`)
              span.fas.fa-angle-left
              span.text Login
      template(v-else-if="notLoggedInState === 2")
        .headings
          .headings__title SUCCESS
        .body
          .success
            span.far.fa-check-circle.check-circle
            div.break
            span.check-message Successfully Registered
          .verify
            span.fas.fa-exclamation-triangle
            div.break
            span.verify-message Click the activation link in the email sent to {{newUser.email}} to complete registration
      template(v-else-if="notLoggedInState === 3")
        .headings
          .headings__title
        .body
          .success
            span.far.fa-check-circle.check-circle
            div.break
            span.check-message Successfully Logged in
      template(v-else-if="notLoggedInState === 4")
        .headings
          .headings__title
            span Welcome to #DevTournament!
        .body
          subscription-selection(v-model="selectedSubscription")
    .content(v-else)
      .headings
        .headings__title SUBSCRIPTION
        .headings__sub-title You're currently on the {{user.subscription.toUpperCase()}} subscription
      .body(style="margin-top:30px;margin-bottom:70px;")
        subscription-selection(v-model="selectedSubscription", @change="changeSubscription", @reset="resetSubscription")
      .headings
        .headings__title LOGOUT
        .headings__sub-title.select(@click="logout", style="margin-top: 20px;") End your session

</template>

<script>
  import ModalWindow from '@/blocks/ModalWindow'
  import InputField from '@/blocks/InputField'
  import SubscriptionSelection from '@/blocks/SubscriptionSelection'
  import {mapActions, mapState} from 'vuex'

  export default {
    components: {
      ModalWindow,
      InputField,
      SubscriptionSelection
    },
    props: {
      show: {required: true}
    },
    data () {
      return {
        returningUser: {
          username: '',
          password: ''
        },
        newUser: {
          email: '',
          username: '',
          password1: '',
          password2: ''
        },
        notLoggedInState: 0, // different screen states only when the user is not already logged in
        successPanels: false, // used to set border panels to green on successful login or successful registration
        l_selectedSubscription: '',
        verifiedState: false,
        interim: false
      }
    },
    watch: {
      show (newState) {
        this.changeNotLoggedInState(0)
        this.successPanels = false
        this.selectedSubscription = this.user.subscription
      },
      '$route.query': {
        handler (val) {
          if (val.verified === 'true' || val.verified === true) {
            this.verifiedState = true
          } else {
            this.verifiedState = false
          }
        },
        immediate: true,
        deep: true
      }
    },
    computed: {
      ...mapState({
        loggedIn: state => state.user.loggedIn,
        user: state => state.user.user
      }),
      selectedSubscription: {
        get () {
          if (this.l_selectedSubscription) {
            return this.l_selectedSubscription
          } else if (this.loggedIn) {
            return this.user.subscription
          } else {
            return 'basic'
          }
        },
        set (value) {
          this.$set(this, 'l_selectedSubscription', value)
        }
      }
    },
    methods: {
      ...mapActions({
        login: 'user/login',
        testLogin: 'user/testLogin',
        logout: 'user/logout',
        register: 'user/register'
      }),
      resetSubscription () {
        this.selectedSubscription = this.user.subscription
      },
      changeSubscription () {
        console.log('in change subscription')
      },
      closeModal () {
        this.$emit('toggle-auth')
      },
      changeNotLoggedInState (state) {
        this.notLoggedInState = state
      },
      changeToState3 () {
        this.changeNotLoggedInState(3)
        setTimeout(() => {
          this.$emit('toggle-auth')
        }, 1800)
      },
      async sendLogin () {
        this.interim = true
        const resp = await this.login(this.returningUser)
        console.log('OK NOW HERE')
        console.log(resp)
        if (resp.success) {
          console.log('TODO: make success message')
          this.successPanels = true
          this.changeToState3()
          this.interim = false
        } else {
          console.log('TODO: in component and wrong credentials')
        }
      },
      async sendRegister () {
        const success = await this.register(this.newUser)
        if (success) {
          console.log('TODO: make successful registration')
          this.changeNotLoggedInState(2)
        } else {
          console.log('TODO: registration unsuccessful')
        }
      },
      updateLogin (...args) {
        // args[0] is the field name (eg. username)
        // args[1] is the actual value from the field
        // args[2] is if true was set on the call to also send login request
        this.$set(this.returningUser, args[0], args[1])
        if (args[2]) {
          this.sendLogin()
        }
      },
      updateRegister (...args) {
        this.$set(this.newUser, args[0], args[1])
      }
    },
    mounted () {
      this.selectedSubscription = this.user.subscription
    },
    updated () {
      console.log('updated')
    }
  }
</script>

<style lang="sass">
  @import '../assets/sass/vars'

  .close
    position: absolute
    top: 15px
    right: 10px
    color: white
    padding: 5px
    cursor: pointer
    font-size: 18px
    &:hover
      color: $warning-yellow
  .headings
    margin-bottom: 19px
    +averia-font()
    .headings__title
      +text-normal-white(1.0)
      font-size: 20px
      margin-bottom: 5px
      &.success
        color: $success-green
    .headings__sub-title
      +text-normal-white(0.8)
      font-size: 12px
      color: $light-border
      &.select
        border: 1px $light-border solid
        padding: 8px
        max-width: 160px
        text-align: center
        cursor: pointer
        &:hover
          background-color: transparentize($light-border, 0.85)
        &:active
          background-color: transparentize($light-border, 0.80)
          border: 1px darken($light-border, 12%) solid
      &.footer
        cursor: pointer
        position: absolute
        bottom: 20px
        font-size: 14px
        padding: 8px 8px 8px 0px
        .text
          position: relative
          margin-left: 3px
          transition: margin-left 80ms linear
        &:hover .text
          margin-left: 8px
          transition: margin-left 80ms linear
  .form
    width: 320px
    .login-arrow
      margin-top: 20px
      cursor: pointer
      opacity: 0.85
      transition: opacity 30ms linear
      &:hover
        opacity: 1
        transition: opacity 30ms linear
  .body
    /*border: 1px red solid*/
    margin-top: 80px
    text-align: center
    color: $light-border
    font-size: 24px
    +averia-font()
    .success
      color: $success-green
      margin-bottom: 60px
      .break
        margin-bottom: 15px
      .check-circle
        font-size: 50px
      .check-message
        font-size: 20px
    .verify
      color: #8e8853
      font-size: 22px
      .verify-message
        font-size: 14px

</style>
