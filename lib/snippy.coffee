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

SnippyView = require './snippy-view'
{CompositeDisposable} = require 'atom'

module.exports = Snippy =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    # adds snippy commands
    @subscriptions.add atom.commands.add 'atom-workspace', 'snippy:share': => @share()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->
    snippyViewState: @snippyView.serialize()

  share: ->
    console.log "Code shared!"
