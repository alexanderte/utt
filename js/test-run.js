define(['backbone'], function(Backbone) {
  return Backbone.Model.extend({
    defaults: {
      'webPage': 'http://ec.europa.eu/index_en.htm',
      'currentTest': 0,
    },
    initialize: function(tests) {
      this.set('tests', tests);
    },
    progress: function() {
      return parseInt((this.get('currentTest') / (this.get('tests').length - 1)) * 100);
    },
    previousTest: function() {
      if (this.get('currentTest') === 0)
        return false;

      this.set('currentTest', this.get('currentTest') - 1);
      return true;
    },
    nextTest: function() {
      if (this.get('currentTest') === (this.get('tests').length - 1))
        return false;

      this.set('currentTest', this.get('currentTest') + 1);
      return true;
    },
    isAtLast: function() {
      return this.get('currentTest') === (this.get('tests').length - 1);
    }
  });
});
