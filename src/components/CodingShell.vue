<template lang="pug">
  .code(@keyup="testKey")
    .code__info
        coding-info(
          :session-info="sessionInfo",
          :mode="mode",
          @db-change="setDb",
          :headers="tableData.headers",
          @headers-match="headersMatch = arguments[0]",
          @create="createExercise"
        )
    .code__io
      .code__io__input
        coding-input(@update="updateInput")
      .code__io__status
        coding-status
      .code__io__output
        coding-output(
          :headers="tableData.headers",
          :rows="tableData.rows"
        )
</template>

<script>
  import CodingInput from '@/components/CodingInput'
  import CodingOutput from '@/components/CodingOutput'
  import CodingStatus from '@/units/CodingStatus'
  import CodingInfo from '@/components/CodingInfo'

  import {mapState} from 'vuex'
  import {sandboxInit, tableData} from '@/utils/objects'

  export default {
    components: {
      CodingInput,
      CodingOutput,
      CodingStatus,
      CodingInfo
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
        duplicateColumns: false
      }
    },
    computed: {
      ...mapState({
        databases: state => state.pg.databases
      })
    },
    watch: {
      '$route': {
        async handler (val) {
          const mode = val.meta.mode
          const id = val.params.id === 'new' ? 'new' : parseInt(val.params.id)
          if (mode === 'sandbox') {
            const db = this.databases.find(x => x.id === id)
            this.dbId = db.id
            this.sessionInfo = sandboxInit(db.full_name)
            this.shiftChangeVisibility = false
          } else if (mode === 'exercise' && id === 'new') {
            this.mode = 'edit'
            this.$set(this, 'tableData', tableData())
          }
        },
        deep: true,
        immediate: true
      }
    },
    methods: {
      async createExercise (exercise) {
        const {data} = await this.$axios.post('create-exercise/', {
          ...exercise,
          sql: this.sql
        })
        console.log(data)
      },
      setDb (id) {
        this.dbId = id
      },
      updateInput (val) {
        this.sql = val
      },
      testKey (evt) {
        if (evt.keyCode === 13 && evt.metaKey) {
          this.testQuery()
        }
      },
      async testQuery () {
        // TODO: make sure this.dbId and this.lastDbId match
        // TODO: make sure headersMatch is checked
        // TODO: check duplicateColumns set from response before saving created exercise
        const {data} = await this.$axios.post('test-query/', {
          sql: this.sql,
          db: this.dbId
        })
        this.$set(this.tableData, 'headers', data.headers)
        this.$set(this.tableData, 'rows', data.rows)
        this.lastDbId = data.db_id
        this.duplicateColumns = data.duplicates
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
      overflow: scroll
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
        flex: 11
      &__status
        /*border: 1px blue solid*/
        flex: 1
      &__output
        /*border: 1px red solid*/
        flex: 8
</style>
