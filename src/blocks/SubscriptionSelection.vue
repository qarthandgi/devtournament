<template lang="pug">
  .ss
    .ss__choices
      .ss__choices__choice.premium(:class="{selected: premiumSelected}", @click="chooseSubscription('premium')")
        .ss__choices__choice__check
          img(
            :src='checkSource',
            v-if="premiumSelected"
          )
        .ss__choices__choice__text
          .line-1 Premium Subscription
          .line-2 $5/mo
      .ss__choices__choice.basic(:class="{selected: basicSelected}", @click="chooseSubscription('basic')")
        .ss__choices__choice__check
          img(
            :src='checkSource',
            v-if="basicSelected"
          )
        .ss__choices__choice__text
          .line-1 Basic Subscription
          .line-2 Free
    .ss__table
      .ss__table__title(:class="{premium: premiumSelected, basic: basicSelected}") {{ value }} Features
      .ss__table__body
        .ss__table__body__row(:class="{premium: premiumSelected, basic: basicSelected}")
          .ss__table__body__row__item.name
            span Sandbox Database
          .ss__table__body__row__item.qualify
            span.check
              img(:src="checkSource")
          .ss__table__body__row__item.description
            span Practice your skills endlessly in our database, populated with realistic data
        .ss__table__body__row
          .ss__table__body__row__item.name
            span Query Exercises
          .ss__table__body__row__item.qualify
            span.number {{animatedNumber}}
          .ss__table__body__row__item.description
            span Test your PostgreSQL querying knowledge with these fundamental exercises kdf skf dk fdkf sdf lskdjf
        .ss__table__body__row
          .ss__table__body__row__item.name
            span Custom Exercises
          .ss__table__body__row__item.qualify
            span.check(v-show="premiumSelected")
              img(:src="checkSource")
          .ss__table__body__row__item.description
            span Create your OWN exercises that you can challenge others to find a working query for (and track their progress along the way)
        .ss__table__body__row
          .ss__table__body__row__item.name
            span Be Invited
          .ss__table__body__row__item.qualify
            span.check(v-show="premiumSelected")
              img(:src="checkSource")
          .ss__table__body__row__item.description
            span Be invited to custom exercises that you can complete and prove your skills to the creator
        .ss__table__body__row
          .ss__table__body__row__item.name
            span Public Links
          .ss__table__body__row__item.qualify
            span.check(v-show="premiumSelected")
              img(:src="checkSource")
          .ss__table__body__row__item.description
            span Share your queries in our sandbox environments with anyone that you provide the public link to
    .ss__footer(v-if="false")
      .ss__footer__button(v-if="oppositeSelected", @click="changeSubscription")
        span Convert to&nbsp;
          span {{value.charAt(0).toUpperCase() + value.slice(1)}}&nbsp;
          span.fas.fa-angle-right
    .ss__premium-footer(v-if="user.subscription === 'premium'")
      .ss__premium-footer__message
        span Premium Subscription&nbsp;
        span(v-if="!user.slatedForDowngrade") Renewing&nbsp;
        span(v-else, style="color: red;") Ending&nbsp;
        span On:&nbsp;
        span {{user.subscriptionEnd.toLocaleDateString("en-US", {month: 'long', year: 'numeric', day: 'numeric'})}}
      .ss__premium-footer__message.action(@click="downgradeToBasic", v-show="!user.slatedForDowngrade && value === 'basic' ")
        span Downgrade to Basic&nbsp;
          span.arrow
            span.fas.fa-angle-right
    transition(name="descend")
      .ss__card(v-show="user.subscription === 'basic' && premiumSelected")
        form(ref="payment-form", @submit="submitStripe($event)")
          img(src=`../assets/img/stripe_compressed.png`, @click="stripeWebsite", class="stripe-img")
          .accept-terms
            span
              input(type="checkbox", v-model="termsAccepted")
            span I accept the&nbsp;
            a(href="/static/pdf/tos&pp.pdf", target="_blank")
              span Terms of Service and Privacy Policy
            span , and the&nbsp;
            a(href="/static/pdf/subscription_terms.pdf", target="_blank")
              span Subscription Terms
          .form-row
            label(for="card-element")
            div#card-element(ref="card-element")
            div#card-errors(role="alert") {{ stripeErrorMessage }}
          button(:disabled="premiumButtonDisabled") Upgrade to Premium&nbsp;
            span.fas.fa-angle-right
