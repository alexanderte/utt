# Running the checker takes some time — run mocha -t 10000

egovmonChecker = require '../egovmon-checker'
assert = require 'assert'

describe 'checkWebPage', ->
  it 'should return an object', (done) ->
    egovmonChecker.checkWebPage('http://www.alexanderte.com/', (error, result) ->
      assert.ok(typeof(result) == 'object')
      do done
    )
