define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#iframe-view'
    initialize: () ->
      this.model.bind('change:webPage', this.render, this)
      do this.render

      this.options.router.bind('all', (route) ->
        if route == 'route:test'
          do this.$el.show
        else
          do this.$el.hide
      , this)
    render: () ->
      this.$el.html(_.template($('#iframe-template').html(), { 'webPage': this.model.get('webPage') }))
  }
