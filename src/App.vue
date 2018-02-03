<template lang="pug">
  #app
    .bg(:class="{select: layoutState === 1, code: layoutState === 2}")
    app-nav(@toggle-auth="toggleAuth")
    router-view(v-if="dataLoaded")
    page-titles
    login-register(:show="authVisibility", @toggle-auth="toggleAuth")
</template>

<script>
  import {mapState, mapGetters, mapActions, mapMutations} from 'vuex'
  import AppNav from '@/components/AppNav'
  import LoginRegister from '@/components/LoginRegister'
  import PageTitles from '@/components/PageTitles'

  import {store} from '@/store/index'

  export default {
    name: 'app',
    components: {
      AppNav,
      LoginRegister,
      PageTitles
    },
    data () {
      return {
        authVisibility: false,
        dataLoaded: false
      }
    },
    watch: {
      loggedIn () {
        this.loadData()
      },
      finishVerification: {
        handler (val) {
          if (val === true) {
            this.$toast.center('Verified! Login to complete registration')
            this.authVisibility = true
            store.commit('user/setFinishVerification', {finishVerification: false})
          }
        },
        immediate: true,
        deep: true
      }
      // '$route.meta': {
      //   handler (val) {
      //     if (val.verified === true) {
      //       this.authVisibility = true
      //     }
      //   },
      //   immediate: true,
      //   deep: true
      // }
    },
    computed: {
      ...mapState({
        layoutState: state => state.app.layoutState,
        loggedIn: state => state.user.loggedIn,
        finishVerification: state => state.user.finishVerification
      }),
      ...mapGetters({
        fullName: 'fullName'
      })
    },
    created () {
      this.loadData()
    },
    methods: {
      async loadData () {
        const loaded = await this.loadPostgres()
        if (loaded === true) { this.dataLoaded = true }
      },
      toggleAuth () {
        this.authVisibility = !this.authVisibility
      },
      ...mapActions({
        getName: 'getName',
        loadPostgres: 'pg/loadPostgres'
      }),
      ...mapMutations({
        setKey: 'setKey'
      })
    }
  }
</script>

<style lang="sass">
  @import 'assets/sass/app'

  #app
    min-height: 100%

  li
    color: red
</style>
