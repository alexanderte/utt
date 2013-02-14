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
  }
