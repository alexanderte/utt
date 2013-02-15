io =        require('socket.io').listen(8000)
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

#"SC2.4.4-1-11";"Please check the link text of the [el]area[/el]";"<p>Human input is necessary to verify, that the alternative text of the <samp>area</samp> serves the same purpose as the selectable area of the image.</p>"
#"SC2.4.4-2-13";"Please check the link context";"<p>The link is a duplicate, and human input is necessary to verify, that the purpose of the link is identifiable by its context.</p>"
#"SC2.4.6-2-11";"Please check the label";"<p>Human input is necessary to verify, that the <samp>label</samp> describes the purpose of the form control.</p>"
#"SC3.1.1-1-11";"Please check the main language of the page";"<p>Human input is necessary to verify, that the main language specified for the page corresponds to the mainly used language.</p>"
#"SC3.2.2-1-11";"Please check that implicit changes of context are described";"<p>Human input is necessary to verify, that the submit button is the only way to initiate a change of context with the form or that there is a description of the change before the initiating form control.</p>"
#"SC3.2.2-3-11";"Please check that a change of context, initiated within or by the form, is described";"<p>Human input is necessary to verify, that the change of context is described prior to the form or initiating form control.</p>"
#"SC3.2.2-3-12";"Please check that a change of context is described";"<p>Human input is necessary to verify, that a change of context is described prior to the initiating form control.</p>"
#"SC3.3.2-2-11";"Please check the labelling title";"<p>Human input is necessary to verify, that the <samp>title</samp> describes the purpose of the form control.</p>"
#"SC3.3.2-3-11";"Please check the labelling button";"<p>Human input is necessary to verify, that the text value of the button describes the purpose of the form control.</p>"
#"SC3.3.2-6-11";"Please check the [el]legend[/el]";"<p>Human input is necessary to verify, that the <samp>legend</samp> describes the group formed by the <samp>fieldset</samp>.</p>"
#"SC4.1.2-2-11";"Please check the name of the frame";"<p>Human input is necessary to verify, that the <samp>title</samp> of the <samp>frame</samp> or <samp>iframe</samp> describes its contents.</p>"

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
      #"SC2.4.2-1-11";"Please check the title of the page";"<p>Human input is necessary to verify, that the title describes the content of the page.</p>"
      when 'SC2.4.2-1-11'
        _.extend(result, { question: 'Does the title “' + checkerResult.details.pageTitle + '” describe the content of this web page?', answers: ['Yes', 'No'] })
      #"SC2.4.4-2-11";"Please check the link text";"<p>Human input is necessary to verify, that the link text describes the link purpose.</p>"
      when 'SC2.4.4-2-11'
        _.extend(result, { question: 'Does the link text ' + checkerResult.details.codeExtract + ' describe the link purpose?', answers: ['Yes', 'No', 'Unsure'] })
      #"SC2.4.4-2-12";"Please check the title of the link";"<p>Human input is necessary to verify, that the title describes the link purpose.</p>"
      when 'SC2.4.4-2-12'
        _.extend(result, { question: 'Does the title “' + checkerResult.details.title + '” for the link ' + checkerResult.details.codeExtract + ' describe the link purpose?', answers: ['Yes', 'No', 'Unsure'] })
      #"SC2.4.6-1-11";"Please check the heading";"<p>Human input is necessary to verify, that the heading describes the section it belongs to.</p>"
      when 'SC2.4.6-1-11'
        _.extend(result, { question: 'Does the heading “' + checkerResult.details.heading + '” describe the section it belongs to?', answers: ['Yes', 'No', 'Unsure'] })
      #"SC3.1.2-2-11";"Please check the language";"<p>Human input is necessary to verify, that the specified language correlates with the used language.</p>"
      when 'SC3.1.2-2-11'
        languageCode = checkerResult.details.languageDefinition.languageCode
        _.extend(result, { question: 'Does the text “' + checkerResult.details.checkedText + '” correlate with the specified language ' + getLanguage(languageCode) + ' (' + languageCode + ')?', answers: ['Yes', 'No', 'Unsure', 'I don’t speak ' + getLanguage(languageCode)] })
      else
        console.log('Not supported: ' + checkerResult.testResultId)
        {}

io.sockets.on('connection', (socket) ->
  socket.on 'get tests', (data) ->
    request(requestUrl(data), (error, result, body) ->
      if result.body == 'An error occurred: The domain could not be found.'
        socket.emit 'tests', null
      else
        socket.emit 'tests', transformResults(JSON.parse(body))
    )
)
