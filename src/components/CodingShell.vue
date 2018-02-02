<template lang="pug">
  .code(@keyup="testKey")
    .code__info(:class="{'hide-overflow': $route.name === 'postgres-custom-invitation'}")
        coding-info(
          :session-info="sessionInfo",
          :mode="mode",
          @db-change="setDb",
          :headers="tableData.headers",
          @headers-match="headersMatch = arguments[0]",
          @create="createExercise",
          :custom="$route.meta.hasOwnProperty('type') && $route.meta.type === 'custom'",
          :invitation="$route.meta.hasOwnProperty('type') && $route.meta.type === 'invitation'",
          :success-status="successStatus",
          :session-type="sessionType",
          :sql="sql"
        )
        info-action(
          v-if="infoActionVisibility",
          @select="toggleTable",
          :user-table-visibility="showingUserTable",
          :success-status="successStatus",
        )
        transition(appear)
          router-view
    .code__io
      .code__io__input
        coding-input(
          @update="updateInput",
          :custom="$route.meta.hasOwnProperty('type') && $route.meta.type === 'custom'",
          :sql="sessionInfo.working_query",

        )
      .code__io__status
        coding-status
      .code__io__output
        coding-output(
          :headers="outputHeaders",
          :rows="outputRows",
        )
</template>

