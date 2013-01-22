request = require 'request'
csv =     require 'csv'
_ =       require 'underscore'

request 'http://accessibility.egovmon.no/en/pagecheck2.0/?url=http%3A%2F%2Falexanderte.com%2F&export=tests', (error, response, body) ->
    throw new Exception('error') if error isnt null

    rows = []

    csv()
      .from(body)
      .transform((data) -> rows.push data)
      .on('end', () ->
        console.log _.filter(
          _.map(_.rest(rows), toTestObject),
          (o) -> o.verifyOccurences > 0
        )
      )

toTestObject = (row) ->
  {
    successCriterion: row[2],
    testName:         row[3],
    failOccurences:   toNumber(row[4]),
    verifyOccurences: toNumber(row[5]),
    passOccurences:   toNumber(row[6])
  }

toNumber = (n) ->
  if n is '' then 0 else parseInt n
