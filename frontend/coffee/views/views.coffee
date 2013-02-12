define ['jquery', 'backbone', 'views/navbar', 'views/iframe', 'views/home', 'views/test', 'views/result'], ($, Backbone, NavbarView, IframeView, HomeView, TestView, ResultView) ->
  Backbone.View.extend {
    initialize: () ->
      navbarView = new NavbarView(this.options)
      iframeView = new IframeView(this.options)
      homeView = new HomeView(this.options)
      testView = new TestView(this.options)
      resultView = new ResultView(this.options)

      this.model.bind('change:webPage', () ->
        this.options.router.navigate('test', { trigger: true})
      , this)

      #          if testRun.get('currentTest') == 0
      #            $('#iframe-view').fadeIn('slow', () ->
      #              $('#test-view').slideDown 'fast'
      #            )
      #          else
      #            do $('#test-view').show
      #            do $('#iframe-view').show
      #        when 'result'
      #          $('#test-nav-button').removeClass 'active'
      #          $('#result-nav-button').addClass 'active'
      #
      #          $('#iframe-view').stop(false, true).hide()
      #          do $('#home-view').hide
      #          $('#test-view').slideUp 'fast'
      #          $('#result-view').fadeIn 'fast'
  }
