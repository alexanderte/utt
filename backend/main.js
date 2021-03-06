(function() {
  var fs, getLanguage, io, languages, path, request, requestUrl, transformResult, transformResults, transformVerifyResult, _;

  fs = require('fs');

  path = require('path');

  io = require('socket.io').listen(4653, 151.236.221.149);

  request = require('request');

  _ = require('underscore');

  languages = require('languages');

  getLanguage = function(languageCode) {
    if (languageCode === 'en-US') {
      return 'English';
    } else if (languages.isValid(languageCode)) {
      return languages.getLanguageInfo(languageCode).name;
    } else {
      return '<em>Unknown language</em>';
    }
  };

  requestUrl = function(webPageUrl) {
    return 'http://accessibility.egovmon.no/en/pagecheck2.0/?url=' + encodeURIComponent(webPageUrl) + '&export=json';
  };

  transformResults = function(results) {
    return _.reject(_.map(results, function(result) {
      return transformResult(result);
    }), function(result) {
      return _.isEmpty(result);
    });
  };

  transformResult = function(checkerResult) {
    var result;

    result = {
      line: checkerResult.line,
      column: checkerResult.column,
      testId: checkerResult.testId,
      testResultId: checkerResult.testResultId.split('-')[2],
      testTitle: checkerResult.testTitle,
      category: checkerResult.category
    };
    if (result.category === 'verify') {
      return transformVerifyResult(checkerResult, result);
    } else {
      return result;
    }
  };

  transformVerifyResult = function(checkerResult, result) {
    var languageCode;

    switch (checkerResult.testResultId) {
      case 'SC2.4.2-1-11':
        return _.extend(result, {
          questionValues: [checkerResult.details.pageTitle],
          answers: ['yes', 'no']
        });
      case 'SC2.4.4-2-11':
        return _.extend(result, {
          questionValues: [checkerResult.details.codeExtract],
          answers: ['yes', 'no', 'unsure']
        });
      case 'SC2.4.4-2-12':
        return _.extend(result, {
          questionValues: [checkerResult.details.title, checkerResult.details.codeExtract],
          answers: ['yes', 'no', 'unsure']
        });
      case 'SC2.4.6-1-11':
        return _.extend(result, {
          questionValues: [checkerResult.details.heading],
          answers: ['yes', 'no', 'unsure']
        });
      case 'SC3.1.2-2-11':
        languageCode = checkerResult.details.languageDefinition.languageCode;
        return _.extend(result, {
          questionValues: [checkerResult.details.checkedText, getLanguage(languageCode), languageCode],
          answers: ['yes', 'no', 'unsure', 'i_dont_speak_this_language']
        });
      default:
        console.log('Not supported: ' + checkerResult.testResultId);
        return {};
    }
  };

  io.sockets.on('connection', function(socket) {
    socket.on('get tests', function(data) {
      return request(requestUrl(data), function(error, result, body) {
        console.log('error=' + error);
        console.log('result=' + result);
        console.log('body=' + body);
        if (result.body.substring(0, 19) === 'An error occurred: ') {
          console.log('Error when requesting ' + data + ': ' + result.body.substring(19));
          return socket.emit('tests', null);
        } else {
          return socket.emit('tests', transformResults(JSON.parse(body)));
        }
      });
    });
    return socket.on('get locale', function(locale) {
      if (locale !== 'no' && locale !== 'en') {
        return;
      }
      return fs.readFile(path.resolve(__dirname, 'locale/', locale + '.json'), 'utf8', function(err, data) {
        if (err) {
          throw err;
        }
        return socket.emit('locale', {
          locale: locale,
          data: JSON.parse(data)[locale]
        });
      });
    });
  });

}).call(this);
