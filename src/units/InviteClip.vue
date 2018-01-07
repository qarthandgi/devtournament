<template lang="pug">
  .invite(:class="[create ? 'create' : 'view']")
    .invite__left-border
    .invite__create(v-if="create")
      .invite__create__label INVITE USER
      .invite__create__email
        input-field(
          id="invite-email",
          name="EMAIL",
          :hide-label="true",
          placeholder="Enter Email of User to Invite",
          @update="emailToInvite = arguments[0]",
          :font-size="'14px'"
        )
        .invite__create__email__invite
          span.text Invite&nbsp;
          span.far.fa-angle-right
    .invite__content(v-else)
      .invite__content__option
        .invite__content__option__label EMAIL
        .invite__content__option__body greghennesey@devtournament.com
      .invite__content__option
        .invite__content__option__label PROGRESS
        .invite__content__option__body Exercise Completed
      .invite__content__option
        .invite__content__option__label INVITATION SENT
        .invite__content__option__body Jan. 3, '18 10:08am
      .invite__content__option.center
        button.invite__content__option__button.gray Disable Invitation
      .invite__content__option.center
        button.invite__content__option__button.danger Delete Invitation
</template>

<script>
  import InputField from '@/blocks/InputField'

  export default {
    components: {
      InputField
    },
    props: {
      create: {required: false, default: false}
    },
    data () {
      return {
        emailToInvite: ''
      }
    }
  }
</script>

<style lang="sass">
  @import '../assets/sass/vars'

  $left-border-width: 3px

  .invite
    width: 100%
    height: 70px
    border-radius: 4px
    position: relative
    overflow: hidden
    &.view
      height: 70px
      border: 1px rgba(220,220,220,0.7) solid
    &.create
      height: 40px
      border: 1px rgba(220,220,220,0.2) solid
    &__create
      +averia-font()
      padding: 5px 20px 5px
      position: relative
      &__label
        display: none
        font-size: 10px
        color: rgba(220,220,220,0.9)
      &__email
        width: 80%
        position: relative
        /deep/ .input-c
          font-size: 15px
        &__invite
          /*border: 1px red solid*/
          position: absolute
          top: 50%
          transform: translateY(-50%)
          right: -70px
          color: $dev-blue
          cursor: pointer
          &:hover
            color: lighten($dev-blue, 20%)
          svg
            right: 0px
            transition: right 90ms linear
          &:hover svg
            position: relative
            right: -5px
            transition: right 90ms linear
    &.create &__left-border
      background-color: rgba(220,220,220,0.2)
    &:hover
      border: 1px $dev-blue solid
    &.create:hover
      border: 1px transparentize($dev-blue, 0.8) solid
    &:hover &__left-border
      background-color: $dev-blue
    &.create:hover &__left-border
      background-color: transparentize($dev-blue, 0.8)
    &:hover &__content__option__body
      color: $dev-blue
    &__left-border
      position: absolute
      left: 0
      height: 100%
      width: $left-border-width
      background-color: rgba(220,220,220,0.7)
    &__content
      position: absolute
      left: ($left-border-width + 2)
      right: 0
      bottom: 0
      top: 0
      display: grid
      grid-template-columns: repeat(12, 1fr)
      grid-gap: 4px
      &__option
        box-sizing: border-box
        grid-column: auto / span 2
        padding: 3px 3px 0px
        &.center
          text-align: center
        &:nth-child(1)
          grid-column: 1 / 8
        &:nth-child(2)
          grid-column: 8 / 13
        &:nth-child(3)
          grid-column: 1 / 7
          grid-row: 2
        &:nth-child(4)
          grid-column: 5 / 9
          grid-row: 2
        &:nth-child(5)
          grid-column: 9 / 13
          grid-row: 2
        &__label
          color: rgba(220,220,220,0.9)
          font-size: 10px
        &__body
          font-size: 13px
          text-overflow: ellipsis
          overflow: hidden
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
          &:hover
            background-color: rgba(255,255,255,0.10)
            cursor: pointer
          &:active
            background-color: rgba(200,200,200,0.10)
          &.gray
            border: 1px gray solid
            color: gray
          &.danger
            border: 1px rgba(220,80,80,0.9) solid
            color: rgba(220,80,80,0.9)

</style>
