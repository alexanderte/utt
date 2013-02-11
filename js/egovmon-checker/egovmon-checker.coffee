request = require 'request'
util =    require 'util'
csv =     require 'csv'
_ =       require 'underscore'

requestUrl = (webPageUrl) -> 'http://accessibility.egovmon.no/en/pagecheck2.0/?url=' + encodeURIComponent(webPageUrl) + '&export=occurences'

translateLanguageCode = (languageCode) ->
  switch languageCode
    when 'en-US' then 'English'
    else 'Unknown'

exports.checkWebPage = (webPageUrl, callback) ->
  request requestUrl(webPageUrl), (error, response, body) ->
      callback(error) if error isnt null
      rows = []
      csv()
        .from(body)
        .transform((data) -> rows.push data)
        .on('end', () ->
          rows = _.map(_.rest(rows), toTestObject)
          for row in rows
            if row.resultDetails.languageCode?
              row.resultDetails.language = translateLanguageCode(row.resultDetails.languageCode)
          callback(null, toUserTests(rows))
        )

# This is probably not optimized nor that clever, but it does the trick
camelCase = (str) ->
  result = ''
  words = str.toLowerCase().split(' ')
  result = words.shift()

  for word in words
    result += word[0].toUpperCase() + word.substr(1)

  result

parseResultDetails = (column) ->
  result = {}
  
  for keyValue in column.split(' | ')
    parts = keyValue.split(': ', 2)

    if parts[0].lastIndexOf('At line ', 0) == 0
      result['specifiedElement'] = {}
      result['specifiedElement']['codeExtract'] = parts[1]
      lineColumn = parts[0].split(' ')
      result['specifiedElement']['line'] = parseInt(lineColumn[2]) # Ends with a comma – parseInt does not seem to care
      result['specifiedElement']['column'] = parseInt(lineColumn[4])
    else if parts[0] == 'The language is set to'
      # Skip this one
    else
      result[camelCase(parts[0])] = parts[1]

  result

toTestObject = (row) ->
  {
    line:              parseInt(row[2])
    column:            parseInt(row[3])
    successCriterion:  row[4]
    test:              row[5]
    result:            row[6]
    resultDescription: row[7]
    resultDetails:     parseResultDetails(row[8])
  }

testNameToQuestion = (row) ->
  switch row.test
    when 'Providing descriptive titles for web pages'
      'Does the title “' + row.resultDetails.pageTitle + '” describe the content of the page?'
    when 'Specifying language changes in the content'
      'Does the text “' + row.resultDetails.checkedText + '” correlate with the specified language ' + row.resultDetails.language + '?'
    when 'Providing descriptive headings'
      'Does the heading “' + row.resultDetails.heading + '” describe the section that it belongs to?'
    when 'Making the link purpose identifiable'
      'Does the link text “' + row.resultDetails.linkText + '” describe the link purpose?'
    when 'Specifying language changes in the content'
      'Does the link text “' + row.resultDetails.linkText + '” describe the link purpose?'

resultType = (result) ->
  if result.lastIndexOf('Verification', 0) == 0
    'verify'
  else if result.lastIndexOf('Failed', 0) == 0
    'fail'
  else
    'pass'

toUserTests = (rows) ->
  userTests = []

  for row in rows
    if resultType(row.result) == 'verify'
      userTest = {}
      userTest.question = testNameToQuestion(row)
      userTests.push(userTest)

  userTests
