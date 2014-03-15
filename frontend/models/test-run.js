//Run the automated tests on eGovMon
//Fetch the results and analyse them
//Pull out and make available the set of tests that require user verification
(function() {
  define(['backbone', 'socketio', 'collections/tests'], function(Backbone, io, Tests) {
    return Backbone.Model.extend({
      defaults: {
        'webPage': 'http://www.tingtun.no/',
        'state': 'loading',
        'tests': [],
        'currentTest': 0
      },
      initialize: function(socket) {
        var that;

        _.extend(this, Backbone.Events);
        this.set('socket', socket);
        socket.emit('get tests', this.get('webPage'));
        that = this;
        socket.on('tests', function(data) {
          if (data === null) {
            return that.set('state', 'error');
          } else {
            that.set('tests', new Tests(data));
            return that.set('state', 'loaded');
          }
        });
        return this.bind('change:webPage', this.fetchTests, this);
      },
      fetchTests: function() {
        this.set('state', 'loading');
        return this.get('socket').emit('get tests', this.get('webPage'));
      },
	  //Fetch the tests that need to be vverified by the user
      getVerifyTests: function() {
        var count, result, test, tests, _i, _len;

		//Brings back the first 10 results that require verification
        tests = _.first(this.get('tests').where({
          category: 'verify'
        }), 10);
        tests = tests.sort(function(a, b) {
          return a.getTestId() > b.getTestId();
        });
        count = {};
        result = [];
        for (_i = 0, _len = tests.length; _i < _len; _i++) {
          test = tests[_i];
          if (!count[test.getTestId()]) {
            count[test.getTestId()] = 0;
          }
          if (count[test.getTestId()] < 2) {
            count[test.getTestId()] = count[test.getTestId()] + 1;
            result.push(test);
          }
        }
        return result;
      },
	  //Fetch the next test to be presented to the user
      getCurrentTest: function() {
        if (this.get('tests').length === 0) {
          return null;
        } else {
          return this.getVerifyTests()[this.get('currentTest')];
        }
      },
	  //Compute the 'Y' number in a "Question X of Y" scenario
      getVerifyTestsCount: function() {
        return this.getVerifyTests().length;
      },
	  //Compute the percentage of tests verified for the progress bar
      progress: function() {
        return parseInt((this.get('currentTest') / (this.getVerifyTests().length - 1)) * 100);
      },
      isAtFirst: function() {
        return this.get('currentTest') === 0;
      },
      isAtLast: function() {
        return this.get('currentTest') === (this.getVerifyTests().length - 1);
      },
      setAnswer: function(answer) {
        this.getVerifyTests()[this.get('currentTest')].set('answer', answer);
        return this.trigger('change:answer');
      },
	  //Set the webpage to be tested
      setWebPage: function(url) {
        var addProtocol;

        addProtocol = function(url) {
          if (url.substring(0, 7) !== 'http://' && url.substring(0, 8) !== 'https://') {
            return 'http://' + url;
          } else {
            return url;
          }
        };
        this.set('currentTest', 0);
        return this.set('webPage', addProtocol(url));
      }
    });
  });

}).call(this);
