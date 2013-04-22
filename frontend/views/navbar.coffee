define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#navbar-view'
    initialize: () ->
      do this.render
      this.model.bind('change:route', () ->
        do this.render
      , this)
      this.model.bind('change:state', () ->
        do this.render
      , this)
      this.model.bind('change:webPage', () ->
        do this.render
      , this)
      this.model.bind('change:language', () ->
        do this.render
      , this)
    render: () ->
      this.$el.html(_.template($('#navbar-template').html(), {
        webPage: this.model.get('webPage'),
        language: this.model.get('language')
        state: this.model.get('state')
        route: this.model.get('route')
      }))
    events: {
      'click button#set-web-page': 'setWebPage'
      'click a.language': 'changeLanguage'
    }
    setWebPage: () ->
      this.model.setWebPage($('#web-page').val())
    changeLanguage: (e) ->
      this.model.setLanguage(e.currentTarget.dataset['language'])
  }