<script>
  import CodingInput from '@/components/CodingInput'
  import CodingOutput from '@/components/CodingOutput'
  import CodingStatus from '@/units/CodingStatus'
  import CodingInfo from '@/components/CodingInfo'
  import InfoAction from '@/units/InfoAction'

  import {mapState, mapMutations} from 'vuex'
  import {sandboxInit, tableData} from '@/utils/objects'

  export default {
    components: {
      CodingInput,
      CodingOutput,
      CodingStatus,
      CodingInfo,
      InfoAction
    },
    data () {
      return {
        sql: '',
        tableData: {
          headers: [],
          rows: []
        },
        showingUserTable: true,
        shiftChangeVisibility: false,
        mode: 'view',
        sessionInfo: () => { return {} },
        dbId: -1,
        lastDbId: -1, // records the db that was used for last sql execution. When they create db, make sure current db id matches db that was used on last sql execution
        headersMatch: false,
        duplicateColumns: false,
        columnDescriptionVisibility: false,
        dtSession: false,
        firstShiftActivated: false,
        sessionType: null,
        aQuerySent: false // so that confetti doesn't fall on load, only after a query has been sent
      }
    },
    computed: {
      ...mapState({
        databases: state => state.pg.databases,
        customExercises: state => state.pg.customExercises,
        invitations: state => state.pg.invitations,
        exercises: state => state.pg.exercises
      }),
      allowDoubleShift () {
        return this.sessionType !== 'sandbox' && this.sessionType !== 'custom-create'
      },
      infoActionVisibility () {
        return this.sessionType !== 'sandbox' && this.mode !== 'edit'
      },
      outputHeaders () {
        if (this.showingUserTable) {
          return this.tableData.headers
        } else {
          return this.sessionInfo.expected_output.headers
        }
      },
      outputRows () {
        if (this.showingUserTable) {
          return this.tableData.rows
        } else {
          return this.sessionInfo.expected_output.rows
        }
      },
      successStatus () {
        if (this.sessionType === 'invitation') {
          const invitationIdx = this.invitations.findIndex(x => x.id === parseInt(this.$route.params.id))
          const completed = this.invitations[invitationIdx].status === 'successfully completed'
          if (completed) {
            return true
          }
          return false
        } else if (this.sessionType === 'company') {
          return !!this.sessionInfo.last_successful_completion
        } else {
          return false
        }
      }
    },
    watch: {
      successStatus: {
        handler (val) {
          console.log('OK 33333')
        }
      },
      '$route': {
        async handler (val) {
          this.sessionType = null
          const mode = val.meta.mode
          const id = val.params.id === 'new' ? 'new' : parseInt(val.params.id)
          if (mode === 'sandbox') {
            const db = this.databases.find(x => x.id === id)
            this.dbId = db.id
            this.sessionInfo = sandboxInit(db.full_name)
            this.shiftChangeVisibility = false
            this.sessionType = 'sandbox'
          } else if (mode === 'exercise') {
            if (id === 'new') {
              this.mode = 'edit'
              this.$set(this, 'tableData', tableData())
              this.sessionType = 'custom-create'
            } else if (val.meta.type && val.meta.type === 'custom') {
              this.mode = 'view'
              this.setCustomExercise(id)
            } else if (val.meta.type && val.meta.type === 'invitation') {
              this.mode = 'view'
              this.sessionType = 'invitation'
              this.columnDescriptionVisibility = true
              this.setInvitation(id)
            } else if (val.meta.type && val.meta.type === 'company') {
              this.mode = 'view'
              this.sessionType = 'company'
              this.columnDescriptionVisibility = true
              this.setCompanyExercise(id)
            }
          }
        },
        deep: true,
        immediate: true
      }
    },
    methods: {
      ...mapMutations({
        'changeInvitationStatus': 'pg/changeInvitationStatus'
      }),
      confetti () {
        this.$confetti.start({shape: 'rect'})
        setTimeout(() => {
          this.$confetti.stop()
        }, 2000)
      },
      toggleTable () {
        this.showingUserTable = !this.showingUserTable
      },
      setInvitation (id) {
        console.log('set invitation')
        const invIdx = this.invitations.findIndex(x => x.id === id)
        if (invIdx !== -1) {
          console.log('not -1')
          const dbIdx = this.databases.findIndex(x => x.id === this.invitations[invIdx].exercise.db)
          this.dbId = this.databases[dbIdx].id
          this.$set(this, 'sessionInfo', {...this.invitations[invIdx].exercise})
          console.log({...this.invitations[invIdx].exercise})
        }
      },
      setCustomExercise (id) {
        const ce = this.customExercises.findIndex(x => x.id === id)
        if (ce !== -1) {
          const dbIdx = this.databases.findIndex(x => x.id === this.customExercises[ce].db)
          this.dbId = this.databases[dbIdx].id
          this.$set(this, 'sessionInfo', {...this.customExercises[ce]})
        }
      },
      setCompanyExercise (id) {
        const eIdx = this.exercises.findIndex(x => x.id === id)
        if (eIdx !== -1) {
          const dbIdx = this.databases.findIndex(x => x.id === this.exercises[eIdx].db)
          this.dbId = this.databases[dbIdx].id
          this.$set(this, 'sessionInfo', {...this.exercises[eIdx]})
        }
      },
      async createExercise (exercise) {
        if (this.dbId !== this.lastDbId) {
          console.log('Error: Database ID and last database ID do not match')
        } else if (this.headersMatch === false) {
          console.log('Error: Headers do not match')
        } else if (this.duplicateColumns === true) {
          console.log('Error: Duplicate columns')
        } else {
          const {data} = await this.$axios.post('create-exercise/', {
            ...exercise,
            sql: this.sql
          })
          console.log(data)
        }
      },
      setDb (id) {
        this.dbId = id
      },
      updateInput (val) {
        this.sql = val
      },
      testKey (evt) {
        if (evt.keyCode === 13 && (evt.metaKey || evt.ctrlKey)) {
          if (this.sessionType === 'sandbox') {
            this.sandboxTestQuery()
          } else if (this.sessionType === 'invitation') {
            this.invitationTestQuery()
          } else if (this.sessionType === 'custom-create') {
            this.customTestQuery()
          } else if (this.sessionType === 'company') {
            this.companyTestQuery()
          }
        } else if (this.allowDoubleShift && evt.key.toLowerCase() === 'shift' && evt.type === 'keydown') {
          if (this.firstShiftActivated) {
            this.firstShiftActivated = false
            this.toggleTable()
          } else {
            this.firstShiftActivated = true
            setTimeout(() => {
              this.firstShiftActivated = false
            }, 200)
          }
        }
      },
      async sandboxTestQuery () {
        const {data} = await this.$axios.post('sandbox-test-query/', {
          sql: this.sql,
          db: this.dbId
        })
        this.$set(this.tableData, 'headers', data.headers)
        this.$set(this.tableData, 'rows', data.rows)
      },
      async customTestQuery () {
        // TODO: make sure this.dbId and this.lastDbId match
        // TODO: make sure headersMatch is checked
        // TODO: check duplicateColumns set from response before saving created exercise

        const {data} = await this.$axios.post('custom-test-query/', {
          sql: this.sql,
          db: this.dbId
        })
        this.$set(this.tableData, 'headers', data.headers)
        this.$set(this.tableData, 'rows', data.rows)
        this.lastDbId = data.db_id
        this.duplicateColumns = data.duplicates
      },
      async companyTestQuery () {
        this.aQuerySent = true
        const {data} = await this.$axios.post('company-test-query/', {
          sql: this.sql,
          db: this.dbId,
          sessionId: this.sessionInfo.id
        })
        this.$set(this.tableData, 'headers', data.headers)
        this.$set(this.tableData, 'rows', data.rows)
        if (data.match) {
          this.confetti()
        }
      },
      async invitationTestQuery () {
        this.aQuerySent = true
        const invitationIdx = this.invitations.findIndex(x => x.id === parseInt(this.$route.params.id))
        const {data} = await this.$axios.post('test-query/', {
          sql: this.sql,
          db: this.dbId,
          sessionId: this.sessionInfo.id,
          dtSession: this.dtSession,
          invitationId: this.invitations[invitationIdx].id,
          firstQueryInvitation: this.invitations[invitationIdx].status === 'accepted'
        })
        this.$set(this.tableData, 'headers', data.headers)
        this.$set(this.tableData, 'rows', data.rows)
        this.lastDbId = data.db_id
        this.duplicateColumns = data.duplicates
        console.log(data.match)
        if (data.match) {
          this.confetti()
        }
        if (data.match !== this.invitations[invitationIdx].status) {
          this.changeInvitationStatus({
            invitationId: this.invitations[invitationIdx].id,
            status: data.invitation_status
          })
        }
      }
    },
    created () {
      window.addEventListener('keydown', this.testKey)
    },
    beforeDestroy () {
      window.removeEventListener('keydown', this.testKey)
    }
  }
