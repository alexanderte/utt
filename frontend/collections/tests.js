//This is the collection of 'test' models that stores test results fetched from eGovMon
(function() {
  define(['backbone', 'models/test'], function(Backbone, Test) {
    return Backbone.Collection.extend({
      model: Test
    });
  });

}).call(this);
