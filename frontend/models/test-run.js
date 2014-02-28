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
      getVerifyTests: function() {
        var count, result, test, tests, _i, _len;

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
      getCurrentTest: function() {
        if (this.get('tests').length === 0) {
          return null;
        } else {
          return this.getVerifyTests()[this.get('currentTest')];
        }
      },
      getVerifyTestsCount: function() {
        return this.getVerifyTests().length;
      },
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
