define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#navbar-view'
    initialize: () ->
      do this.render

      this.options.router.bind('all', (route) ->
        if route == 'route:home'
          do $('#web-page').hide
          do $('#set-web-page').hide
          $('#test-nav-button').removeClass 'active'
          $('#result-nav-button').removeClass 'active'
        else if route == 'route:test'
          do $('#web-page').show
          do $('#set-web-page').show
          $('#test-nav-button').addClass 'active'
          $('#result-nav-button').removeClass 'active'
        else if route == 'route:result'
          do $('#web-page').show
          do $('#set-web-page').show
          $('#test-nav-button').removeClass 'active'
          $('#result-nav-button').addClass 'active'
      , this)

      this.model.bind('change:running', () ->
        if this.model.get('running') == true
          $('#web-page').removeClass 'disabled'
          $('#web-page').attr('disabled', false)
          $('#set-web-page').removeClass 'disabled'
          $('#set-web-page').attr('disabled', false)
        else
          $('#web-page').addClass 'disabled'
          $('#web-page').attr('disabled', true)
          $('#web-page').blur()
          $('#set-web-page').addClass 'disabled'
          $('#set-web-page').attr('disabled', true)
      , this)

      this.model.bind('change:webPage', () ->
        $('#web-page').val(this.model.get('webPage'))
      , this)
    render: () ->
      this.$el.html(_.template($('#navbar-template').html(), { webPage: this.model.get('webPage') }))
    events: { 'click button#set-web-page': 'setWebPage' }
    setWebPage: () ->
      this.model.set('webPage', $('#web-page').val())
  }
