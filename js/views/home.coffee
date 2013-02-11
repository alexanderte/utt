define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#home-view'
    initialize: () ->
      this.model.bind('change:webPage', this.disappear, this)
    disappear: () ->
      $('#result-nav-button').removeClass 'active'
      $('#test-nav-button').addClass 'active'

      do $('#home-view').hide
      do $('#result-view').hide

      if this.model.get('currentTest') == 0
        $('#iframe-view').fadeIn('slow', () ->
          $('#test-view').slideDown 'fast'
        )
      else
        do $('#test-view').show
        do $('#iframe-view').show
    render: () ->
      this.$el.html(_.template($('#home-template').html()))
  }
