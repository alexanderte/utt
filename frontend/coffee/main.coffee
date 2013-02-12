requirejs.config {
  baseUrl: 'js/deps'
  paths: {
    collections: '../collections'
    views:       '../views'
    models:      '../models'
    socketio:    'http://localhost:8000/socket.io/socket.io'
  }
  shim: {
    'backbone': {
      deps:    ['underscore']
      exports: 'Backbone'
    }
    'underscore': {
      exports: '_'
    }
    'socketio': {
      exports: 'io'
    }
  }
}

require(['jquery', 'underscore', 'backbone', 'socketio', 'models/test-run', 'views/navbar', 'views/home', 'views/test', 'views/iframe', 'views/result', 'socketio'], ($, _, Backbone, io, TestRun, NavbarView, HomeView, TestView, IframeView, ResultView) ->
  socket = io.connect 'http://localhost:8000'
  testRun = new TestRun(socket)

  AppRouter = Backbone.Router.extend({
    routes: {
      '':         'home'
      'test':     'test'
      'test/:id': 'test'
      'result':   'result'
    }
  })

  appRouter = new AppRouter()

  navbarView = new NavbarView({model: testRun})
  homeView = new HomeView({model: testRun})
  testView = new TestView({model: testRun})
  iframeView = new IframeView({model: testRun})
  resultView = new ResultView({model: testRun})

  do navbarView.render
  do iframeView.render

  activateView = (name) ->
    switch name
      when 'home'
        $('#test-nav-button').removeClass 'active'
        $('#result-nav-button').removeClass 'active'

        $('#iframe-view').stop(false, true).hide()
        do $('#test-view').hide
        do $('#result-view').hide
        $('#home-view').fadeIn 'fast'
      when 'test'
        $('#result-nav-button').removeClass 'active'
        $('#test-nav-button').addClass 'active'

        do $('#home-view').hide
        do $('#result-view').hide

        if testRun.get('currentTest') == 0
          $('#iframe-view').fadeIn('slow', () ->
            $('#test-view').slideDown 'fast'
          )
        else
          do $('#test-view').show
          do $('#iframe-view').show
      when 'result'
        $('#test-nav-button').removeClass 'active'
        $('#result-nav-button').addClass 'active'

        $('#iframe-view').stop(false, true).hide()
        do $('#home-view').hide
        $('#test-view').slideUp 'fast'
        $('#result-view').fadeIn 'fast'

  appRouter.on('route:home', () ->
    do homeView.render
    activateView 'home'
  )
  appRouter.on('route:test', (id) ->
    testRun.set('currentTest', if id == undefined then 0 else parseInt(id))
    do testView.render
    activateView 'test'
  )
  appRouter.on('route:result', () ->
    do resultView.render
    activateView 'result'
  )

  Backbone.history.start()
)
