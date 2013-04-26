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
    render: () ->
      @$el.html(_.template($('#home-template').html(), {
        webPage:         @options.testRun.get('webPage')
        userTestingTool: @options.locale.translate('home_user_testing_tool')
        description:     @options.locale.translate('home_description')
        enterWebPage:    @options.locale.translate('home_enter_web_page')
        startTesting:    @options.locale.translate('home_start_testing')
        reportIssue:     @options.locale.translate('home_report_issue')
        state:           @options.testRun.get('state')
      }))
      $('#web-page-2').focus()
    setWebPage: () ->
      @options.testRun.setWebPage($('#web-page-2').val())
      @options.router.navigate 'test', { trigger: true }
  }
