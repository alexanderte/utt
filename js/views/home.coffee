define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#home-view'
    render: () ->
      this.$el.html(_.template($('#home-template').html()))
  }
