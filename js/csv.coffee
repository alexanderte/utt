request = require 'request'
csv =     require 'csv'
_ =       require 'underscore'
util =    require 'util'

request 'http://accessibility.egovmon.no/en/pagecheck2.0/?url=http%3A%2F%2Falexanderte.com%2F&export=occurences', (error, response, body) ->
    throw new Exception('Could not fetch CSV-file from eGovMon Checker.') if error isnt null

    rows = []
    ds = {} # Final data structure

    csv()
      .from(body)
      .transform((data) -> rows.push data)
      .on('end', () ->
        rows = _.map(_.rest(rows), toTestObject)

        for row in rows
          if not ds[row.successCriterion]?
            ds[row.successCriterion] = {}

          if not ds[row.successCriterion][row.test]?
            ds[row.successCriterion][row.test] = []

          ds[row.successCriterion][row.test].push({
            line:              row.line
            column:            row.column
            result:            row.result
            resultDescription: row.resultDescription
            resultDetails:     row.resultDetails
          })

        console.log(util.inspect(ds, false, null))
      )

toTestObject = (row) ->
  {
    line:              row[2]
    column:            row[3]
    successCriterion:  row[4]
    test:              row[5]
    result:            row[6]
    resultDescription: row[7]
    resultDetails:     row[8]
  }
