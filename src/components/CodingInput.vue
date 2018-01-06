<template lang="pug">
  .input
    .top-panel.darker
    .bottom-panel.darker
    .editor
      editor(
        :content="''",
        :width="'100%'",
        :height="'100%'",
        :lang="'sql'",
        @editor-update="$emit('update', $event)"
      )
</template>

<script>
  import editor from '@/plugins/ace'
  import 'brace/mode/sql'
  import 'brace/theme/chrome'

  export default {
    components: {
      editor
    },
    methods: {
    }
  }
</script>

<style lang="sass">
  @import '../assets/sass/vars'

  .input
    height: 100%
    .editor
      padding: $border-panel-height 0px
      width: 100%
      height: 100%
      box-sizing: border-box
</style>