</template>

<script>
  import {mapState, mapMutations} from 'vuex'

  export default {
    props: {
      value: {required: false, default: 'premium'},
      premiumSelectText: {required: false, default: 'Switch to Premium'},
      basicSelectText: {required: false, default: 'Switch to Basic'}
    },
    data () {
      return {
        animatedNumber: 0,
        card: null,
        stripeErrorMessage: '',
        termsAccepted: false,
        paymentProcessing: false
      }
    },
    computed: {
      ...mapState({
        premiumExercises: state => state.pg.premiumExercises,
        nonPremiumExercises: state => state.pg.nonPremiumExercises,
        user: state => state.user.user
      }),
      premiumButtonDisabled () {
        return this.paymentProcessing || !this.termsAccepted
      },
      oppositeSelected () {
        return this.user.subscription !== this.value
      },
      premiumSelected () {
        return this.value === 'premium'
      },
      basicSelected () {
        return this.value === 'basic'
      },
      checkSource () {
        if (this.premiumSelected) {
          return '/static/img/check_gold_compressed.png'
        } else {
          return '/static/img/check_rustic_compressed.png'
        }
      }
    },
    watch: {
      value: {
        handler (val, oldVal) {
          const vm = this
          function animate () {
            // eslint-disable-next-line
            if (TWEEN.update()) {
              requestAnimationFrame(animate)
            }
          }
          // eslint-disable-next-line
          new TWEEN.Tween({tweeningNumber: (val === 'premium' ? this.nonPremiumExercises : this.premiumExercises)})
            // eslint-disable-next-line
            .easing(TWEEN.Easing.Quadratic.Out)
            .to({tweeningNumber: (val === 'premium' ? this.premiumExercises : this.nonPremiumExercises)}, 490)
            .onUpdate(function () {
              vm.animatedNumber = this.tweeningNumber.toFixed(0)
            })
            .start()
          animate()
        },
        immediate: true
      }
    },
    methods: {
      ...mapMutations({
        'changeSubscription': 'user/changeSubscription',
        'setSubscriptionEnd': 'user/setSubscriptionEnd',
        'setSlatedForDowngrade': 'user/setSlatedForDowngrade',
        'setLayoutState': 'app/setLayoutState'
      }),
      async downgradeToBasic () {
        console.log('downgrading')
        await this.$axios.post('downgrade-plan/')
        this.$toast.bottom('Downgraded to Free Basic Plan')
        this.setSlatedForDowngrade({slatedForDowngrade: true})
      },
      async submitStripe (event) {
        if (this.premiumButtonDisabled === true) {
          return
        }
        this.loadingOverlay({state: true})
        this.paymentProcessing = true
        event.preventDefault()

        const {source, error} = await this.$stripe.createSource(this.card)
        if (error) {
          console.log('Error: Stripe Create Token - $stripe.createToken')
        } else {
          this.$toast.bottom('Congratulations! You now have a Premium Subscription.')
          const {data} = await this.$axios.post('to-premium/', {
            createSource: true,
            stripeSource: source.id
          })
          this.changeSubscription({subscription: 'premium'})
          this.setSubscriptionEnd({subscriptionEnd: data['current_period_end']})
          this.paymentProcessing = false
        }
        this.loadingOverlay({state: false})
      },
      chooseSubscription (val) {
        this.$emit('input', val)
      },
      stripeWebsite () {
        window.open('https://stripe.com', '_blank')
      }
    },
    mounted () {
      const style = {
        base: {
          color: '#6f9fae',
          lineHeight: '18px',
          fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
          fontSmoothing: 'antialiased',
          fontSize: '16px',
          '::placeholder': {
            color: '#6f9fae'
          }
        },
        invalid: {
          color: '#fa755a',
          iconColor: '#fa755a'
        }
      }
      this.card = this.$elements.create('card', {style})
      this.card.mount(this.$refs['card-element'])

      this.card.addEventListener('change', ({error}) => {
        if (error) {
          this.stripeErrorMessage = error.message
        } else {
          this.stripeErrorMessage = ''
        }
      })
    },
    beforeDestroy () {
      this.card.destroy()
      this.$emit('reset')
    }
  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'

  .ss
    &__choices
      width: 100%
      display: flex
      justify-content: space-around
      &__choice
        width: 215px
        border: 1px transparent solid
        border-radius: 6px
        height: 60px
        display: flex
        flex-flow: column nowrap
        justify-content: center
        position: relative
        cursor: pointer
        opacity: 0.65
        &:hover
          opacity: 0.85
        &__check
          position: absolute
          width: 15px
          bottom: 1px
          right: 6px
          img
            width: 100%
        &.premium
          background-color: transparentize(#c1981c, 0.88)
          border: 1px #c1981c solid
          color: #c1981c
          &.selected
            opacity: 1
        &.basic
          background-color: transparentize(#898672, 0.88)
          border: 1px #898672 solid
          color: #898672
          &.selected
            opacity: 1
        &__text
          +averia-font()
          font-size: 14px
          .line-1
            margin-bottom: 4px
    &__table
      margin-top: 9px
      &__title
        text-align: left
        +averia-font()
        font-size: 13px
        &.premium
          color: #c1981c
        &.basic
          color: #898672
        &:first-letter
          text-transform: capitalize
      &__body
        &__row
          border-top: 1px #b3b3b3 solid
          display: flex
          flex-flow: row nowrap
          justify-content: left
          color: #d8d8d8
          height: 35px
          &.premium
            border-top: 1px #c1981c solid
          &.basic
            border-top: 1px #898672 solid
          &__item
            display: flex
            flex-flow: column nowrap
            justify-content: center
            /*border: 1px blue solid*/
            text-align: left
            &.name
              font-size: 14px
              width: 120px
              flex-shrink: 0
            &.qualify
              width: 30px
              text-align: center
              margin: auto 8px
              border-left: 1px #666767 solid
              border-right: 1px #666767 solid
              align-self: center
              /*border: 1px blue solid*/
              height: 100%
              flex-shrink: 0
              span.number
                font-size: 16px
              img
                width: 13px
                position: relative
                top: -2px
            &.description
              font-size: 12px
    &__footer
      margin-top: 6px
      height: 28px
      position: relative
      box-sizing: border-box
      &__button
        box-sizing: border-box
        height: 100%
        width: 180px
        /*border: 1px red solid*/
        position: absolute
        right: 0
        font-size: 14px
        text-align: center
        display: flex
        flex-flow: column nowrap
        justify-content: center
        border: 1px $dev-blue solid
        cursor: pointer
        &:hover
          background-color: rgba(220,220,220,0.05)
        .premium
          color: #c1981c
        .basic
          color: #898672
    &__premium-footer
      margin-top: 15px
      text-align: left
      font-size: 15px
      display: flex
      justify-content: space-between
      .arrow
        position: relative
        top: 2px
      .action:hover
        cursor: pointer
        color: lighten($dev-blue, 24%)
    &__card
      position: relative
      max-height: 29px
      margin-top: 15px
      /*overflow: hidden*/
      form
        position: relative
        display: flex
        flex-flow: row nowrap
        color: white
        .accept-terms
          position: absolute
          bottom: -55px
          right: 0
          text-align: right
          font-size: 12px
          a
            color: $dev-blue
        .stripe-img
          position: absolute
          bottom: -35px
          opacity: 0.6
          cursor: pointer
        .form-row
          width: 71%
          label
            font-size: 12px
            text-align: left
          #card-errors
            position: absolute
            bottom: -25px
            left: 130px
            text-align: right
            color: $danger-red
            font-size: 15px
        button
          width: 160px
          border: 1px #c1981c solid
          cursor: pointer
          background-color: transparent
          height: 40px
          +averia-font()
          font-size: 14px
          text-align: center
          color: #c1981c
          position: absolute
          right: 0
          &:hover
            background-color: transparentize(#c1981c, 0.9)
          &[disabled='disabled']
            color: gray
            border: 1px gray solid
            cursor: not-allowed
            &:hover
              background-color: transparent

</style>
