egovmonChecker = require './egovmon-checker/egovmon-checker'
util = require 'util'

egovmonChecker.checkWebPage('http://www.alexanderte.com/', (error, result) ->
  console.log util.inspect(result, false, null)
)
