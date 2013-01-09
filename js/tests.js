define(['backbone', 'test'], function(Backbone, Test) {
  return Backbone.Collection.extend({
    model: Test
  });
});
