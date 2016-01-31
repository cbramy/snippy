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

_ = require 'lodash'

module.exports = class Publisher
  http_default_headers =
    'Accept-Charset': 'utf-8'
    'Cache-Control': 'no-cache'
    'Content-Type': 'application/x-www-form-urlencoded'

  https_default_headers =
    'Accept-Charset': 'utf-8'
    'Cache-Control': 'no-cache'
    'Content-Type': 'application/x-www-form-urlencoded'

  get_http_headers: (headers) ->
    _.merge http_default_headers, headers

  get_https_headers: (headers) ->
    _.merge https_default_headers, headers

  success: (url) =>
    atom.clipboard.write(url)
    atom.notifications?.addSuccess 'Code shared.',
      dismissable: true
      icon: 'cloud-upload'
      detail: """
              Your code snippet has been successfully shared on #{@name}.
              Snippet url has been copied in your clipboard.
              Snippet available at #{url}!
              """

  failure: (error) =>
    atom.notifications?addError 'Code sharing failure.',
      dismissable: true
      icon: 'hubot'
      detail: """
              Your code could not be uploaded to #{@name} due to errors:
              #{error}
              """
  share: (timeout) ->
    # TODO: show loading pane
