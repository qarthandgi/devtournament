<template lang="pug">
  #app
    .bg-video
      video(autoplay, muted, loop, v-if="videoVisibility")
        source(src="/static/video/face.mp4")
    .bg(:class="{select: layoutState === 1, code: layoutState === 2}")
    app-nav(@toggle-auth="toggleAuth")
    router-view(v-if="dataLoaded")
    page-titles
    login-register(:show="authVisibility", @toggle-auth="toggleAuth")
    welcome-info-modal
    vue-snotify
</template>

<script>
  import {mapState, mapGetters, mapActions, mapMutations} from 'vuex'

  import AppNav from '@/components/AppNav'
  import LoginRegister from '@/components/LoginRegister'
  import PageTitles from '@/components/PageTitles'
  import WelcomeInfoModal from '@/components/WelcomeInfoModal'

  import {store} from '@/store/index'
  import {bus} from '@/utils/bus'

  export default {
    name: 'app',
    components: {
      AppNav,
      LoginRegister,
      PageTitles,
      WelcomeInfoModal
    },
    data () {
      return {
        authVisibility: false,
        dataLoaded: false,
        videoVisibility: false
      }
    },
    watch: {
      loggedIn () {
        this.loadData()
      },
      '$route': {
        handler (val) {
          if (val.name === 'home') {
            this.videoVisibility = true
          } else {
            this.videoVisibility = false
          }
        },
        immediate: true,
        deep: true
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
        finishVerification: state => state.user.finishVerification,
        loadingOverlay: state => state.app.loadingOverlay
      }),
      ...mapGetters({
        fullName: 'fullName'
      })
    },
    methods: {
      async loadData () {
        const loaded = await this.loadPostgres()
        if (loaded === true) { this.dataLoaded = true }
      },
      toggleAuth (signupAlert = false) {
        if (signupAlert) {
          // this.$snotify.warning('Login or Register for the full suite of features from #DevTournament!', 'Register for more!', {timeout: 7000, titleMaxLength: 22})
          this.authVisibility = !this.authVisibility
        } else {
          this.authVisibility = !this.authVisibility
        }
      },
      ...mapActions({
        getName: 'getName',
        loadPostgres: 'pg/loadPostgres'
      }),
      ...mapMutations({
        setKey: 'setKey'
      })
    },
    created () {
      this.loadData()
    },
    mounted () {
      bus.$on('activate-auth-window', this.toggleAuth)
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
