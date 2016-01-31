utils = require '../lib/utils'

describe 'utils', ->

  describe "utils::ellipsis(text, max=50, end='...')", ->

    describe "when an empty text is provided to ellipsis", ->
      it "should return back an empty string", ->
        expect(utils.ellipsis '').toBe('')

    describe "when a null text is provided to ellipsis", ->
      it "should return back an empty string", ->
        expect(utils.ellipsis null).toBe('')

    describe "when an undefined text value is provided to ellipsis", ->
      it "should return back an empty string", ->
        expect(utils.ellipsis undefined).toBe('')

    describe "when a `text` who's length is inferior or equals to `max` is provided to ellipsis", ->
      it "should returns the same string back", ->
        expect(utils.ellipsis 'test', 4).toBe('test')

    describe "when a `text` who's length is superior to `max` is provided to ellipsis", ->
      it "should returns a shortened version of it concatenated with `end`", ->
        expect(utils.ellipsis 'this is a test', 10).toBe('this is...')
