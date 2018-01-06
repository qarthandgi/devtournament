const ace = require('brace')

module.exports = {
  template: '<div :style="{height: height, width: width}"></div>',

  props: {
    content: {
      type: String,
      required: true
    },
    lang: {
      type: String,
      default: 'javascript'
    },
    theme: {
      type: String,
      default: 'chrome'
    },
    height: {
      type: String,
      default: '300px'
    },
    width: {
      type: String,
      default: '100%'
    },
    sync: {
      type: Boolean,
      default: false
    },
    options: {
      type: Object,
      default: function () { return {} }
    }
  },

  data: function () {
    return {
      editor: null
    }
  },

  mounted: function () {
    const vm = this
    const lang = vm.lang
    const theme = vm.theme
    const editor = vm.editor = ace.edit(vm.$el)
    const options = vm.options
    editor.$blockScrolling = Infinity
    editor.getSession().setMode('ace/mode/' + lang)
    editor.setTheme('ace/theme/' + theme)
    editor.setValue(vm.content, 1)
    editor.setOptions(options)
    // TODO: HAD VIM WORKING AHH - put it back in - with this link https://stackoverflow.com/questions/28078478/ace-editor-and-vim-keybindings-using-w-command
    editor.on('change', function () {
      vm.$emit('editor-update', editor.getValue())
    })
  },

  watch: {
    content: function (newContent) {
      const vm = this
      if (vm.sync) {
        vm.editor.setValue(newContent, 1)
      }
    },

    theme: function (newTheme) {
      const vm = this
      vm.editor.setTheme('ace/theme/' + newTheme)
    }
  }
}

/*

MIT License

Copyright (c) 2016 Dominique Henkes

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

 */