</script>

<style lang="sass" scoped>
  .v-enter, .v-leave-to
    transform: translateY(-100%)
  .v-enter-active
    transition: transform 470ms cubic-bezier(0.55, 0.055, 0.675, 0.19)
  .v-leave-active
    transition: transform 310ms cubic-bezier(0.55, 0.055, 0.675, 0.19)
  .code
    /*border: 1px red solid*/
    position: absolute
    max-width: 1200px
    top: 105px
    left: 0
    right: 0
    bottom: 0
    margin: 25px auto 10px
    /*padding: 5px*/
    box-sizing: border-box
    display: flex
    flex-flow: row nowrap
    justify-content: space-between
    & > div
      /*width: 50%*/
      margin: 10px
    &__info
      width: 35%
      background-color: #12161e
      /*border: 1px green solid*/
      overflow: hidden
      position: relative
    &__io
      width: 65%
      /*border: 1px blue solid*/
      display: flex
      justify-content: space-between
      flex-flow: column nowrap
      & > div
        position: relative
      &__input
        /*border: 1px green solid*/
        /*flex: 11*/
        /*flex-grow: 0*/
        /*flex-shrink: 0*/
        height: 60%
      &__status
        /*border: 1px blue solid*/
        flex: 1
        flex-shrink: 0
        /*flex-grow: 0*/
        height: 5%
      &__output
        /*border: 1px red solid*/
        flex: 8
        flex-shrink: 0
        height: 35%
        /*flex-grow: 0*/
</style>
