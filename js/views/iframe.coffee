define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#iframe-view'
    render: () ->
      this.$el.html(_.template($('#iframe-template').html(), { 'url': this.model.get('webPage') }))
    initialize: () ->
      this.model.bind('change:webPage', this.render, this)
  }
