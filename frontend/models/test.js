(function() {
  define(['backbone'], function(Backbone) {
    return Backbone.Model.extend({
      defaults: {
        'line': void 0,
        'column': void 0,
        'testResultId': void 0,
        'testId': void 0,
        'testTitle': void 0,
        'category': void 0,
        'question': void 0,
        'answers': void 0,
        'template': '#test-case-template',
        'answer': void 0
      },
      getTestId: function() {
        return this.attributes.testId + '-' + this.attributes.testResultId;
      }
    });
  });

}).call(this);
