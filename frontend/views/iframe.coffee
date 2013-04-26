define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#iframe-view'
    initialize: () ->
      @render()

      @options.router.bind('all', (route) ->
        if route is 'route:test'
          if @options.testRun.get('state') isnt 'error'
            @$el.show()
        else
          @$el.hide()
      , this)

      @options.testRun.bind('change:webPage', @render, this)
    render: () ->
      @$el.html(_.template($('#iframe-template').html(), { 'webPage': @options.testRun.get('webPage') }))
  }
