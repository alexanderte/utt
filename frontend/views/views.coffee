define ['backbone', 'views/navbar', 'views/iframe', 'views/home', 'views/test', 'views/result'], (Backbone, NavbarView, IframeView, HomeView, TestView, ResultView) ->
  Backbone.View.extend {
    initialize: () ->
      navbarView = new NavbarView(@options)
      iframeView = new IframeView(@options)
      homeView   = new HomeView(@options)
      testView   = new TestView(@options)
      resultView = new ResultView(@options)
  }
