define ['jquery', 'underscore', 'backbone'], ($, _, Backbone) ->
  Backbone.View.extend {
    el: '#navbar-view'
    events: {
      'click button#set-web-page': 'setWebPage'
      'click a.language': 'changeLanguage'
    }
    getCurrentRoute: () ->
      if not Backbone.history.fragment
        return 'home'
      else if Backbone.history.fragment.substr(0, 4) is 'test'
        return 'test'
      else
        return Backbone.history.fragment

    initialize: () ->
      @render()

      @options.router.bind('all', @render, this)
      @options.locale.on('change:locale', @render , this)
    render: () ->
      @$el.html(_.template($('#navbar-template').html(), {
        webPage:            @options.testRun.get('webPage'),
        language:           @options.locale.get('locale')
        state:              @options.testRun.get('state')
        route:              @getCurrentRoute()
        _test:              @options.locale.translate('navbar_test')
        _results:           @options.locale.translate('navbar_results')
        _language:          @options.locale.translate('navbar_language')
        _languageEnglish:   @options.locale.translate('navbar_language_english')
        _languageNorwegian: @options.locale.translate('navbar_language_norwegian')
        _set:               @options.locale.translate('navbar_set')
      }))
    setWebPage: () ->
      @options.testRun.setWebPage($('#web-page').val())
    changeLanguage: (e) ->
      @options.locale.setLocale(e.currentTarget.dataset['language'])
  }
