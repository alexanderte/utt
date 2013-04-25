define ['backbone', 'underscore', 'jquery', 'jed'], (Backbone, _, $) ->
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

      this.model.bind('change:webPage', () ->
        $('#web-page-2').val(this.model.get('webPage'))
      , this)

      this.model.on('languageUpdated', () ->
        console.log('languageUpdated')
        this.render()
      , this)

      this.model.on('appLoaded', () ->
        console.log(3)
        this.render()
      , this)

      this.model.bind('change:state', () ->
        if this.model.get('state') == 'loaded' or this.model.get('state') == 'error'
          $('#web-page-2').removeClass 'disabled'
          $('#web-page-2').attr('disabled', false)
          $('#set-web-page-2').removeClass 'disabled'
          $('#set-web-page-2').attr('disabled', false)
        else
          $('#web-page-2').addClass 'disabled'
          $('#web-page-2').attr('disabled', true)
          $('#web-page-2').blur() # Possibly not needed here
          $('#set-web-page-2').addClass 'disabled'
          $('#set-web-page-2').attr('disabled', true)

      , this)
    render: () ->
      # TODO: Prevent render on route
      if this.model.get('jed') == undefined
        return
      console.log 4
      this.$el.html(_.template($('#home-template').html(), {
        webPage: this.model.get('webPage')
        userTestingTool: this.model.translate('home_user_testing_tool')
        description:     this.model.translate('home_description')
        enterWebPage:    this.model.translate('home_enter_web_page')
        startTesting:    this.model.translate('home_start_testing')
        reportIssue:     this.model.translate('home_report_issue')
      }))
      $('#web-page-2').focus()
    events: { 'click button#set-web-page-2': 'setWebPage' }
    setWebPage: () ->
      if this.model.get('webPage') == $('#web-page-2').val()
        this.options.router.navigate 'test', true
      else
        this.model.setWebPage($('#web-page-2').val())
  }
