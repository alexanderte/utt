define ['backbone', 'underscore','jquery'], (Backbone, _, $) ->
  Backbone.View.extend {
    el: '#home-view'
    initialize: () ->
      do this.render

      this.options.router.bind('all', (route) ->
        if route == 'route:home'
          do this.$el.show
        else
          do this.$el.hide
      , this)
    render: () ->
      this.$el.html(_.template($('#home-template').html()))
  }
