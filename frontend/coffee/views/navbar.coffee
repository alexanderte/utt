define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#navbar-view'
    initialize: () ->
      do this.render

      this.options.router.bind('all', (route) ->
        if route == 'route:home'
          $('#test-nav-button').removeClass 'active'
          $('#result-nav-button').removeClass 'active'
        else if route == 'route:test'
          $('#test-nav-button').addClass 'active'
          $('#result-nav-button').removeClass 'active'
        else if route == 'route:result'
          $('#test-nav-button').removeClass 'active'
          $('#result-nav-button').addClass 'active'
        else
      , this)
    render: () ->
      this.$el.html(_.template($('#navbar-template').html(), { webPage: this.model.get('webPage') }))
    events: { 'click button#set-web-page': 'setWebPage' }
    setWebPage: () ->
      this.model.set('webPage', $('#web-page').val())
  }
