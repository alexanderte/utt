define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#result-view'
    render: () ->
      this.$el.html(_.template($('#result-template').html()))
  }
