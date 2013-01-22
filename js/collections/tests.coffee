define ['backbone', 'models/test'], (Backbone, Test) ->
  Backbone.Collection.extend {
    model: Test
  }
