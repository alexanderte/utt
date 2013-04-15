io =        require('socket.io').listen(4563)
request =   require 'request'
_ =         require 'underscore'
languages = require 'languages'

getLanguage = (languageCode) ->
  if languageCode == 'en-US'
    'English'
  else if languages.isValid(languageCode)
    languages.getLanguageInfo(languageCode).name
  else
    '<em>Unknown language</em>'

requestUrl = (webPageUrl) -> 'http://accessibility.egovmon.no/en/pagecheck2.0/?url=' + encodeURIComponent(webPageUrl) + '&export=json'

transformResults = (results) ->
  _.reject(_.map(results, (result) -> transformResult(result)), (result) -> _.isEmpty(result))

transformResult = (checkerResult) ->
    result = {
      line:         checkerResult.line
      column:       checkerResult.column
      testId:       checkerResult.testId
      testResultId: checkerResult.testResultId.split('-')[2]
      testTitle:    checkerResult.testTitle
      category:     checkerResult.category
    }

    if result.category == 'verify'
      transformVerifyResult checkerResult, result
    else
      result

transformVerifyResult = (checkerResult, result) ->
    switch checkerResult.testResultId
      when 'SC2.4.2-1-11'
        _.extend(result, { question: 'Does the page title “' + checkerResult.details.pageTitle + '” describe the content of this web page?', answers: ['Yes', 'No'] })
      when 'SC2.4.4-2-11'
        _.extend(result, { question: 'Does the link text ' + checkerResult.details.codeExtract + ' describe the link purpose?', answers: ['Yes', 'No', 'Unsure'] })
      when 'SC2.4.4-2-12'
        _.extend(result, { question: 'Does the link title “' + checkerResult.details.title + '” for the link ' + checkerResult.details.codeExtract + ' describe the link purpose?', answers: ['Yes', 'No', 'Unsure'] })
      when 'SC2.4.6-1-11'
        _.extend(result, { question: 'Does the heading “' + checkerResult.details.heading + '” describe the section it belongs to?', answers: ['Yes', 'No', 'Unsure'] })
      when 'SC3.1.2-2-11'
        languageCode = checkerResult.details.languageDefinition.languageCode
        _.extend(result, { question: 'Does the text “' + checkerResult.details.checkedText + '” correlate with the specified language ' + getLanguage(languageCode) + ' (' + languageCode + ')?', answers: ['Yes', 'No', 'Unsure', 'I don’t speak ' + getLanguage(languageCode)] })
      else
        console.log 'Not supported: ' + checkerResult.testResultId
        {}

io.sockets.on('connection', (socket) ->
  socket.on 'get tests', (data) ->
    request(requestUrl(data), (error, result, body) ->
      console.log 'error=' + error
      console.log 'result=' + result
      console.log 'body=' + body
      if result.body.substring(0, 19) == 'An error occurred: '
        console.log 'Error when requesting ' + data + ': ' + result.body.substring(19)
        socket.emit 'tests', null
      else
        socket.emit 'tests', transformResults(JSON.parse(body))
    )
)
