# Copyright 2015 Clement Bramy
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

utils = require './utils'
Publisher = require './publishers/bpaste'
ShareView = require './views/share-view'

{CompositeDisposable} = require 'atom'

module.exports = Snippy =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'snippy:share': => @share()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  preview: (code) ->

    # set default options
    options =
      lexer: 'text' # TODO: take default lexer from config + listener
      expiry: '1d'  # TODO: take default expiry fron config + listener
      code: code

    console.log 'sharing options:', options

    editor = atom.workspace.getActiveTextEditor()
    sv = new ShareView(editor, options)
    sv.show()

  share: ->
    console.log 'Looking up for code to share..'

    if editor = atom.workspace.getActiveTextEditor()
      console.log 'Found active item to be a text editor..'

      code = editor.getSelectedText()
      if code and code.trim()
        # first check if any text is selected and not empty
        # TODO: add settings option for empty selection behaviour
        console.log 'Found selected content:'
        console.log "#{code}"
        @preview(code)
        return true

      else
        # otherwise select the whole file by default
        # TODO: add settings to turn on/off this feature
        console.log 'No selected code could be found, checking file content..'

        code = editor.getText()
        if code and code.trim()
          console.log 'Found code content in active editor:'
          console.log "#{utils.ellipsis code, 100}"
          @preview(code)
          return true

        else
          # NOTE: what to do if we still don't have any content?
          console.log 'No content could be found, abort..'
          return false

    else
      # IDEA: check for possible content in the clipboard.
      console.log 'Current active item is not an editor, abort..'
      return false
