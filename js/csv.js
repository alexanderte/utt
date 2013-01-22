var request = require('request');
var csv = require('csv');
var _ = require('underscore');

request('http://accessibility.egovmon.no/en/pagecheck2.0/?url=http%3A%2F%2Falexanderte.com%2F&export=tests', function(error, response, body) {
    if (error !== null)
      throw new Exception('error');

    var rows = [];

    csv()
      .from(body)
      .transform(function(data) {
        rows.push(data);
      })
      .on('end', function() {
        console.log(
          _.filter(
            _.map(_.rest(rows), toTestObject),
            function(o) { return o.verifyOccurences > 0 }
          )
        );
      });
});

function toTestObject(row) {
  return {
    successCriterion: row[2],
    testName: row[3],
    failOccurences: toNumber(row[4]),
    verifyOccurences: toNumber(row[5]),
    passOccurences: toNumber(row[6])
  };
}

function toNumber(n) {
  if (n === '')
    return 0;
  else
    return parseInt(n);
}
