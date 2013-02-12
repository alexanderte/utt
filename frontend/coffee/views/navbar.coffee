define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#navbar-view'
    render: () ->
      this.$el.html(_.template($('#navbar-template').html(), { webPage: this.model.get('webPage') }))
    events: { 'click button#set-web-page': 'setWebPage' }
    setWebPage: () ->
      this.model.set('webPage', $('#web-page').val())
  }
