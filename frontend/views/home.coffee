define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#home-view'
    events: {
      'click button#set-web-page-2': 'setWebPage'
    }
    initialize: () ->
      @render()

      @options.router.bind('all', (route) ->
        if route is 'route:home'
          @$el.show()
        else
          @$el.hide()
      , this)

      @options.locale.on('change:locale', @render , this)
      @options.testRun.bind('change:state', @render, this)
      @options.testRun.bind('change:webPage', () ->
        $('#web-page-2').val(@options.testRun.get('webPage'))
      , this)


      #@options.testRun.bind('change:state', () ->
      #  if @options.testRun.get('state') == 'loaded' or @options.testRun.get('state') == 'error'
      #    $('#web-page-2').removeClass 'disabled'
      #    $('#web-page-2').attr('disabled', false)
      #    $('#set-web-page-2').removeClass 'disabled'
      #    $('#set-web-page-2').attr('disabled', false)
      #  else
      #    $('#web-page-2').addClass 'disabled'
      #    $('#web-page-2').attr('disabled', true)
      #    $('#web-page-2').blur() # Possibly not needed here
      #    $('#set-web-page-2').addClass 'disabled'
      #    $('#set-web-page-2').attr('disabled', true)

      #, this)
    render: () ->
      @$el.html(_.template($('#home-template').html(), {
        webPage:         @options.testRun.get('webPage')
        userTestingTool: @options.locale.translate('home_user_testing_tool')
        description:     @options.locale.translate('home_description')
        enterWebPage:    @options.locale.translate('home_enter_web_page')
        startTesting:    @options.locale.translate('home_start_testing')
        reportIssue:     @options.locale.translate('home_report_issue')
      }))
      $('#web-page-2').focus()
    setWebPage: () ->
      if @options.testRun.get('webPage') == $('#web-page-2').val()
        @options.router.navigate 'test', true
      else
        @options.testRun.setWebPage($('#web-page-2').val())
  }
