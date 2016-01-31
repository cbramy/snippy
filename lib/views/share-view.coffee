# Copyright 2016 Clement Bramy
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

{View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'

module.exports = class ShareView extends View
  grammars =
    'coffee-script': 'Coffee Script'
    'javascript': 'JavaScript'
    'python': 'Python 2'
    'python3': 'Python 3'
    'java': 'Java'

  @content: (editor, params = @defaults) ->
    @div class: 'share-container', =>
      @div class: 'share-container-wrapper', =>

        @div class: 'share-controls', =>

          @div class: 'header', =>
            @span class: 'header-label', =>
              @span class: 'header-action', 'Share Selection as Snippet'
              @span class: 'header-hint text-subtle', => @raw 'Close this panel with the <span class="highlight">esc</span> key'

          @div class: 'controls', =>
            @select class: 'btn btn-lg select-grammar', outlet: 'lexer', =>
              @option value: 'coffee-script', selected: 'selected', 'Coffee Script'
              @option value: 'javascript', 'JavaScript'
              @option value: 'python', 'Python 2'
              @option value: 'python3', 'Python 3'
              @option value: 'java', 'Java'
              @option value: 'text', 'Text'
            @div class: 'controls-toolbar', =>
              @div class: 'btn-group controls-toolbar-expiry', =>
                @button class: 'btn', outlet: 'expiry_1d', value: '1day', '1d'
                @button class: 'btn', outlet: 'expiry_1w', value: '1week', '1w'
                @button class: 'btn', outlet: 'expiry_1m', value: '1month', '1m'
                @button class: 'btn', outlet: 'expiry_never', value: 'never', '∞'
              @button class: 'btn btn-error icon icon-remove-close inline-block-tight', outlet: 'cancel', 'Cancel'
              @button class: 'btn btn-info icon-cloud-upload inline-block-tight', outlet: 'share', 'Share'

        @div class: 'share-details'

  initialize: (@editor, @params= {lexer: 'coffee-script', expiry: '1d', code: null}) =>
    # TODO: fix the multiple view issue
    oldView?.destroy()
    oldView = this

    # create & attach form commands
    @disposables = new CompositeDisposable

    @share.on 'click', => @submit()
    @cancel.on 'click', => @destroy()

    # toggle expiry based on user input
    @expiry_1d.on 'click', => @expiry '1day'
    @expiry_1w.on 'click', => @expiry '1week'
    @expiry_1m.on 'click', => @expiry '1month'
    @expiry_never.on 'click', => @expiry 'never'

    # update value of selected grammar
    @lexer.on 'change', =>
      console.log "updating grammar to: #{@lexer.val()}"
      @params.lexer = @lexer.val()

    @disposables.add atom.workspace.onDidChangeActivePaneItem (item) =>
      if item in [@editor, this]
        @show()
      else
        @hide()

    atom.workspace.addBottomPanel
      item: this

    Publisher = require '../publishers/bpaste'
    @publisher = new Publisher()

    @update_expiry()

  destroy: ->
    @disposables.dispose()
    @detach()

  show: ->
    @hidden = false
    @css(display: 'inline-block')

  hide: ->
    @hidden = true
    super()

  submit: =>
    console.log "sharing options:"
    console.log @params
    @publisher.share(@params)
    @destroy()

  expiry: (choice) =>
    console.log "changing expiry to: #{choice}"
    @params.expiry = choice;
    @update_expiry()

  update_expiry: =>
    @find(".controls-toolbar-expiry > .btn[value='#{@params.expiry}']").addClass('selected');
    @find(".controls-toolbar-expiry > .btn[value!='#{@params.expiry}']").removeClass('selected');
