define(['backbone', 'models/test'], function(Backbone, Test) {
  return Backbone.Collection.extend({
    model: Test
  });
});
