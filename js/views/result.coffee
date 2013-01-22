define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#result-view'
    render: () ->
      this.$el.html(_.template($('#result-template').html(), { webPage: this.model.get('webPage') }))
    initialize: () ->
      this.model.bind('change:webPage', this.render, this)
  }
