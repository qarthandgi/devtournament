<template lang="pug">
  .wi
    .wi__welcome
      span Welcome to #DevTournament::PostgreSQL!
    .wi__sub-welcome
      span What you'll find here:
    .wi__section
      .wi__section__title
        span Exercises
      .wi__section__description
        span <span class="gold">40+ Professionally-crafted</span> exercises, designed to expand your knowledge and abilities in PostgreSQL quicker than ever.
    .wi__section
      .wi__section__title
        span Sandbox
      .wi__section__description
        span Enjoy a worry-free sandbox to test PostgreSQL queries with a <span class="gold">realistic data set</span> and a sophisticated environment.
    .wi__section
      .wi__section__title
        span Custom Exercises
      .wi__section__description
        span Create an exercise by crafting your own query, and <span class="gold">challenge others</span> to recreate the exact results (rows) with their own query.
</template>

<script>
  export default {

  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'

  .wi
    +averia-font()
    &__welcome
      font-size: 24px
      color: $captive-gold
    &__sub-welcome
      font-size: 17px
      color: $dev-blue
      margin-bottom: 45px
    &__section
      margin-bottom: 27px
      &__title
        margin-bottom: 6px
        span
          border: 1px $captive-gold solid
          border-radius: 5px
          padding: 1px 6px
          color: $captive-gold
          font-size: 17px
      &__description
        color: $sahara-sand
        font-size: 14px
        .gold
          color: $captive-gold
</style>
