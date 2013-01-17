define(['backbone'], function(Backbone) {
  return Backbone.Model.extend({
    defaults: {
      'webPage': 'http://ec.europa.eu/index_en.htm',
      '_currentTest': 0,
    },
    initialize: function(tests) {
      this.set('tests', tests);
    },
    progress: function() {
      return parseInt((this.get('_currentTest') / (this.get('tests').length - 1)) * 100);
    },
    currentTest: function() {
      return this.get('tests').at(this.get('_currentTest'));
    },
    getCurrentTestId: function(id) {
      return this.get('_currentTest');
    },
    setCurrentTest: function(id) {
      this.set('_currentTest', id);
    },
    previousTest: function() {
      if (this.get('_currentTest') === 0)
        return false;

      this.set('_currentTest', this.get('_currentTest') - 1);
      return true;
    },
    nextTest: function() {
      if (this.get('_currentTest') === (this.get('tests').length - 1))
        return false;

      this.set('_currentTest', this.get('_currentTest') + 1);
      return true;
    },
    nextTestId: function() {
      if (this.get('_currentTest') === (this.get('tests').length - 1))
        return false;

      return this.get('_currentTest') + 1;
    }
  });
});
